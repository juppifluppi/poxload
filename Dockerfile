# Use Rocker RStudio as base for your image
FROM rocker/rstudio

# copy the desired installation script into docker file system, make sure that you have execute rights to the script
COPY install_poxloadreq2.sh /rocker_scripts/

RUN chmod +x /rocker_scripts/install_poxloadreq2.sh

# install the custom packages and system dependencies by running the script
RUN /rocker_scripts/install_poxloadreq2.sh

RUN chmod +x /app/app.sh

ENTRYPOINT ["/bin/sh", "-c", "app.sh"]
