FROM ubuntu:jammy

# Somewhat derived from https://hub.docker.com/r/staphb/minimap2/dockerfile

# for easy upgrade later. ARG variables only persist during image build time
ARG MINIMAP2_VER="2.24"

ENV DEBIAN_FRONTEND=noninteractive


# install deps and cleanup apt garbage
RUN apt-get update && apt-get install -y python3 \
 python3-pip \
 python3-venv \
 curl \
 bzip2 \
 tabix \
 samtools \
 git \
 sambamba && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

# install minimap2 binary
RUN curl -L https://github.com/lh3/minimap2/releases/download/v${MINIMAP2_VER}/minimap2-${MINIMAP2_VER}_x64-linux.tar.bz2 | tar -jxvf - 

ENV PATH="${PATH}:/minimap2-${MINIMAP2_VER}_x64-linux"

# Set up venv:
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


#Install CoLoRGen from GitHub:
RUN mkdir -p /opt
WORKDIR /opt
RUN git clone https://github.com/laurentijntilleman/CoLoRGen.git
RUN chmod a+x CoLoRGen/CoLoRGen

RUN pip install --upgrade pip
RUN pip install medaka 
RUN pip install pandas 
RUN pip install gtfparse
RUN pip install bio 

ENV PATH="$PATH:/opt/CoLoRGen"
