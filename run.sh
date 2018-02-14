#!/bin/bash
docker build --no-cache -t jumpbox .;
docker run --rm -it --name jumpbox1 -v `pwd`:/workdir jumpbox;