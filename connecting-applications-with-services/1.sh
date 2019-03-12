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
kubectl exec $POD -- printenv | grep SERVICE # reveal services your pod knows about
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=2; # refresh pods after creating service, now the pods ...
kubectl get pods -l run=my-nginx -o wide
kubectl exec $POD -- printenv | grep SERVICE # reveal services your pod knows about
kubectl get services kube-dns --namespace=kube-system
kubectl run curl --image=radial/busyboxplus:curl -i --tty # this is a service discovery pod? I just put another pod in the cluster, thats all.
### nslookup my-nginx //this tells me a couple server ip addresses. And
### I think it tells me the kubernetes services they are associated with. # I can http to other pods on the cluster. curl -k http://$PODIP:80. it works.
# Securing the Service
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /d/tmp/nginx.key -out /d/tmp/nginx.crt -subj "/CN=my-nginx/O=my-nginx"
cat /d/tmp/nginx.crt | base64
cat /d/tmp/nginx.key | base64
kubectl create -f nginxsecrets.yaml
kubectl get secrets
kubectl delete deployments,svc my-nginx; kubectl create -f ./nginx-secure-app.yaml # make a new deployment and service: add volume, use https image
kubectl get pods -o yaml | grep -i podip
curl -k https://$PODIP ##this was destined to fail? I also try to use the service IP address and the nodeport. No Good.
kubectl create -f ./curlpod.yaml ##fails to launch. Cant connect to the ip address it wants to.
kubectl get pods -l app=curlpod ##is running
kubectl exec $DEPLOYMENT -- curl https://my-nginx --cacert /etc/nginx/ssl/nginx.crt #DEPLOYMENT needs to be the k8s name for a pod 
# Exposing the Service
kubectl get svc my-nginx -o yaml | grep nodePort -C 5
kubectl get nodes -o yaml | grep ExternalIP -C 2
curl https://$EXTERNALIP:$NODEPORT -k
# kubectl edit svc my-nginx
# kubectl get svc my-nginx
# curl https://$EXTERNALIP -k
# kubectl describe service my-nginx

# Deploy somepods, expose as service. Reveal that your pods don't know about the new service. Refresh the pods, now they know. (Line 15)
# Launch a new pod in the cluster, use kubectl to get to its command line. Can curl other pods clusterIP. (what about services? deployments?) (Line 16)
# Totally refresh. Delete everything if you want. Start at line20.
# Make a k8s secret. create a new deployment and service where the pods have a vol for the secret and use https versio of the nginx image.
# Try to curl to the pod using the cluster ip from local. This was destined to fail?
# Launch another pod. Use kubectl to run a command in it to curl the nginx server. Success! Can I use the cluster ip of the pod? the cluster ip of the
# service? of the deployment? The k8s name of the pod? Of the service? of the deployment? It looks like I curled using the k8s name of the service.
# Back in local, try to get the external ip of the node on which the nginx pod runs, and try to get its node port. Doesn't work. 
