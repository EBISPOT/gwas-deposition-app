# gwas-deposition-app

## MongoDB ReplicaSet deployment

### Configuration

 * Start pods using: `kubectl apply -f mongo-statefulset.yaml`
 * Get inside the `mongo-0` pod:
    * `kubectl exec -ti mongo-0 -- /bin/bash`
    * Execute `mongo` inside the pod
    * Set the following variable:
    ```
    config = {
     "_id" : "rs0",
     "members" : [
       {
         _id: 1,
         host: 'mongo-0.mongo.default.svc.cluster.local:27017'
       },
       {
         _id: 2,
         host: 'mongo-1.mongo.default.svc.cluster.local:27017',
       },
       {
         _id: 3,
         host: 'mongo-2.mongo.default.svc.cluster.local:27017'
       }
     ]
    }
    ```
    * Initialize replica-set: `rs.initiate(config)`
  
### Connection
 * `mongodb://mongo-0.mongo.demo.svc.cluster.local,mongo-1.mongo.demo.svc.cluster.local,mongo-2.mongo.demo.svc.cluster.local:27017`