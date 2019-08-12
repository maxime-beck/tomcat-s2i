# Tomcat - Source-to-Image Builder
This repository provides a CentOS-based Docker image that enables Source-to-Image (S2I) building for Tomcat. It builds the sources of your webapp and deploys it to a fully functional containerized Tomcat Server. The generated image can then easily be deployed locally or to your Openshift Server.

## Usage
To use the provided image, you'll first need to install [Openshift S2I](https://github.com/openshift/source-to-image#installation). Then simply run the following command:
```bash
$ s2i build [SOURCE_URL] maxbeck/tomcat-s2i [IMAGE_TAG]
```
Where `[SOURCE_URL]` is either the URL to your Git repository or the path to your local sources. `maxbeck/tomcat-s2i` is a ready-to-use image of the builder. You can either use it directly or build your version following the instructions of the [Build section](https://github.com/maxime-beck/tomcat-s2i#build-the-image). Finally, `[IMAGE_TAG]` is simply the tag you would like to assign to the generated image.

Once built, you can run it locally:
```bash
$ docker run -p 8080:8080 [IMAGE_TAG]
```
Or push it to a Docker Registry for further use on your Openshift Server via the [Tomcat Operator](https://github.com/maxime-beck/tomcat-operator):
```bash
$ docker push [IMAGE_TAG]
```

## Build the Image
You can build the Tomcat-S2I Docker image by cloning the present repository and running `make build`:
```bash
$ git clone https://github.com/maxime-beck/tomcat-s2i.git
$ cd tomcat-s2i/
$ make build
```
By default, the Makefile will build it under the tag `docker.io/maxbeck/tomcat-s2i:latest`. Feel free to edit it to customize the image tag by altering the following variables:
```
DOCKER_REPO ?= docker.io/
IMAGE ?= maxbeck/tomcat-s2i
TAG ?= latest
```