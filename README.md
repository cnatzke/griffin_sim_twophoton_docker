# Getting Started
This is a containerized version of the GRIFFIN Geant4 simulation used for two-photon emission studies. The simulation contains the PEEK source holder and ```/gun/``` commands to properly simulate a finite radius source.  

## Building 
To build the docker image, run the below command:
```
docker build --tag <tag> .
```
in the directory containing the files `Dockerfile`

## Running 
To run the container as root user:
```
docker run -it --rm=true cnatzke/griffin_2photon_sim:latest
```
To run similar to the OSG implementation (recommended)
```
docker run --user $(id -u):$(id -g) --rm=true -it -v $(pwd):/scratch -w
/scratch cnatzke/griffin_2photon_sim:latest /bin/bash 
```
