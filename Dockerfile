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
# SIMULATION BUILD
#-------------------------------------------------------------------------------
WORKDIR /software/

RUN git clone https://github.com/cnatzke/griffin_2photon_simulation.git && \
    cd griffin_2photon_simulation

# Adding suppressed files
COPY ./suppressed /software/griffin_2photon_simulation/src

RUN mkdir /software/griffin_2photon_simulation/build && cd /software/griffin_2photon_simulation/build && \
    source /software/${version_geant4}/bin/geant4.sh && \
    cmake -DCMAKE_INSTALL_PREFIX=/software/simulation \
    #-DWITH_GEANT4_UIVIS=OFF .. && \
    .. && \
    make && make install && \
    rm -rf /software/griffin_2photon_simulation

#-------------------------------------------
# Release Container
#-------------------------------------------
# use OSG base container
FROM opensciencegrid/osgvo-ubuntu-20.04:latest

COPY --from=stage1 /software /software

WORKDIR /software