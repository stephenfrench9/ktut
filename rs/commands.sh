#RS example
kubectl create -f frontend.yaml
kubectl get rs
kubectl describe rs/frontend
kubectl get Pods
export POD=$(kubectl get pods | awk 'FNR == 2 {print $1}')
kubectl get pods $POD -o yaml 	# I think we just showed that a rs will launch pods
#The point: look at the pods metadata.ownerReference field
#non template pod acquisitions
kubectl create -f pod-rs.yaml	# These pods will be acquired by the rs
kubectl get pods		# the rs is full, just shuts them down
kubectl delete rs frontend
kubectl delete pods --all
kubectl create -f pod-rs.yaml	# launch pods first
kubectl create -f frontend.yaml	# relaunch the rs
kubectl get pods		# how many pods are there? What pods belong to what? 
#Telling replica sets what to do and understanding what they do
kubectl proxy --port=8080
curl -X DELETE 'localhost:8080/apis/extensions/v1beta1/namespaces/default/replicasets/frontend' \
     -d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Foreground"}' \
     -H "Content-Type: application/json"
kubectl proxy --port=8080
curl -X DELETE  'localhost:8080/apis/extensions/v1beta1/namespaces/default/replicasets/frontend' \
     -d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Orphan"}' \
     -H "Content-Type: application/json"
kubectl create -f hpa-rs.yaml
kubectl autoscale rs frontend --max=10 



#READING NOTES
RS: maintain stable set of pods. Gurentee availability.
Define a label that allows the rs to acquire pods. Define the type of pods the rs will create.
A pods metadata.ownerReferences field will be set to the name of the owning rs. The rs uses this link.
Rules and timetable for pod acquisition by a replica set.

You can delete the rs off the top of the pod with out deleting the pods.

A replicaset wont change any pods it adopts. You need a rolling update for this.

Lines 19 - 25 include calls to the k8s api, believe it or not. Kubectl forwrds
requests to the appropriate servers.

Question: The apiVersion for API objects, can that be depracated?
Question: Does the hpa automatically enforce the minimum? I dont see that happening
when I try.
Question: How do I see the current configuration of the rs?
Question: What if I give conflicting commands about how to autoscale? Like the
assigned autoscaler says one thing but the .yaml def of the hpa says another?
