# Types of Ingress
kubectl create -f ingress.yaml
kubectl get ingress test-ingress
kubectl create -f fanout-ingress.yaml
kubectl describe ingress simple-fanout-example # I see foo.bar.com. I see services:ports as backends. I see some annotations.
# updating an Ingress
kubectl describe ingress simple-fanout-example test 	# I see a backend, that is not connected to any host. The services mentioned here are not listed by kub.
kubectl edit ingress simple-fanout-example	
kubectl describe ingress simple-fanout-example # There is another host with a new backend present.
kubectl replace -f fanout-ingress.yaml # that host and backend is now gone.


# add this when you run the edit command
  - host: bar.baz.com
    http:
      paths:
      - backend:
          serviceName: s2
          servicePort: 80
        path: /foo

