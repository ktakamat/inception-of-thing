# Part 3

The purpose of this part is setup a k3s cluster by using k3d, install argocd, config an application in argocd


Before go this part lets destroy p2 to save our resource `vagrant destroy`

Some helpful command for this part
```
./scripts/p3.sh install_deps # install all depedencies for this part
./scripts/p3.sh up # create k3d cluster, install argocd
kubectl -n argocd get ingress # get ingress info
```

After get ingress info, we have something like this

```
user@localhost:~/p3$ k -n argocd get ingress
NAME     CLASS     HOSTS                ADDRESS      PORTS   AGE
argocd   traefik   argocd.example.com   172.18.0.2   80      34s
```

We can add this to /etc/hosts for we can access from firefox

```
[...]
172.18.0.2  argocd.example.com
```


Open firefox, go to argocd.example.com, login with admin, password printed in step up or (echo $(k -n argocd get secret/argocd-initial-admin-secret -ojsonpath="{.data.password}" | base64 -d))
