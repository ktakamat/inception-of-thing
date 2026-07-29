# Bonus

The purpose of this part is setup a gitlab instance in our k3s cluster we had setup in p3, and create new repo in gitlab, using argocd to deploy this repo


Deploy gitlab config to our cluster
```
kubectl apply -f gitlab.yaml
```

Its take a time we need waiting, lets go eat something and go back

After its startup, we need get root password

```
kubectl -n gitlab exec -it deployment.apps/gitlab -- bash
cat /etc/gitlab/initial_root_password
```

```
user@localhost:~/p3$ k -n gitlab get ingress
NAME     CLASS     HOSTS                ADDRESS      PORTS   AGE
argocd   traefik   gitlab.example.com   172.18.0.2   80      34s
```

We can add this to /etc/hosts for we can access from firefox

```
[...]
172.18.0.2  gitlab.example.com
```


Open firefox, go to gitlab.example.com, login by root acc, create new repo, create file deployment, go to argocd setup application

Notes: The url for the repo should be: http://gitlab.gitlab/<username>/<repo>.git, its follow k3s dns <service>.<namespace>
