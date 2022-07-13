#----------------------------------------------------------
# Author: C. Natzke
# Creation Date: July 2022
# Update:
# Purpose: Multistage docker container for GRIFFIN two-photon simulations 
#----------------------------------------------------------

#-------------------------------------------
# Build Container
#-------------------------------------------
FROM cnatzke/geant4.10.07:latest as stage1

ARG version_geant4="geant4.10.07.p03"
ARG version_clhep="2.2.0.4"

SHELL ["/bin/bash", "-c"]

#-------------------------------------------------------------------------------
# ROOT Install
#-------------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install --no-install-recommends -yy  \
    build-essential \
    dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev python libssl-dev && \
    rm -rf /var/lib/apt/lists/*


RUN wget https://root.cern/download/root_v6.26.04.Linux-ubuntu20-x86_64-gcc9.4.tar.gz --output-document /var/tmp/root.tar.gz && \
    tar zxf /var/tmp/root.tar.gz -C /software && \
    rm /var/tmp/root.tar.gz

#-------------------------------------------------------------------------------
# SIMULATION BUILD
#-------------------------------------------------------------------------------
WORKDIR /software/


RUN git clone https://github.com/cnatzke/griffin_2photon_simulation.git && \
    cd griffin_2photon_simulation

# Adding suppressed files
COPY ./suppressed /software/griffin_2photon_simulation/src

RUN mkdir /software/griffin_2photon_simulation/build && cd /software/griffin_2photon_simulation/build && \
    source /software/root/bin/thisroot.sh && \
    source /software/${version_geant4}/bin/geant4.sh && \
    cmake -DCMAKE_INSTALL_PREFIX=/software/simulation \
    .. && \
    make -j && make install && \
    rm -rf /software/griffin_2photon_simulation

##-------------------------------------------
## Release Container
##-------------------------------------------
## use OSG base container
FROM opensciencegrid/osgvo-ubuntu-20.04:latest

COPY --from=stage1 /software /software

WORKDIR /software