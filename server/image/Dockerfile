# Use builds from launchpad
FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive

# Install system packages
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y r-base-dev sudo curl git libcurl4-openssl-dev libssl-dev libxml2-dev python3 python3-pip wget

# Install python packages
RUN pip3 install flask flask_restful pyRserve

# Install R packages mlrMBO and needed packages
RUN Rscript -e "chooseCRANmirror(ind=1); pti = c('stringi','mlrMBO','rjson','DiceKriging','rgenoud'); install.packages(pti); stopifnot(all(pti %in% installed.packages()))"

# Install Rserve
RUN wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz
RUN R CMD INSTALL Rserve_1.8-6.tar.gz

# Copy server files to the image
ADD main.sh *.py *.R /root/

# Expose HTTP
EXPOSE 5000

# Run server
WORKDIR /root/
CMD /root/main.sh
