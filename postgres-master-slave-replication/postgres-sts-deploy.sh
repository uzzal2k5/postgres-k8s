
# Create Credentials ConfigMap (cm)
kubectl apply -f postgres-configmap.yaml
kubectl get cm -o wide


# Create Credentials ConfigMap (cm)
kubectl apply -f postgres-secret.yaml
kubectl get secret -o wide

# Create Volume(pv)  and  vVolume Claim (pvc)
kubectl apply -f postgres-volume.yaml
kubectl get pv -o wide
kubectl get pvc -o wide

# Create Master ConfigMap (cm)
kubectl create cm postgres-master-configmap --from-file=config
kubectl get cm -o wide

# Create Master StatefulSet (sts)
kubectl apply -f postgres-master-sts.yaml
kubectl get sts -o wide
sleep 10
kubectl get pods -o wide


# Create Master Service (svc)
kubectl apply -f postgres-master-svc.yaml
kubectl get svc -o wide


#Create Replica User
kubectl exec -it postgres-master-0 -- bash
su - postgres
psql
SET password_encryption = 'scram-sha-256';
CREATE ROLE repuser WITH REPLICATION PASSWORD 'postgres' LOGIN;
SELECT * FROM pg_create_physical_replication_slot('replica_1_slot');


# Create Data Sync Job (job)
kubectl apply -f sync-master-data.yaml
kubectl get job -o wide

# Create Slave ConfigMap (cm)
kubectl create cm postgres-slave-configmap --from-file=slave-config
kubectl get cm -o wide

# Create Slave StatefulSet (sts)
kubectl apply -f postgres-slave-sts.yaml
kubectl get sts -o wide
sleep 10
kubectl get pods -o wide



#==========SQL====================



kubectl exec -it postgres-master-0 -- psql -h localhost -U postgres -d postgres


CREATE TABLE test2 (id int not null, val text not null);
INSERT INTO test2 VALUES (1, 'foo1');
INSERT INTO test2 VALUES (2, 'bar2');
INSERT INTO test2 VALUES (3, 'zoo3');


kubectl exec -it postgres-slave-0 -- psql -h localhost -U postgres -d postgres
select * from test2;




#Dashboad
minikube dashboard &
kubectl proxy --address='0.0.0.0' --disable-filter=true &

http://127.0.0.1:35283/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

http://192.168.0.102:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/