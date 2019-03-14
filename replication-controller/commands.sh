# Running a replication controller
kubectl create -f replication.yaml
kubectl describe replicationcontrollers/nginx
export PODIT=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name}) # need to run 'source o 4'
echo $PODIT
# Writing a replication controller spec
# Working with ReplicationControllers
# Common Usage patterns


These commands demonstrate making a ReplicationController. You will notice that if you delete all these pods, they will get recreated.

