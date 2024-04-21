FROM informaticsmatters/rdkit-python3-debian:Release_2022_09_5

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    nginx \
    libxrender1 \
    automake \
    libcurl4-gnutls-dev \
    libssl-dev \
    postgresql-client \
    cmake \
    default-jdk \
    git \
    libcurl4 \
    autoconf \
    expect \
    fakeroot \
    fuse \
    gcc \
    libc-dev \
    lsof \
    make \
    p7zip-full \
    patchelf \
    sudo \
    valgrind \
    wget \
    bash \
    grep \
    curl \
    libtool \
    g++ \
    libgit2-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    r-base-dev \
    libboost-dev \
    libbz2-dev \
    clang \
    libgtk-3-dev \
    libxml2-dev \
    libx11-dev \
    libpam0g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' appuser

WORKDIR /tmp

COPY . .

RUN chown -R appuser:appuser /tmp
RUN chmod -R 755 /tmp

RUN rm -f /usr/lib/python3.11/EXTERNALLY-MANAGED

RUN pip install --default-timeout=100 stmol pandas matplotlib scipy seaborn numpy mordredcommunity streamlit-ketcher filelock

RUN chmod +x app.sh

RUN Rscript -e "install.packages('devtools', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('tidyverse', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('kernlab', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('caret', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('purrr', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('dplyr', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('xgboost', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('randomForest', repos='http://cran.rstudio.com/', dependencies=TRUE )"
RUN Rscript -e "install.packages('devtools', repos='http://cran.rstudio.com/', dependencies=TRUE )"

USER appuser

EXPOSE 8080

ENTRYPOINT ["./app.sh"]
