FROM ubuntu:20.04
LABEL Description="NCBI EDirect" Vendor="NCBI/NLM/NIH" 

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get -y -m update && apt-get install -y curl cpanminus libxml-simple-perl libwww-perl libnet-perl build-essential && rm -rf /var/lib/apt/lists/*
RUN sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

ENV PATH="/root/edirect:${PATH}"
RUN apt-get update && apt-get install -y libxml2-utils xsltproc

CMD ["/bin/bash"]

