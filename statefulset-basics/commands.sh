# create a Stateful Set
kubectl get pods -w -l app=nginx
kubectl create -f web.yaml
kubectl get service nginx
kubectl get statefulset web
kubectl get pods -w -l app=nginx

# Pods in a Stateful Set
kubectl get pods -l app=nginx
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done # my pods have dns names. The dns name is podname.service.
kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm # in your busy box, type: nslookup web-0.nginx
kubectl get pod -w -l app=nginx
kubectl delete pod -l app=nginx
for i in 0 1; do kubectl exec web-$i -- sh -c 'hostname'; done
kubectl run -i --tty --image busybox dns-test --restart=Never --rm /bin/sh # !!!!#$%@ didn't work. The pods ip addresses have changed. DNS server failed tofindthem
kubectl get pvc -l app=nginx
for i in 0 1; do kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done # Webserver now serving hostnames
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done # have the webserver submit a request to itself. Would be cool to submit through kubeproxy, or publicy
kubectl get pod -w -l app=nginx # line above: I now know what html that nginx is serving.
kubectl delete pod -l app=nginx
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done
# above, I twice deleted pods, and then watched them get created. I also often printed the hostname of the pod
# to the terminal. I also once had the host name printed to a file. I also once used a curl command to get the host

# Scaling a Stateful Set
# in one terminal, watch
kubectl get pods -w -l app=nginx
kubectl scale sts web --replicas=5
kubectl patch sts web -p '{"spec":{"replicas":3}}'
kubectl get pvc -l app=nginx
# Above, I saw a couple pods terminate when I applied the patch to the stateful set.
# PVC remain attached to their great leader, despite the great leader being dead.

# Updating Stateful sets
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}'
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'
kubectl get po -l app=nginx -w
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done 
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"k8s.gcr.io/nginx-slim:0.7"}]'
kubectl delete po web-2
kubectl get po -l app=nginx -w
kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}' # apply a patch, delete pod, observe change. I see a failure to update in line 44. web-2 still running .8 image. GOOD. This is because of a partition. Container 0 1 2 are in the static partition now.
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}' # roll out a canary. Put container2 in 2nd p.
kubectl get po -l app=nginx -w
kubectl get po web-2 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}' # Container 2 is now updating. It was made to be part of the second partition
kubectl delete po web-1
kubectl get po -l app=nginx -w
kubectl get po web-1 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}' # GOOD pod 1 hasnt updated.
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}' #phased rollouts
kubectl get po -l app=nginx -w # now we see that it is updated
for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
# above, patches are made to the stateful set. We then delete pods, see if pods have certain changes.
# above, There are two types of patches: change the update strategy, and change the underlying image
# above, the patches are nested dictionaries in curly brackets, targeting a value in what is commonly represented in yaml files.
# above, pod information is returned and then filtered with a template. The --template flag is used. The template
# is a sequential series of double, closed curly brackets.

# Deleting StatefulSets
kubectl get pods -w -l app=nginx
kubectl delete statefulset web --cascade=false
kubectl get pods -l app=nginx
kubectl delete pod web-0
kubectl get pods -l app=nginx
kubectl get pods -w -l app=nginx
kubectl create -f web.yaml # throws an error, the service already exists
kubectl get pods -w -l app=nginx
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done # some pods got renamed
kubectl get pods -w -l app=nginx
kubectl delete statefulset web
kubectl get pods -w -l app=nginx # no more pods
kubectl delete service nginx
kubectl create -f web.yaml 
for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done # complained that it couldn't find container nginx. Eventually worked.
kubectl delete service nginx
kubectl delete statefulset web
# delete stateful set with cascade set to true and false, observe containers.
# iterate over pods and ask them to curl their local host. appears to not work if the nginx service is not in place.

# Pod Management Policy
kubectl get po -l app=nginx -w
kubectl create -f web-parallel.yaml 
kubectl get po -l app=nginx -w
kubectl scale statefulset/web --replicas=4 # all the pods are deleted, even the new replicas.
kubectl delete sts web
kubectl delete svc nginx
# I can watch the scaling work the stateful set.
# I can watch all containers get deleted.
