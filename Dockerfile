# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Modified by Christian Diener
# Changes distributed under the MIT License.
FROM rocker/r-base

MAINTAINER Christian Diener <mail@cdiener.com>

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    wget \
    build-essential \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    sudo \
    locales \
    libopenblas-base \
    libzmq3-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER docker
ENV NB_UID 1000

# Create docker user with UID=1000 and in the 'users' group
RUN mkdir -p /opt/conda && \
    chown docker /opt/conda

USER docker

# Setup docker home directory
RUN mkdir /home/$NB_USER/work && \
    mkdir /home/$NB_USER/.jupyter && \
    mkdir /home/$NB_USER/.local

# Install conda as docker
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda-latest-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install -yq conda && conda update -yq --all

# Install Jupyter notebook as docker
RUN conda install -yq -c bioconda \
    jupyter \
    terminado \
    numpy \
    matplotlib=1.4.3 \
    nomkl \
    pandas \
    scipy \
    qiime \
    && conda clean -ty


RUN mkdir -p $HOME/.config/matplotlib \
    && echo "backend: agg" > /home/$NB_USER/.config/matplotlib/matplotlibrc

USER root

COPY install.R .
RUN Rscript install.R && rm install.R && rm -rf /tmp/*

# Configure container startup as root
EXPOSE 8888
WORKDIR /home/$NB_USER/work
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/minimal-notebook/start-notebook.sh /usr/local/bin/
RUN chmod a+rx /usr/local/bin/start-notebook.sh
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/minimal-notebook/jupyter_notebook_config.py /home/$NB_USER/.jupyter/
RUN chown -R $NB_USER:users /home/$NB_USER/.jupyter

# Switch back to docker to avoid accidental container runs as root
USER docker
