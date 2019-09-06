FROM scratch
MAINTAINER Van Simmons <van.simmons@computecycles.com>

VOLUME ["/lib", "/usr/lib"]

COPY ./.build/aarch64-unknown-linux/debug/e16server ./e16server

ENV LD_LIBRARY_PATH=/usr/lib/swift/linux
ENTRYPOINT ["/lib/ld-linux-aarch64.so.1"]
CMD ["./e16server"]

