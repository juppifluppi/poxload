FROM python:3.8-slim-buster AS final-image

# R version to install
ARG R_BASE_VERSION=4.1.0

ARG PREBUILD_DEPS="software-properties-common gnupg2"
ARG BUILD_DEPS="build-essential binutils cmake gfortran libblas-dev liblapack-dev libjpeg-dev libpng-dev libnlopt-dev pkg-config"
ARG RUNTIME_DEPS="r-base=${R_BASE_VERSION}-* libcurl4-openssl-dev libssl-dev libxml2-dev"
# venv path
ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update \
    # Adding this to install latest versions of g++
    && echo 'deb http://deb.debian.org/debian testing main' > /etc/apt/sources.list.d/testing.list \
    # Install the below packages to add repo which is then used to install R version 4
    && apt-get install -y --no-install-recommends $PREBUILD_DEPS \
    && add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/'\
    # This key is required to install r-base version 4
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key FCAE2A0E115C3D8A \
    # Update again to use the newly added sources
    && apt-get update \
    && apt-get install -y libxrender1 default-jre-headless
    && apt-get install -y --no-install-recommends $RUNTIME_DEPS $BUILD_DEPS \
    && python -m venv /opt/venv \
    && /opt/venv/bin/python -m pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt packages.R /

RUN pip install wheel setuptools \
    && pip install --no-cache-dir -r requirements.txt \
    && Rscript packages.R \
    && strip --strip-unneeded usr/local/lib/R/site-library/Boom/lib/libboom.a \
    && strip --strip-debug /usr/local/lib/R/site-library/*/libs/*so \
    # Uninstall unnecessary dependencies
    && rm -rf /tmp/* \
    && apt-get purge -y --auto-remove $BUILD_DEPS $PREBUILD_DEPS \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*
    
ENTRYPOINT [ "/app.sh" ]
