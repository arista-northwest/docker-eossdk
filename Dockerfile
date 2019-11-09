FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive

ENV CROSS_COMPILER_DIR=/opt/arista/fc18-gcc6.3.1-glibc2.18
ENV CROSS_COMPILER_DEB=arista-fc18-gcc6-3-1-glibc2-18.deb
ENV SDK_STUBS=EosSdk-stubs-2.8.0.tar.gz

ENV GOPATH=/eossdk/go
ENV GOROOT=/go
ENV GOVER=1.13.4
ENV GOOS=linux
ENV GOARCH=amd64

ENV CC=${CROSS_COMPILER_DIR}/bin/gcc
ENV CXX=${CROSS_COMPILER_DIR}/bin/c++
ENV PATH=${CROSS_COMPILER_DIR}/bin:$PATH
ENV PATH=$GOROOT/bin:$PATH
ENV CGO_CXXFLAGS=-std=c++11

RUN \
    apt update && \
    apt upgrade -y && \
    #apt install -y libc6-i386 && \
    apt install -y make && \
    #apt install -y lib32z1 && \
    apt install -y wget && \
    apt install -y git

#
# Install cross-compiler
#
COPY ${CROSS_COMPILER_DEB} .
RUN dpkg -i ${CROSS_COMPILER_DEB} && rm -f ${CROSS_COMPILER_DEB}

#
# Install Golang
#
RUN \
    wget -qO - https://dl.google.com/go/go${GOVER}.${GOOS}-${GOARCH}.tar.gz | \
    tar xz -C /

#
# Build/Install SDK stubs
#
WORKDIR /eossdk
COPY ${SDK_STUBS} /tmp/
RUN tar -zxf /tmp/${SDK_STUBS} -C /eossdk --strip-components 1

RUN \
    ./build.sh && \
    make install

VOLUME ["/project"]
WORKDIR /project