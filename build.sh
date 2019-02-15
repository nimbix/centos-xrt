#!/bin/bash

source ./config.sh
machines=("${JARVICE_MACHINES[@]/%/_${XILINX_SHELL}}")
var=$(printf "\"%q\"," "${machines[@]}")
var=${var%?}
cat AppDef.json.template | sed "s/<jarvice_machines>/$var/g" \
        > ./docker/AppDef.json
docker build --build-arg BASE_IMAGE=${BASE_IMAGE} \
        --build-arg GIT_BRANCH=${GIT_BRANCH} \
        --build-arg XRT_REPO_DISTVER=${XRT_REPO_DISTVER} \
        --build-arg XRT_REPO_DATE=${XRT_REPO_DATE} \
        --build-arg XRT_REPO_MAJOR=${XRT_REPO_MAJOR} \
        --build-arg XRT_REPO_MINOR=${XRT_REPO_MINOR} \
        --build-arg XRT_REPO_PATCH=${XRT_REPO_PATCH} \
        -t ${DOCKER_REPO}:${DOCKER_TAG} \
        --no-cache ./docker
