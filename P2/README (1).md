# Part 2

The purpose of this part is deploy app to k3s cluster

In this part we will setup k3s cluster with just one server and deploy our config to this

To simple, we use an application from docker paulbouwer/hello-kubernetes

Like part 1, all setup will be in vagrant, before go this part lets destroy p1 to save our resource `vagrant destroy`

Some helpful command for this part

```
## Create file config
$ k create deployment app-one image=paulbouwer/hello-kubernetes:1.10 --dry-run --output=yaml
$ k create service clusterip app-one --tcp=80:8080 --dry-run --output=yaml
$ k create ingress app-ingress --rule="/*=app-three-service:http" --rule="app1.com/*=app-one-service:http" --rule="app2.com/*=app-two-service:http"  --dry-run --output=yaml

## Deploy an config
$ k apply -f config.yaml

## Get ingress
$ k get ingress

```
