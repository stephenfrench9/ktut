## Deploy an app, interact with its api through kubectl proxy.

Send requests to the the API server on master, and send requests to an 
API server on a node.

`kubectl proxy` 

Kubectl will now forward all requests to localhost:8001 on my machine to the master API server. The cluster-wide private network. The API server will create API servers on nodes, and we can send requests to those (sub)APIs. 