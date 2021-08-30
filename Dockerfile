FROM nixery.dev/shell/cacert/git/remake/go_1_16/gcc/kustomize as build

WORKDIR /tmp

ENV PATH=/share/go/bin:$PATH
ENV GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt

RUN git clone https://github.com/storageos/operator
RUN git clone https://github.com/storageos/api-manager

ARG GIT_TAG=HEAD

RUN cd operator ; git reset --hard ${GIT_TAG}
RUN cd api-manager ; git reset --hard ${GIT_TAG}

ARG IMG_TAG=develop
ARG IMAGE=storageos/operator:${IMG_TAG}

RUN cd operator ; \
    IMG="${IMAGE}" remake install-manifest

RUN cd api-manager ; \
    remake manifests && \
    kustomize build config/crd > storageos-api-manager-crd.yaml

# Create the final image.

FROM nixery.dev/shell

COPY --from=build /tmp/operator/storageos-operator.yaml /operator.yaml
COPY --from=build /tmp/api-manager/storageos-api-manager-crd.yaml /api-manager.yaml

ENTRYPOINT cat
