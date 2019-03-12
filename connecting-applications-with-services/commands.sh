# Exposing pods to the cluster
kubectl create -f ./run-my-nginx.yaml
kubectl get pods -l run=my-nginx -o wide
kubectl get pods -l run=my-nginx -o yaml | grep podIP
# Creating a Service
kubectl expose deployment/my-nginx
kubectl get svc my-nginx
kubectl describe svc my-nginx
kubectl get ep my-nginx
# Acessing service
kubectl exec $POD -- printenv | grep SERVICE
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=2;
kubectl get pods -l run=my-nginx -o wide
kubectl exec $POD -- printenv | grep SERVICE
kubectl get services kube-dns --namespace=kube-system
kubectl run curl --image=radial/busyboxplus:curl -i --tty
### nslookup my-nginx //this tells me a couple server ip addresses. And
### I think it tells me the kubernetes services they are associated with.
# Securing the Service
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /d/tmp/nginx.key -out /d/tmp/nginx.crt -subj "/CN=my-nginx/O=my-nginx"
cat /d/tmp/nginx.crt | base64
cat /d/tmp/nginx.key | base64
kubectl create -f nginxsecrets.yaml
kubectl get secrets
kubectl delete deployments,svc my-nginx; kubectl create -f ./nginx-secure-app.yaml
kubectl get pods -o yaml | grep -i podip
curl -k https://$PODIP ##this was destined to fail?
kubectl create -f ./curlpod.yaml ##fails to launch. Cant connect to the ip address it wants to.
kubectl get pods -l app=curlpod ##is running
kubectl exec $DEPLOYMENT -- curl https://my-nginx --cacert /etc/nginx/ssl/nginx.crt
# Exposing the Service
kubectl get svc my-nginx -o yaml | grep nodePort -C 5
kubectl get nodes -o yaml | grep ExternalIP -C 2
curl https://$EXTERNALIP:$NODEPORT -k
kubectl edit svc my-nginx
kubectl get svc my-nginx
curl https://$EXTERNALIP -k
kubectl describe service my-nginx

