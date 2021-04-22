# docker-klar

Builds a Docker image of `klar` from the binary release.

Simply downloads the binary release (`klar_version`) from GitHub and installs it
to an Alpine image (`alpine_version`).

```bash
docker build -t steampunkfoundry/klar --build-arg klar_version=2.4.0 --build-arg alpine_version=3.12 .
```

## Rationale

The current `Dockerfile` from [optiopay/klar](https://github.com/optiopay/klar)
is failing to build due to changes in v4 of [quay/clair](https://github.com/quay/clair).

```text
 => ERROR [builder 3/4] RUN go get -d github.com/optiopay/klar                                                     5.3s
------
 > [builder 3/4] RUN go get -d github.com/optiopay/klar:
#10 5.285 package github.com/coreos/clair/database: cannot find package "github.com/coreos/clair/database" in any of:
#10 5.285       /usr/local/go/src/github.com/coreos/clair/database (from $GOROOT)
#10 5.285       /go/src/github.com/coreos/clair/database (from $GOPATH)
------
executor failed running [/bin/sh -c go get -d github.com/optiopay/klar]: exit code: 1
```

The `coreos/clair/database` module does not exist in Clair v4 but existed in v2.
