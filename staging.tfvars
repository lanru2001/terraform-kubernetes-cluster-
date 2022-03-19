region                      = "us-east-1"
vpc_name                    = "eks_rds"
vpc_cidr                    = "10.2.0.0/16"
eks_cluster_name            = "eks_cluster"
cidr_block_igw              = "0.0.0.0/0"
node_group_name             = "eks_ng"
ng_instance_types           = [ "t2.micro" ]
disk_size                   = 10
desired_nodes               = 2
max_nodes                   = 2
min_nodes                   = 1
fargate_profile_name        = "eks_fargate"
kubernetes_namespace        = "wordpress-rds"
deployment_name             = "wordpress"
deployment_replicas         = 3
rds_subnet_group_name       = "rds-subnet"
rds_db_name                 = "wordpress_db"
#rds_user                    = "admin"
#rds_pass                    = "temitope1234"
rds_db_identifier           = "mysql"
rds_storage                 = 20
engine                      = "mysql"
engine_version              = "5.7"
instance_class              = "db.t2.micro"
rds_parameter_group_name    = "default.mysql5.7"
app_labels = { 
    "app" = "wordpress"
    "tier" = "frontend"
    #"Environment" = "${terraform.workspace}"
    }
