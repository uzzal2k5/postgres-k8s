
# Create  ConfigMap (cm)
kubectl apply -f postgres-config.yaml
kubectl get cm -o wide

# Create Volume(pv)  and  vVolume Claim (pvc)
kubectl apply -f postgres-pvc-pv.yaml
kubectl get pv -o wide
kubectl get pvc -o wide

# Create Deployment (deploy)
kubectl apply -f postgres-deployment.yaml
kubectl get deploy -o wide
sleep 10
kubectl get pods -o wide


# Create  Service (svc)
kubectl apply -f postgres-service.yaml
kubectl get svc -o wide


