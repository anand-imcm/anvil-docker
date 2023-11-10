FROM ghcr.io/bioconductor/ml-verse:3.17 as build

RUN apt-get update && apt-get install -yq --no-install-recommends \
    gnupg \
    lsb-release \
 && echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
    google-cloud-sdk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 -V \
    && pip3 install --no-cache-dir -U crcmod terra-notebook-utils

# add rstudio user to users group
RUN usermod -g users rstudio \
    && useradd -m -s /bin/bash -N -u 1001 welder-user

# google-cloud R packages
# RUN R -e "BiocManager::install(c('AnVIL', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse', 'Seurat', 'markdown', 'SingleCellExperiment', 'GenomicFeatures', 'GenomicAlignments', 'ShortRead', 'DESeq2', 'AnnotationHub', 'ExperimentHub', 'ensembldb', 'scRNAseq', 'scran', 'Rtsne'))"
RUN R -e "BiocManager::install(c('AnVIL', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse',  'markdown'))"

ENV RSTUDIO_PORT 8001

ENV RSTUDIO_HOME /etc/rstudio

ENV RSTUDIO_USERSETTING /home/rstudio/.config/rstudio/rstudio-prefs.json

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

RUN sed -i 's/"always_save_history": false/"always_save_history": true/g'  $RSTUDIO_USERSETTING \
 && sed -i 's/"save_workspace": "never"/"save_workspace": "always"/g' $RSTUDIO_USERSETTING

EXPOSE $RSTUDIO_PORT

COPY scripts ${RSTUDIO_HOME}/scripts

RUN find ${RSTUDIO_HOME}/scripts -name '*.sh' -type f | xargs chmod +x \
 && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add micromamba to PATH
ENV PATH="/root/micromamba/bin:${PATH}"

ENV MAMBA_ROOT_PREFIX="/root/micromamba"

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba \
    && ./bin/micromamba shell init -s bash -p ~/micromamba -y \
    && echo "source ~/micromamba/etc/profile.d/micromamba.sh" >> ~/.bashrc \
    && micromamba install -y -n base -c bioconda bcftools

FROM ghcr.io/bioconductor/ml-verse:3.17 as final

COPY --from=build / /

RUN echo "source ~/micromamba/etc/profile.d/micromamba.sh" >> ~/.bashrc

ENV RSTUDIO_PORT 8001

ENV RSTUDIO_HOME /etc/rstudio

ENV RSTUDIO_USERSETTING /home/rstudio/.config/rstudio/rstudio-prefs.json