FROM r-base:3.4.3

RUN apt-get update && apt-get install -y libssl-dev libcurl4-openssl-dev libxml2-dev

# Install R packages like plumber and mlrMBO
RUN Rscript -e "chooseCRANmirror(ind=1); install.packages(c('stringi', 'plumber', 'mlrMBO'))"

# Copy server files to the image
COPY startup.r api.r /root/

# Expose HTTP
EXPOSE 8000

# Run server
WORKDIR /root/
CMD Rscript startup.r
