kubectl logs $POD_NAME
kubectl exec $POD_NAME env
## get to the container thats running the pods command line
kubectl exec -ti $POD_NAME bash
cat server.js
curl localhost:8080
