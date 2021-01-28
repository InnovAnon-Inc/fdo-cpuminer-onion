FROM innovanon/fdo-cpuminer as bootstrap
RUN cd     cpuminer-yescrypt                                          \
 && cp -v cpu-miner.c.onion cpu-miner.c                               \
 && make -j$(nproc)                                                   \
 && make install                                                      \
 && git reset --hard                                                  \
 && git clean -fdx                                                    \
 && git clean -fdx                                                    \
 && cd ..                                                             \
 && cd $PREFIX                                                        \
 && rm -rf etc include lib lib64 man share ssl

RUN ls -ltra /opt/cpuminer/bin

FROM innovanon/voidlinux as final
COPY --from=bootstrap /opt/cpuminer/bin/cpuminer /usr/local/bin/
COPY                 ./support                   /usr/local/bin/
ARG TEST
ENV TEST=$TEST
VOLUME /var/cpuminer
ENTRYPOINT ["/usr/bin/env", "sleep"]
CMD ["91"]

