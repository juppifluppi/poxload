# Use a minimal Python 3.8 image 

FROM python:3.8-ubi8



# Switch to root to perform privileged operations

USER root



# Install libXrender 

RUN yum install -y libXrender && yum clean all



# Create a non-root user without a password

RUN useradd --no-log-init --create-home --shell /bin/bash appuser



# Set the working directory

WORKDIR /usr/src/app



# Copy the application files

COPY . .





RUN chmod +x app.sh



# Install Python dependencies for Streamlit

RUN pip install --upgrade pip && \

    pip install --no-cache-dir -r requirements.txt



# Set permissions

RUN chown -R appuser:appuser /usr/src/app



# Switch to the non-root user

USER appuser



# Expose the port Streamlit will run on

EXPOSE 8080



# Set the entrypoint to the app.sh script

ENTRYPOINT ["./app.sh"]
