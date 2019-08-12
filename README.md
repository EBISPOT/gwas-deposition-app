# gwas-deposition-app

## Logging PVC
 * a PVC is now available to externalise log files: `gwas-depo-logs`
 * Example:
 ```
  volumeMounts:
 - mountPath: "/var/log/gwas"
   name: log

   ...
   
  volumes:
  - name: log
   persistentVolumeClaim:
      claimName: gwas-depo-logs
 ```

## Ingress configuration

 * Create an ingress configuration file - see below and deploy it
 * Service will then be available at: `http://193.62.54.159/<<YOUR_SERVICE_ROUTE>>`

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: <<NAME>>
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host:
    http:
      paths:
      - path: /<<YOUR_SERVICE_ROUTE>>(/|$)(.*)
        backend:
          serviceName: <<YOUR_SERVICE_NAME_FROM_SERVICE_DIRECTORY>>
          servicePort: <<PORT_ON_WHICH_THE_SERVICE_WAS_EXPOSED_IN_DEPLOYMENT_PLAN>>
```

## Kube service directory

 * Backend: `gwas-deposition-backend`
 * Template service: `<<ADD label here>>`
 * Summary stats service: `<<ADD label here>>`
 
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

## Zookeeper / Kafka ReplicaSet deployment

### Configuration

 * Install `helm`: https://helm.sh/docs/using_helm/
 * Run `helm init` - this will attempt to install `tiller` inside the cluster, which in this case already exists
 * Add `kafka` repo: `helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator`
 * Create namespace: `kubectl create -f kafka-namespace.yml`
 * Install kafka: `helm install --name my-kafka --namespace kafka incubator/kafka`
 
### Tests

 * Create test pod: `kubectl create -f test-pod.yml`
 * List topics: `kubectl -n kafka exec testclient -- kafka-topics --zookeeper my-kafka-zookeeper:2181 --list`
 * Create new topic: `kubectl -n kafka exec testclient -- kafka-topics --zookeeper my-kafka-zookeeper:2181 --topic test1 --create --partitions 1 --replication-factor 1`
 * Listen for messages on a topic (Ctrl + C to stop): `kubectl -n kafka exec -ti testclient -- kafka-console-consumer --bootstrap-server my-kafka:9092 --topic test1 --from-beginningkubectl -n kafka exec -ti testclient -- kafka-console-consumer --bootstrap-server my-kafka:9092 --topic test1 --from-beginning`
 * Start an interactive message producer session (Ctrl + C to stop): `kubectl -n kafka exec -ti testclient -- kafka-console-producer --broker-list my-kafka-headless:9092 --topic test1`
 * Delete test pod: `kubectl delete -f test-pod.yml`

### Connection

 * `my-kafka.kafka.svc.cluster.local:9092`