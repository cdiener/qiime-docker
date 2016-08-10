[![Docker Pulls](https://img.shields.io/docker/pulls/cdiener/qiime-docker.svg?maxAge=2592000)](https://hub.docker.com/r/cdiener/qiime-docker/)

# qiime-docker

Docker image for our Qiime pipeline. 

Get it with

```bash
docker pull cdiener/qiime-docker
```

For a version that has the R kernel and DADA2 installed as well use

```bash
docker pull cdiener/qiime-docker:dada2
```

Than run with

```
docker run -p 8888:8888 cdiener/qiime-docker
```

and open you browser at http://localhost:8888.

For advanced usage the image also supports all jupyter minimal-notebook environment variables such as enabling HTTPS and
specifying a password. [See here](https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook) for more infos.
