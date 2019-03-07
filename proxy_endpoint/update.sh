kubectl get pods
kubectl describe pods
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
kubectl get pods
kubectl describe services/kubernetes-bootcamp

## if you type kubectl describe pods you will see that the image has changed. 