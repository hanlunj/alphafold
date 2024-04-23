#!/bin/bash
docker build -f docker/Dockerfile -t alphafold .
docker rmi $(docker images -f "dangling=true" -q)
