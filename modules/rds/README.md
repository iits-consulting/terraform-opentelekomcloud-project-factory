## OTC Relational Database Service Terraform module

A module designed to support full capabilities of OTC RDS while simplifying the configuration for ease of use.

### Usage example

```hcl
module "rds" {
  source  = "iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_writer"
  version = "4.1.0"
  tags    = var.tags
  name    = "${var.context_name}-${var.stage_name}-db"

  vpc_id                 = module.vpc.vpc.id
  subnet_id              = values(module.vpc.subnets)[0].id
  db_type                = "PostgreSQL"
  db_version             = "12"
  db_cpus                = "4"
  db_memory              = "16"
  db_high_availability   = true
  db_ha_replication_mode = "async"
  db_parameters = {
    max_connections = "100",
  }
}
```

### Notes:

- RDS module is designed to create its own security group. 
- This security group will allow DB access from the CIDR range of the subnet RDS instance is created in by default.
- It is possible to remove the subnet accessibility by setting:
```hcl
  sg_allowed_cidr = ["0.0.0.0/32"] // This is a non existing IP, do not mix with 0.0.0.0/0 (allow all)
```
- Please note that KMS keys created will take 7 days to delete to prevent accidental data loss
- Please ensure KMS keys are not deleted for a database in use. Deletion of KMS keys will render the encrypted data impossible to decrypt, effectively destroying the data. 
- While not recommended for security reasons, it is possible to disable KMS encryption:
```hcl
  db_volume_encryption = false
```