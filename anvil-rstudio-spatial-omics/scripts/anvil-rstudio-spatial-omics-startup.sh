#!/usr/bin/env bash

R -e "install.packages(c('pheatmap', 'viridis'))"

R -e "if (!require('BiocManager', quietly = TRUE)) install.packages('BiocManager')"

R -e "BiocManager::install(c('bandle', 'pRoloc', 'pRolocdata'))"

