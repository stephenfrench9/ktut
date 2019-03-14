kubectl create -f myapp.yaml
kubectl get -f myapp.yaml
kubectl describe -f myapp.yaml
kubectl logs myapp-pod -c init-myservice # Inspect the first init container
kubectl logs myapp-pod -c init-mydb
kubectl create -f services.yaml
kubectl get -f myapp.yaml
