FROM ghcr.io/toltec-dev/qt:v2.3 AS build-stage

RUN mkdir -p /build
COPY . /build
WORKDIR /build
RUN cmake && \
    mkdir -p build && \
    mkdir -p install && \
    cd build && \
    cmake -DCMAKE_TOOLCHAIN_FILE="/usr/share/cmake/$CHOST.cmake" \
        -DCMAKE_INSTALL_PREFIX="../install" -DCMAKE_BUILD_TYPE=Release .. && \
    cd apps/yaft && \
    make && \
    cat Makefile && \
    make install

FROM scratch AS export-stage
COPY --from=build-stage /build /
