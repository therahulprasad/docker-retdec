FROM ubuntu:bionic as builder
#FROM therahulprasad/retdec:v0 as builder

# install dependencies
RUN apt-get update
RUN apt-get -y install build-essential cmake git perl python3 bison flex libfl-dev autoconf automake libtool pkg-config m4 zlib1g-dev upx doxygen graphviz

# Clone repository
RUN git clone https://github.com/avast-tl/retdec

# build
RUN ls /installation || mkdir /installation
WORKDIR /retdec
RUN ls build || mkdir build
WORKDIR /retdec/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/installation
RUN make -j4
RUN make install
WORKDIR /installation

########## FINAL IMAGE #########
FROM ubuntu:bionic

RUN apt-get update
RUN apt-get -y install python3
# Copy binary file
RUN ls /retdec || mkdir /retdec
COPY --from=builder /installation/ /retdec/

ENTRYPOINT [ "/retdec/bin/retdec-decompiler.py" ]
