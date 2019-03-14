kubectl create -f https://k8s.io/examples/controllers/replicaset.yaml
kubectl get pods --output=yaml
kubectl proxy --port=8080
# Controlling how the garbage collection deletes dependents
curl -X DELETE localhost:8080/apis/apps/v1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Background"}' \
     -H "Content-Type: application/json"

kubectl proxy --port=8080
curl -X DELETE localhost:8080/apis/apps/v1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Foreground"}' \
     -H "Content-Type: application/json"

kubectl proxy --port=8080
curl -X DELETE localhost:8080/apis/apps/v1/namespaces/default/replicasets/my-repset \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Orphan"}' \
     -H "Content-Type: application/json"

kubectl delete replicaset my-repset --cascade=false
