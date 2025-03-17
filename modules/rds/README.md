## OTC Relational Database Service Terraform module

A module designed to support full capabilities of OTC RDS while simplifying the configuration for ease of use.

### Usage example

```hcl
module "rds" {
  source  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/rds"
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
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.db_availability_zones](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.db_flavor_constraint](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.db_ha_replication_mode_constraint](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_ces_alarmrule.db_storage_alarm](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/ces_alarmrule) | resource |
| [opentelekomcloud_kms_key_v1.db_encryption_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.db_allow_cidr](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.db_allow_out](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.db_allow_secgroup](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.db_secgroup_in](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.db_secgroup_out](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_v2.db_secgroup](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_v2) | resource |
| [opentelekomcloud_rds_instance_v3.db_instance](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/rds_instance_v3) | resource |
| [opentelekomcloud_vpc_eip_v1.db_eip](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_eip_v1) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.db_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_kms_key_v1.db_encryption_existing_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/kms_key_v1) | data source |
| [opentelekomcloud_rds_flavors_v3.db_flavor](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/rds_flavors_v3) | data source |
| [opentelekomcloud_vpc_subnet_v1.db_subnet](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/vpc_subnet_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_type"></a> [db\_type](#input\_db\_type) | RDS database product type. (MySQL, PostgreSQL or SQLServer) | `string` | n/a | yes |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | RDS database product version. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the RDS instance. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Id of the subnet to create database cluster in. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC to create database cluster in. | `string` | n/a | yes |
| <a name="input_db_availability_zones"></a> [db\_availability\_zones](#input\_db\_availability\_zones) | Availability zones for the RDS instance. One or two zones are supported for single and primary/standby instances respectively. | `set(string)` | `[]` | no |
| <a name="input_db_backup_days"></a> [db\_backup\_days](#input\_db\_backup\_days) | Retain time for automated backups in days. (default: 7) | `number` | `"7"` | no |
| <a name="input_db_backup_interval"></a> [db\_backup\_interval](#input\_db\_backup\_interval) | UTC time window for automated database backups in "HH:MM-HH:MM" format. Must be at least 1 hour (default: 03:00-04:00) | `string` | `"03:00-04:00"` | no |
| <a name="input_db_cpus"></a> [db\_cpus](#input\_db\_cpus) | Number of CPU cores desired for database nodes. (default: 2) | `string` | `"2"` | no |
| <a name="input_db_eip_bandwidth"></a> [db\_eip\_bandwidth](#input\_db\_eip\_bandwidth) | Bandwidth of the EIP of RDS instance, can be disabled by setting to 0. (default: 0) | `number` | `0` | no |
| <a name="input_db_flavor"></a> [db\_flavor](#input\_db\_flavor) | RDS Flavor string override. This parameter will override parameters for db\_cpu, db\_memory and db\_high\_availability. | `string` | `""` | no |
| <a name="input_db_ha_replication_mode"></a> [db\_ha\_replication\_mode](#input\_db\_ha\_replication\_mode) | RDS data replication mode for instances with high availability (primary/standby) enabled. Defaults are async(MySQL), async(PostgreSQL) and sync(SQLServer) | `string` | `""` | no |
| <a name="input_db_high_availability"></a> [db\_high\_availability](#input\_db\_high\_availability) | Whether a single db instance or a high available (primary/standby) db instance is desired. (default: false) | `bool` | `false` | no |
| <a name="input_db_memory"></a> [db\_memory](#input\_db\_memory) | Amount of memory desired for database nodes in GB. (default: 4) | `number` | `4` | no |
| <a name="input_db_parameters"></a> [db\_parameters](#input\_db\_parameters) | A map of additional parameters for the database instance. Check the DB Engine's documentation. | `map(string)` | `{}` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Port number for accessing the database. Default ports are: 3306(MySQL), 5432(PostgreSQL) and 1433(SQLServer) | `string` | `"default"` | no |
| <a name="input_db_size"></a> [db\_size](#input\_db\_size) | Amount of storage desired for the database in GB. (default: 100) | `number` | `100` | no |
| <a name="input_db_storage_alarm_threshold"></a> [db\_storage\_alarm\_threshold](#input\_db\_storage\_alarm\_threshold) | CES alarm threshold (in percent) for database storage capacity. Can be disabled by setting to 0. (default: 75) | `number` | `75` | no |
| <a name="input_db_storage_type"></a> [db\_storage\_type](#input\_db\_storage\_type) | Type of storage desired for the database. (default: ULTRAHIGH) | `string` | `"ULTRAHIGH"` | no |
| <a name="input_db_volume_encryption"></a> [db\_volume\_encryption](#input\_db\_volume\_encryption) | Enable OTC KMS volume encryption for the database volumes. (default: true) | `bool` | `true` | no |
| <a name="input_db_volume_encryption_key_name"></a> [db\_volume\_encryption\_key\_name](#input\_db\_volume\_encryption\_key\_name) | If KMS volume encryption is enabled for the database volumes, use this kms key name instead of creating a new one. (default: null) | `string` | `null` | no |
| <a name="input_sg_allowed_cidr"></a> [sg\_allowed\_cidr](#input\_sg\_allowed\_cidr) | CIDR ranges that are allowed to connect to the database. (default: <var.subnet\_id.cidr>) | `set(string)` | `[]` | no |
| <a name="input_sg_allowed_secgroups"></a> [sg\_allowed\_secgroups](#input\_sg\_allowed\_secgroups) | Security groups that are allowed to connect to the database. (default: []) | `set(string)` | `[]` | no |
| <a name="input_sg_secgroup_id"></a> [sg\_secgroup\_id](#input\_sg\_secgroup\_id) | Security group override to allow user defined security group definitions. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_ids"></a> [db\_instance\_ids](#output\_db\_instance\_ids) | n/a |
| <a name="output_db_private_ip"></a> [db\_private\_ip](#output\_db\_private\_ip) | n/a |
| <a name="output_db_public_ip"></a> [db\_public\_ip](#output\_db\_public\_ip) | n/a |
| <a name="output_db_root_password"></a> [db\_root\_password](#output\_db\_root\_password) | n/a |
| <a name="output_db_root_username"></a> [db\_root\_username](#output\_db\_root\_username) | n/a |
| <a name="output_sg_secgroup_id"></a> [sg\_secgroup\_id](#output\_sg\_secgroup\_id) | n/a |
<!-- END_TF_DOCS -->
