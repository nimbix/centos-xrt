FROM centos:7 
MAINTAINER Nimbix, Inc.
# Branch for JARVICE Desktop (leave null for default)
ARG GIT_BRANCH
ENV GIT_BRANCH ${GIT_BRANCH:-master}
# JARVICE Desktop
RUN yum install -y curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/$GIT_BRANCH/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop --image-common-branch $GIT_BRANCH
# Add terminal shortcut
RUN mkdir -p /etc/skel/Desktop
ADD exo-terminal-emulator.desktop /etc/skel/Desktop/exo-terminal-emulator.desktop
RUN chmod +x /etc/skel/Desktop/exo-terminal-emulator.desktop
# Metadata for App
ADD AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
# FPGA platform 
# Install Newer version of GCC
ARG GCC_REL_VERSION
ENV GCC_REL_VERSION ${GCC_REL_VERSION:-5.1.0}
ENV GCC_REL_URL https://ftp.gnu.org/gnu/gcc/gcc-${GCC_REL_VERSION}/gcc-${GCC_REL_VERSION}.tar.bz2
RUN curl ${GCC_REL_URL} -O
RUN yum install -y gmp-devel mpfr-devel libmpc-devel bzip2
RUN yum groupinstall -y Development tools
RUN tar -jxvf gcc-${GCC_REL_VERSION}.tar.bz2
RUN mkdir gcc-${GCC_REL_VERSION}-build
RUN cd gcc-${GCC_REL_VERSION}-build && ../gcc-${GCC_REL_VERSION}/configure --enable-languages=c,c++ --disable-multilib
RUN make -j4 -C gcc-${GCC_REL_VERSION}-build && make -C gcc-${GCC_REL_VERSION}-build install
RUN rm -rf /gcc-${GCC_REL_VERSION}*
# Add local GCC to LD_LIBRARY_PATH
RUN echo 'LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH' > /etc/profile.d/jarvice-xrt.sh
# Install Xilinx runtime
ARG XRT_REPO_DISTVER
ENV XRT_REPO_DISTVER ${XRT_REPO_DISTVER:-7.4.1708}

ARG XRT_REPO_DATE
ENV XRT_REPO_DATE ${XRT_REPO_DATE:-201802}

ARG XRT_REPO_MAJOR
ENV XRT_REPO_MAJOR ${XRT_REPO_MAJOR:-2}

ARG XRT_REPO_MINOR
ENV XRT_REPO_MINOR ${XRT_REPO_MINOR:-1}

ARG XRT_REPO_PATCH
ENV XRT_REPO_PATCH ${XRT_REPO_PATCH:-83}

ENV XRT_REPO_URL https://www.xilinx.com/support/download/xrt/xrt-${XRT_REPO_DATE}-${XRT_REPO_MAJOR}-${XRT_REPO_MINOR}-${XRT_REPO_PATCH}/xrt_${XRT_REPO_DATE}.${XRT_REPO_MAJOR}.${XRT_REPO_MINOR}.${XRT_REPO_PATCH}_${XRT_REPO_DISTVER}.rpm
RUN curl -O ${XRT_REPO_URL} 
RUN yum install -y /*.rpm && \
    rm /*.rpm
# Update XRT setup.sh to check for CentOS 7.6
RUN sed -i 's/\[\[ $OSREL != \"7.5\"\* \]\]/\[\[ $OSREL != \"7.5\"\* \]\] \&\& \[\[ $OSREL != \"7.6\"\* \]\]/g' /opt/xilinx/xrt/setup.sh
# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
