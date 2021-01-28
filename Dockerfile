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
COPY ./support  /usr/local/bin/

FROM scratch as squash
COPY --from=bootstrap / /
RUN chown -R tor:tor /var/lib/tor
SHELL ["/usr/bin/bash", "-l", "-c"]
ARG TEST
ENV TEST=$TEST
VOLUME /var/cpuminer
ENTRYPOINT ["/usr/bin/env", "sleep"]
CMD ["91"]

