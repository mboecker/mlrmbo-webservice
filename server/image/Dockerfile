FROM r-base:3.4.3

RUN apt-get update && apt-get install -y libssl-dev libcurl4-openssl-dev libxml2-dev python3 python3-pip

RUN pip3 install flask flask_restful

# Install R packages like plumber and mlrMBO
RUN Rscript -e "chooseCRANmirror(ind=1); install.packages(c('stringi', 'mlrMBO'))"

# Copy server files to the image
COPY *.py *.R /root/

# Expose HTTP
EXPOSE 5000

# Run server
WORKDIR /root/
CMD python3 main.py
