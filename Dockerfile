# Use the official Apache APISIX base image
FROM apache/apisix:latest

# Set the working directory
WORKDIR /usr/local/apisix

# Copy the custom declarative configuration files to the appropriate location
COPY static/config.yaml /usr/local/apisix/conf/config.yaml
COPY static/apisix.yaml /usr/local/apisix/conf/apisix.yaml

# Copy the startup script
COPY static/start-apisix.sh /usr/local/bin/start-apisix.sh

# Copy the python jwks to pem script
COPY static/get_dxp_pem.py /usr/local/apisix/get_dxp_pem.py

# Set to root in order to change permissions
USER root

# Change owner of files
RUN chown apisix:apisix /usr/local/apisix/conf/config.yaml
RUN chown apisix:apisix /usr/local/apisix/conf/apisix.yaml
RUN chown apisix:apisix /usr/local/apisix/get_dxp_pem.py
RUN chown apisix:apisix /usr/local/bin/start-apisix.sh

# Update package list and install jq, hexdump (bsdmainutils), and curl
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install requests cryptography pyyaml

# Make the startup script executable
RUN chmod +x /usr/local/bin/start-apisix.sh

# Be apisix again
USER apisix

# Expose the necessary ports
EXPOSE 9080 9443

# Start the custom script and then Apache APISIX
CMD ["/bin/sh", "-c", "/usr/local/bin/start-apisix.sh"]
