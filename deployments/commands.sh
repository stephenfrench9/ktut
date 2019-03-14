# Creating a deployment
kubectl create -f nginx-deployment.yaml
kubectl get deployments
kubectl get deployments
kubectl get rs
kubectl get pods --show-labels
# Updating a deployment
kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1
kubectl edit deployment.v1.apps/nginx-deployment
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get deployments
kubectl get rs
kubectl get pods
kubectl describe deployments
# Rollback a deployment
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.91 --record=true
kubectl rollout status deployment.v1.apps/nginx-deployment # command won't finish
kubectl get rs 	# 4 desired containers. I thought the deployment onlly wanted 3 containers. I see 3 deployments.
kubectl get pods		# There four pods, belonging to two different deployments
kubectl describe deployment 	# shows one unavailable pod
kubectl rollout history deployment.v1.apps/nginx-deployment
kubectl annotate deployment.v1.apps/nginx-deployment kubernetes.io/change-cause="image IS updated to 1.9.1"
kubectl rollout history deployment.v1.apps/nginx-deployment --revision=2
kubectl rollout undo deployment.v1.apps/nginx-deployment
kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2 #Says it can't find the deployment I want to revert to. #Deployment history?
kubectl get deployment nginx-deployment 
kubectl describe deployment nginx-deployment # The annotations include a revision number and a change cause.
# Scaling a Deployment
kubectl scale deployment.v1.apps/nginx-deployment --replicas=10
kubectl autoscale deployment.v1.apps/nginx-deployment --min=10 --max=15 --cpu-percent=80
kubectl get deploy
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:sometag
kubectl get rs # I see multiple replicasets for my nginx deployment
kubectl get deploy
kubectl get rs
kubectl get deploy
kubectl get rs
kubectl rollout pause deployment.v1.apps/nginx-deployment
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1
kubectl rollout history deployment.v1.apps/nginx-deployment # shows the history of updates to this deployment
kubectl get rs						    # shows four rs, two have current containers.
kubectl set resources deployment.v1.apps/nginx-deployment -c=nginx --limits=cpu=200m,memory=512Mi
kubectl rollout resume deployment.v1.apps/nginx-deployment 
kubectl get rs -w 		# oh shit, I see about a dozen rs. The command hangs.
kubectl get rs
#Deployment Status
kubectl rollout status		# needs a resource to run
kubectl rollout status deployment.v1.apps/nginx-deployment # It is successfully rolled out
kubectl patch deployment.v1.apps/nginx-deployment -p '{"spec":{"progressDeadlineSeconds":600}}' # 
kubectl describe deployment nginx-deployment # I see 10 desired containers, 10 active. Revision:7. Change/cause: kubectl command 
kubectl get deployment nginx-deployment -o yaml # I see the same info as above line. I see spec.ProgressDeadlineSeconds set to 600.
kubectl rollout status deployment.v1.apps/nginx-deployment


Summary: We created a deployment. We looked at its yaml and its report. We then updated the container serving the deployment. And again observed it.
Did we update the number before or after we updated the image? At the same time? How many rs are running at any given time? What is the latest
revision number of the deployment? What is the latest cause change annotation? Can I change other properties of the deployment.

What if, while the deployment is happening, something goes wrong. can I stop it? Can I see how active each deployment is? If I have a deployment half
way rolled out, and then I pause, and then I look at the deployment yaml, which revision number does it report?

If I look at the list of deployments, does it include all the updates to the original deployment? Is there a parent deployment which is always in place,
and then smaller sub-deployments. And does each subdeployment have a revision number. Or does an update just mean that there is going to be an entirely new
deployment put in place.

Can the deployment history revision number be matched to the list of deployments?

How do I include a cause change in the deployment yaml automatically?

All these deployments that match the original deployment but have suffixes - are they their own deployment? Do they all show up in the history for
the deployment that is eponymous to the root of their name?


I am confused. What is showing up in the history? What is showing up in the deployments list? What is the change/cause entry in the deployment yaml.
