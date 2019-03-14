# Default Hosts File Content
kubectl run nginx --image nginx --generator=run-pod/v1
kubectl get pods --output=wide
kubectl exec nginx -- cat /etc/hosts # I see come ip addresses and some four digit hectal numbers. And they are mapped to ports?
# Adding Additional Entries with HostAliases
kubectl apply -f hostaliases-pod.yaml 
kubectl get pod -o=wide # the hostaliasis pod will not start
kubectl logs hostaliases-pod # I see a list of hosts (like in /etc/hosts for nginx.) But now there are some more IPs that are mapped to names.
kubectl exec hostaliases-pod -- cat /etc/hosts # doesn't work because the pod is not started.
