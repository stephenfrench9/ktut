kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD
kubectl get secrets
kubectl create -f https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
kubectl get pvc
kubectl get pods
kubectl create -f https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml
kubectl get pvc
kubectl get services wordpress
kubectl delete secret mysql-pass
kubectl delete deployment -l app=wordpress
kubectl delete service -l app=wordpress
kubectl delete pvc -l app=wordpress
