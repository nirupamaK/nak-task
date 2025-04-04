## Folder structure

### 1. docker
* Sample `Dockerfile` addon modules required LLM programs. 
* Sample `train.py` sample tringing large language model program. Includeded in the docker image. 
* The image  with `latest` tag is uploaded on Dockerhub `https://hub.docker.com/r/nirupamak/fine-tune/tags`.
* For testing against latest vulnerabilities are present.
`docker scout dockerfile ./Dockerfile`
`docker scout image nirupamak/fine-tune:latest --severity high`
* The basic container Health-check is configured in `fine-tune-app/templates/deployment.yaml` for the POD health checks.

#### To deploy docker image locally.
1. `cd docker`  
2. `docker build -t nirupamak/fine-tune . --platform=linux/amd64` #For arm64 Macbook.

### 2. minikube-local-terraform
#### Prerequisites
Install Minikube (For my macbook used follwoing plugin)
1. curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.35.0/minikube-darwin-arm64 \
   && chmod +x minikube
2. sudo mv minikube /usr/local/bin.
3. Install `kubectl` utility
4. Install `helm` utility.
5. Install terraform on laptop (In my case I used Terraform v1.5.7)
6. Using `docker` driver for `minikube`. If need to change driver please update `minikube start` command in `provider.tf` file.

#### To deploy app on minikube
1. `cd minikube-local-terraform`  
2. `terraform init`
3. `terraform apply`
4. type `yes`

### Notes: The `helm_release` resouce time-out is set to 900 Seconds/15 mins (the above fine-tune image is arond 6.84GB takes aound 11 mins just download the image on locally).

5. Once apply complete. Check the status of `kubectl get pods`.
 
#### To access the application

1. Run the following command to get Jupyter Notebook Token:

 * `kubectl get pods`
 * `kubectl logs fine-tune-app-deployment-<ramdom-string>`

2. Copy the Random Token string for Url in the logs:
http://127.0.0.1:8900/tree?token=<ramdom-token-string>
 
3. Run command of the empty terminal

`minikube service fine-tune-app-service --url`

The output will be http://127.0.0.1:<ramdom_port>

Open the above URL in the browser paste <ramdom-token-string> in token box access Jupyter Notebook App.

#### Or 

Run following to enable port fowwarding :
`kubectl port-forward svc/fine-tune-app-service 8900:8900`

The app should be available on browser at `http://127.0.0.1:8900`.

Open the above URL in the browser paste <ramdom-token-string> in token box access Jupyter Notebook App.

### 3. OTC-terraform

1. The OTC-terraform comtains terraform to deploy kubernetes cluster on OpenTelekom Cloud. 
2. It deploying the same `fine-tune-app` helm-chart same as on minikube. 

#### To deploy app on OTC
1. `cd OTC-terraform`  
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. type `yes`

##### Notes: This soloution is un-tested, due to lack to access credentials to OTC, the `terraform plan` is unable to run. Unable to find to similar option `skip_credentials_validation` of AWS provider for OTC terrform provider. 

However tried to run create a sample `opentelekomcloud_cce_cluster_v3` cluster with single node with some of its related resources to deploy the cluster.