# set up GSA
NAMESPACE=victory
HOST_PROJECT_ID=infra
MANAGED_PROJECT_ID=dev-project

# for each NAMESPACE do the following
kubectl create namespace $NAMESPACE
GSA=$NAMESPACE-cc@$HOST_PROJECT_ID.iam.gserviceaccount.com
KSA=cnrm-controller-manager-$NAMESPACE

# create a GSA in HOST project
gcloud config set project $HOST_PROJECT_ID
gcloud iam service-accounts create $NAMESPACE-cc

# grant role for GSA in MANAGED project
gcloud config set project $MANAGED_PROJECT_ID
gcloud projects add-iam-policy-binding $MANAGED_PROJECT_ID \
--member="serviceAccount:$GSA" \
--role="roles/editor"

# create config connector context in the given namespace
kubectl apply -f configconnector-context.yaml
kubectl get serviceaccount/$KSA -n cnrm-system -o yaml
kubectl wait -n cnrm-system \
  --for=condition=Ready pod\
  cnrm-controller-manager-$NAMESPACE-0

## set up workload identity
gcloud iam service-accounts add-iam-policy-binding $GSA \
--member="serviceAccount:$HOST_PROJECT_ID.svc.id.goog[cnrm-system/$KSA]" \
--role="roles/iam.workloadIdentityUser"


# where to create resource: project, folder or org
kubectl annotate namespace $NAMESPACE cnrm.cloud.google.com/project-id=$PROJECT_ID


# Verify Your Installation
kubectl wait -n cnrm-system \
  --for=condition=Ready pod --all

# set default namespace
kubectl config set-context --current --namespace $NAMESPACE
