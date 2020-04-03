FROM ubuntu:latest

ENV CROSS_COMPILER_DEB=arista-centos7-5-gcc6-5-0-glibc2-17.deb
ENV CROSS_COMPILER_DIR=/opt/arista/centos7.5-gcc6.5.0-glibc2.17
ENV EOSSDK_STUBS_VER=2.11.0

RUN apt-get update && \
        apt-get install -y libtool automake && \
        apt-get install -y build-essential

ADD deps deps

RUN dpkg -i deps/${CROSS_COMPILER_DEB}

ENV PATH=${CROSS_COMPILER_DIR}/bin:$PATH

# RUN \
#     tar -xvf deps/EosSdk-stubs-${EOSSDK_STUBS_VER}*.tar.gz && \
#     cd EosSdk-stubs-${EOSSDK_STUBS_VER} && \
#     ./bootstrap && \
#     ./build.sh --m32 && \
#     make install

VOLUME ["/project"]
WORKDIR /project

ENTRYPOINT [ "/bin/bash" ]