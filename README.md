This Dockerfile installs most of the tools required to perform testing against Java, DotNET Core, PHP, Ruby, Python, and Go.

Deploy this Jenkins instance to Kubernetes with the following Helm `values.yaml` file:

```yaml
controller:
  serviceType: LoadBalancer
  JCasC:
    configScripts:
      this-is-where-i-configure-the-executors: |
        jenkins:
          numExecutors: 5
  image: "octopussamples/jenkins-complete-image"
  tag: "latest"
  installPlugins: false
```

Install with helm using the command:
```
helm upgrade --install -f values.yaml myjenkins jenkins/jenkins
```
