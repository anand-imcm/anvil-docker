FROM ghcr.io/bioconductor/ml-verse:3.19 AS build

RUN apt-get update && apt-get install -yq --no-install-recommends build-essential curl wget \
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
    && pip3 install --no-cache-dir -U crcmod terra-notebook-utils torch==2.0.1

# add rstudio user to users group
RUN usermod -g users rstudio \
    && useradd -m -s /bin/bash -N -u 1001 welder-user

RUN R -e "BiocManager::install(c('AnVIL', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse', 'reshape2', 'aggregateBioVar', 'annotables', 'argparser', 'AUCell', 'clusterProfiler', 'ComplexHeatmap', 'cowplot', 'data.table', 'DESeq2', 'DGCA', 'DOSE', 'dplyr', 'DropletUtils', 'DT', 'enrichplot', 'flexmix', 'GEOquery', 'ggplot2', 'ggpubr', 'glmnet', 'grDevices', 'grid', 'GSEABase', 'hgnc', 'Matrix', 'mvtnorm', 'NMF', 'optparse', 'org.Hs.eg.db', 'patchwork', 'pathview', 'plotly', 'qusage', 'SAVER', 'scater', 'scCustomize', 'scmap', 'Seurat', 'SingleCellExperiment', 'standR', 'stringr', 'tidyr', 'viridis', 'markdown', 'rmarkdown', 'quarto', 'palmerpenguins'))"

ENV RSTUDIO_PORT=8001
ENV RSTUDIO_HOME=/etc/rstudio
ENV RSTUDIO_USERSETTING=/home/rstudio/.config/rstudio/rstudio-prefs.json

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

RUN sed -i 's/"always_save_history": false/"always_save_history": true/g'  $RSTUDIO_USERSETTING \
 && sed -i 's/"save_workspace": "never"/"save_workspace": "always"/g' $RSTUDIO_USERSETTING

EXPOSE $RSTUDIO_PORT

COPY scripts ${RSTUDIO_HOME}/scripts

RUN find ${RSTUDIO_HOME}/scripts -name '*.sh' -type f | xargs chmod +x \
 && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site

RUN apt-get clean && rm -rf /var/lib/apt/lists/*


FROM ghcr.io/bioconductor/ml-verse:3.19 AS final
COPY --from=build / /

ENV RSTUDIO_PORT=8001
ENV RSTUDIO_HOME=/etc/rstudio
ENV RSTUDIO_USERSETTING=/home/rstudio/.config/rstudio/rstudio-prefs.json