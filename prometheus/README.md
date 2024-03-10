
# EC2 Linux Server Microservices for Prometheu stack metrics exposed via Python Flask app 

![image](https://github.com/liormilliger/prometheus-data-collector/assets/64707466/ec9c6465-b854-435b-8050-54ff85ecd403)

### This repo contains a closed system for launching microservices

### of Prometheus, Node-Exporter, Grafana and Flask-app

### with configuration files using userdata.sh file to be copied into an EC2 userdata.


```
.
├── app
│   ├── app.py
│   └── requirements.txt
├── docker-compose.yaml
├── Dockerfile
├── grafana-provisioning
│   ├── dashboards
│   │   ├── dashboards.yaml
│   │   ├── my_dashboard.json
│   │   └── My_improved_dashboard.json
│   └── datasources
│       └── datasources.yaml
├── prometheus.yaml
├── terraform
│   ├── errored.tfstate
│   ├── instance.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── vpc.tf
└── userdata.sh
```

```userdata.sh``` installs the dependency packages on the EC2 and also cloning THIS repo so it can have all available files, such as Dockerfile and docker-compose.yaml file

```Docker-compose.yaml``` has 4 services:

* Prometheus - on port 9090
* Node-Exporter - on port 9100
* Grafana - on port 3000
* Flask-app - on port 5000

## How To launch it?

Its enough using t3a.micro instance, pasting the content of the userdata.sh to the EC2 userdata.
Set the security group to allow access to the above ports
after the instance is ready - check the browser for ```http://<EC2-Public-IP>:5000``` to get the app API call from Prometheus

you can also check grafana on ```http://<EC2-Public-IP>:3000```

Grafana's default username and password are admin/admin -

check the dasshboards and choose the one dashboard in there to see the visualizations

### Terraform IaaC
also included here is Terraform IaaC for launching this Architecture in one command

If you wish to use it - change the variables file with your data to make it work

Terraform Creates an AWS VPC with a public subnet and launches EC2 instance with the user-data script mentioned before.
this launches all microservices on the EC2 instance.

Mind you - security group allows access only to MYIP - so you will need to change it to have access to the app



