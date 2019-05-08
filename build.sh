#!/bin/bash
#
# Copyright (c) 2019, Nimbix, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are 
# those of the authors and should not be interpreted as representing official 
# policies, either expressed or implied, of Nimbix, Inc.
#

source ./config.sh
machines=("${JARVICE_MACHINES[@]/%/_${XILINX_SHELL}}")
var=$(printf "\"%q\"," "${machines[@]}")
var=${var%?}
cat AppDef.json.template | sed "s/<jarvice_desc>/${var//\"}/g" \
        > ./docker/AppDef2.json
cat ./docker/AppDef2.json | sed "s/<jarvice_machines>/$var/g" \
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
