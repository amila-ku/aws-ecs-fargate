module "vpc" {
  source             = "../modules/network"
  name               = var.name
  owner              = var.owner
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "secrets" {
  source              = "../modules/secrets"
  name                = var.name
  environment         = var.environment
  application-secrets = var.application-secrets
}

module "svc" {
  source                      = "../modules/service"
  name                        = var.name
  environment                 = var.environment
  owner                       = var.owner
  region                      = var.aws-region
  vpc_id                      = module.vpc.id
  subnets                     = module.vpc.private_subnets
  public_subnets              = module.vpc.public_subnets
  container_image             = var.container_image
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  alb_tls_cert_arn            = var.tsl_certificate_arn
  container_environment = [
    { name = "VTT_DBHOST",
    value = module.aurora.cluster_endpoint },
    { name = "VTT_DBPORT",
    value = module.aurora.cluster_port },
    { name = "VTT_LISTENHOST",
    value = "0.0.0.0" },
    { name = "VTT_LISTENPORT",
    value = var.container_port }
  ]
  container_secrets      = module.secrets.secrets_map
  container_secrets_arns = module.secrets.application_secrets_arn
  health_check_path      = var.health_check_path
  cpu_scaling_target = var.cpu_scaling_target
  memory_scaling_target = var.memory_scaling_target
  scaling_min_capacity = var.scaling_min_capacity
  scaling_max_capacity = var.scaling_max_capacity
}



#############
# RDS Aurora
#############
module "aurora" {
  source            = "terraform-aws-modules/rds-aurora/aws"
  name              = "${var.name}-${var.environment}-postgresql"
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true

  master_username = "postgres"
  master_password = "changeme"

  vpc_id                = module.vpc.id
  subnets               = module.vpc.private_subnets.*.id
  create_security_group = true
  allowed_cidr_blocks   = [var.cidr]
  allowed_security_groups  = [module.svc.ecs_tasks_security_group]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true



  db_parameter_group_name         = aws_db_parameter_group.db_postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_postgresql.id

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 16
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "db_postgresql" {
  name        = "${var.name}-${var.environment}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.name}-${var.environment}-aurora-db-postgres-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "db_postgresql" {
  name        = "${var.name}-${var.environment}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.name}-${var.environment}-aurora-postgres-cluster-parameter-group"
}