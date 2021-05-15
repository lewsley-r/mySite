# Buckram

## A Laravel Chart

Caveat: this structure is still in active development.

To use this with Laravel:

Dependencies:
- Python3
- docker-compose and docker

Steps:
- install the `bookcloth` Python script and go to the git root (further details in `./python/README.md`)
    - `cd python`
    - `pip3 install --user .`
- create a new Laravel project, or reuse an existing one
- in the Laravel root directory, add this repository as a submodule into a new `infrastructure` subdirectory of your Laravel project (note that, if you have a fresh, non-git Laravel app then you will need to run `git init` first)
    - `git submodule add https://gitlab.com/flaxandteal/buckram infrastructure`
- in the Laravel root directory, run `bookcloth local:initialize` to set up default docker configuration in your local Laravel directory
- follow the instructions in the terminal to fire up Docker.

To use with Gitlab, move `gitlab-ci/gitlab-ci.yml` to `.gitlab-ci.yml` in your root directory (note leading dot). Add an `APP_KEY` entry to your `phpunit.xml` variables to ensure a sample entry is available during test

### Laravel with GitlabCI+Kubernetes extensions

For details of the upstream Laravel project, see https://github.com/laravel/laravel

Using the `.gitlab-ci.yml` file in this directory, the necessary steps are run to build, test and deploy to an
AWS Elastic Container Repository defined in your Gitlab Variables:

- AWS_ACCESS_KEY_ID
- AWS_DEFAULT_REGION
- AWS_ECR_URI
- AWS_SECRET_ACCESS_KEY

Add these variables to your project Settings -> Integrations -> Project services -> Kubernetes. This will allow to deploy to your cluster after the build
- KUBE_URL
- KUBE_CA_PEM_FILE
- KUBE_TOKEN
- KUBE_NAMESPACE

The user for AWS access should need the following policies:

- AmazonEC2ContainerRegistryPowerUser

### Kubernetes

While a recent RBAC cluster should be sufficient, buckram has been generally used by the dev team on AWS-based clusters. To launch such a cluster, have a look at the `kops.sh` (note that it will not execute the final "kops update --yes" deploy step.

### Launching with Helm

You will require `kubectl`, a Kubernetes cluster configured and Docker installed (if building locally).

If using this source directory to build your images, make sure you run:
* `composer install`
before building. To build, run:
* `docker build -ti myimagename-nginx -f infrastructure/containers/nginx/Dockerfile .`
* `docker build -ti myimagename-phpfpm -f infrastructure/containers/phpfpm/Dockerfile .`
You will need these images to be available to your cluster from an accessible repository; the default demo
images built from this source are on Docker Hub. To use your own you will need to configure them in your `values.yaml` (see below).
In normal circumstances, your continuous delivery system will handle getting code to built images and on to
your cluster.

Start your Kubernetes cluster. 

(If using minikube, then `minikube start --extra-config=apiserver.Authorization.Mode=RBAC`)

- If you have not used Helm on this cluster since it was created: `helm init`; if you have installed this Chart (Buckram Helm configuration) before, `helm list` to find the release name and `helm delete RELEASENAME`. Note that `helm init` will trigger a download of the Tiller pod (coordinates Helm actions on the cluster side), and until this has set itself up, Helm will not be ready for use. If necessary, follow the RBAC set-up steps for Helm listed in the Caveats section below
- `helm install --name cert-manager stable/cert-manager`
- `helm install --name nginx-ingress stable/nginx-ingress --values ./kubernetes/sundry/nginx-ingress.values.yaml`
- Copy `infrastructure/config/values.yaml.example` to `values.yaml` in a safe place and fill in the contents (e.g. APP_KEY). A script `bookcloth` has been provided to simplify the filling-out process. This will ask for your Docker repository (which should match AWS_ECR_URI if using Gitlab-CI and AWS), where you want your app to be reachable (public website) and the nginx and phpfpm image tags you wish to start off with (if using provided Gitlab-CI, these will contain the build pipeline number).
- Make sure the hostname (where webpages should be served, not of the cluster) is correct in `values.yaml`, and, if using minikube, that you have added it to your `/etc/hosts` file with the output of `minikube ip` as the address
- `helm dependencies update infrastructure/kubernetes/buckram`
- `helm install infrastructure/kubernetes/buckram --values PATH_TO_YOUR/values.yaml --name PLATFORMNAME`
- if you run `kubectl get svc` you should see an external endpoint - on AWS, this will match a ELB (load balancer) - create a DNS A record for your website to point to this (in AWS Route 53, you can directly name the load balancer)

At present, the inter-dependencies are not ordered, so you may see, for instance, nginx starting before phpfpm and having to auto-restart before it gets the phpfpm server. Once `kubectl get pods` shows all pods running, your system should be good to go.

If using minikube, rather than a cloud provider, you will have to use a high numbered port to reach the ingress. Run `kubectl get svc --namespace=kube-system` and go to `HOSTNAME:PORT` in your browser, where `HOSTNAME` is the hostname used above, and `PORT` is the 3xxxx numbered port in the line with `nginx-ingress` in it [to check].

To help web developers get familiar with Kubernetes, without trying to patch together multiple repositories,
the Helm chart for Kubernetes, container definitions and template secrets are under the `infrastructure`
subdirectory. However, bear in mind that, if you are experimenting
with the Kubernetes workflow by building and pushing images
it is recommended that you do so from a fresh clone of this repository so that
you do not include anything in the `.env` file (or elsewhere in the tree)
that should not end up in the test images. *In particular, make sure your `values.yaml`
is not in the tree*, especially if pushing experimentation images publicly.

(For those unfamiliar with Docker: in normal
workflow, the CI/CD train will clone your code repository
fresh and build the Docker images with your code inside,
then push to your chosen Docker image
repository, from where images may be deployed
to the cluster)

### IAM

To use annotations for IAM:

```
helm install stable/kube2iam --name kube2iam   --set=extraArgs.auto-discover-base-arn=true,extraArgs.auto-discover-default-role=true,host.iptables=true,host.interface=cali+,rbac.create=true
```

### Docker Compose

To test locally, there is a `docker-compose.yml` file within the root of Buckram. This allows a Laravel setup to be tested locally, by copying the `*.env.example` files in `./config/secrets` to the respective `*.env` files and filling the blank fields for testing.

Note that this will create a `storage` folder in the level above the Laravel project above Buckram. This will be used for storing persistent data from `docker-compose` containers, e.g. `postgres` and `artisan`.

### Logging

The elasticsearch chart requires:

```
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```

### Gitlab-CI Templates

The `.gitlab-ci.yml` file in the root directory is designed to work with Buckram. You may wish to copy it to your own project's root folder. If you are willing to have caching of dependencies, the `config.toml` file in the `gitlab-ci` folder can be used on a gitlab-ci-runner server to allow both composer and npm to re-use their public-repository dependencies between builds without re-downloading (please note, opinion varies on this approach), saving 50-70% of build time at the expense of potentially missing upstream changes (at least, where the dependency has not bumped the version).

If using Amazon ECR for internal Docker image hosting, remember to create an ECS repository. As per the `gitlab-ci.yml`, Gitlab will need several variables:

* AWS_DEFAULT_REGION: default region for buckets
* AWS_ECR_URI: an Amazon ECS Repository, to which a "deploy" user has access, to push buckets (the Kubernetes cluster will be able to access them securely here)
* AWS_ACCESS_KEY_ID: access key ID for deploy user
* AWS_SECRET_ACCESS_KEY: secret access key for deploy user
* AWS_FRONTEND_BUCKET (optional, if meld step used): S3 bucket containing the front-end, as a dist file (tested with Vue.js) called `front-end-latest.tgz` (see, for instance, the OurRagingPlanet project)

### Caveats

* RBAC will require Helm to have a service account: https://docs.helm.sh/using_helm/#role-based-access-control
* A new RBAC deployment, if using k8s 1.6.1, kubectl 1.6.2, kops 1.6, should use fixes for https://github.com/containous/traefik/blob/master/examples/k8s/traefik-with-rbac.yaml

[From kujenga's Github comment](https://github.com/kubernetes/helm/issues/2224#issuecomment-299939178)
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

### Letsencrypt Issuer

The following is an example of a (staging) Letsencrypt issuer.

```
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: [EMAIL]
    http01: {}
    privateKeySecretRef:
      name: letsencrypt-staging
    server: https://acme-staging-v02.api.letsencrypt.org/directory
```

### bookcloth

This tool allows some shortcutting of YAML creation for common tasks.

### Laravel tweaks

To use the Buckram Kubernetes containers, a few additional
environmentally-configurable settings need to be added.

In `config/auth.php`

    'keys' => [
        'path' => env('KEY_PATH', storage_path())
    ]

and, to `App\Providers\AuthServiceProvider@boot`:

    Passport::loadKeysFrom(config('auth.keys.path', storage_path()));

To avoid HTTP vs. HTTPS redirect issues, you will need to trust incoming proxies. Unfortunately, as the IP address is not known in advance, the most practical approach is the one below; nonetheless, your nginx/PHP-FPM should never be accessible via IP from outside the cluster (or you have more fundamental problems).

    php artisan vendor:publish --provider="Fideloper\Proxy\TrustedProxyServiceProvider"

and replace the `proxies` value in `config/trustedproxy.php` with:

    'proxies' => '*',

### Deploying to AWS Elastic Container Registry

Using the `.gitlab-ci.yml` file in this directory, the necessary steps are run to build, test and deploy to an
AWS Elastic Container Repository defined in your Gitlab Variables:

- AWS_ACCESS_KEY_ID
- AWS_DEFAULT_REGION
- AWS_ECR_URI
- AWS_SECRET_ACCESS_KEY

The user for AWS access should need the following policies:

- AmazonEC2ContainerRegistryPowerUser

### Encrypted configuration

Encrypt the `production.yaml` file:

    gpg --encrypt production.yaml

Then for each deploy:

    (read -s PW && echo $PW) | gpg --passphrase-fd=0 --batch --decrypt values.yaml.gpg 2>/dev/null | helm install infrastructure/kubernetes/buckram --name development --values -

Enter the GPG encryption password (there's no prompt) followed by a Return.

### Monitoring

To install Prometheus monitoring (with a toy Rocket.Chat notification):

    kubectl create namespace monitor
    helm install stable/prometheus-operator --name prometheus-operator --namespace monitor --values prometheus-operator-values.yaml

Add label to each namespace that kube-prometheus should watch:

    prometheus: kube-prometheus

To view the Prometheus dashboard:

    kubectl port-forward prometheus-kube-prometheus-0 9090:9090 -n monitor

### Acknowledgments

With thanks to the Open Data Institute, who commissioned the Lintol (github.com/lintol) R&D project, which provided extensions to the Buckram project.

### Azure

    az group create --name $NAME --location westeurope
    az aks create --resource-group $RESOURCEGROUP --name $NAME --node-count 1 --enable-addons monitoring --generate-ssh-keys --location westeurope
    az acr create --name $NAME -g $RESOURCEGROUP --sku Basic
    az storage container create -n ... --account-name ... --account-key ...

Development Jenkins: https://docs.microsoft.com/en-us/azure/aks/jenkins-continuous-deployment
Install credentials binding plugin

NB: location was hard-coded to eastus in https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/jenkins-cicd-container/azuredeploy.json

https://github.com/jenkinsci/gitlab-plugin

Install pipeline plugin
