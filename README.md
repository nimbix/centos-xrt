# CentOS Xilinx Runtime (XRT)

Sample Docker container for JARVICE w/ XRT

Existing containers available at: https://hub.docker.com/r/nimbix/centos-xrt/tags

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on [JARVICE](https://platform.jarvice.com).

### Prerequisites

```
bash
docker
JARVICE account
```

### Installing

Install Docker:

* Ubuntu:   https://docs.docker.com/install/linux/docker-ce/ubuntu/
* Debian:   https://docs.docker.com/install/linux/docker-ce/debian/
* CentOS:   https://docs.docker.com/install/linux/docker-ce/centos/
* Windows:  https://docs.docker.com/docker-for-windows/install/
* MacOS:    https://docs.docker.com/docker-for-mac/install/

Sign up for JARVICE: https://www.nimbix.net/contact-us/

## Example container

This project builds a sample Docker container to use the Xilinx FPGA accelerators available on JARVICE. Create `config.sh` to describe the desired XRT environment.

### config.sh

#### JARVICE_MACHINES

JARVICE machine type for container. Refer to:

* https://jarvice.readthedocs.io/en/latest/machines/
* https://status.jarvice.com/

#### XILINX_SHELL

Xilinx shell for FPGA

#### BASE_IMAGE

Base Docker image for application. (e.g centos:7)

#### GIT_BRANCH

image-common [branch](https://github.com/nimbix/image-common/branches) to include for JARVICE. See the [GitHub repo](https://github.com/nimbix/image-common) for additional information

#### XRT_REPO_DISTVER

O/S distribution for XRT (e.g. 7.4.1708)

#### XRT_REPO_DATE

XRT build date

#### XRT_REPO_MAJOR

XRT major revision

#### XRT_REPO_MINOR

XRT minor revision

#### XRT_REPO_PATCH

XRT patch level

#### DOCKER_REPO

Docker repository to push container (e.g. nimbix/centos-xrt)

### Build Docker container

Create `config.sh` from template

```
cp config.sh.template config.sh
```

Run `build.sh` in terminal

```
./build.sh
```

Push to DockerHub

```
docker login
docker push <DockerHub-account>/<my-repo>:<my-tag>
```

## Deployment

Create a JARVICE application using this container following the [PushToCompute flow](https://nimbix.zendesk.com/hc/en-us/articles/115005270063-Hello-World-Introduction-to-PushToCompute/).

## Versioning

The XRT tags are used for versioning: XRT_REPO_DATE.XRT_REPO_MAJOR.XRT_REPO_MINOR.XRT_REPO_PATCH_XRT_REPO_DISTVER

For the versions available, see the [tags on this repository](https://github.com/nimbix/centos-xrt/tags).

## Authors

* **Kenneth Hill** - *Initial work*

## License

Refer to [LICENSE.md](LICENSE.md) for more details.

