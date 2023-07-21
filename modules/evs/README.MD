# Terraform OpenTelekomCloud Module

This is a Terraform module that provisions encrypted Elastic Volume Service (EVS) on OpenTelekomCloud. 
This module is capable of creating multiple EVS volumes using parameters for their names, specifications, and availability zones.


### Usage example

```hcl

module "elasticsearch_volumes" {
  source      = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/evs"
  volume_names       = ["elasticsearch-${var.stage}-0","elasticsearch-${var.stage}-1"]
  availability_zones = [  "eu-de-02", "eu-de-03"]
  kms_key_prefix     = "elasticsearch-${var.stage}"
  spec = {
    size        = 200
    volume_type = "SSD"
    device_type = "SCSI"
  }
  tags = local.tags
}


```


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| opentelekomcloud | * |

## Providers

| Name | Version |
|------|---------|
| opentelekomcloud | * |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| volume_names | List of names for the volumes to be created | list(string) | n/a | yes |
| tags | Common tag set for project resources | map(string) | {} | no |
| spec | Volume specifications like size, volume type and device type | object | { size=20, volume_type="SSD", device_type="SCSI" } | no |
| availability_zones | List of availability zones for the volumes | list(string) | ["eu-de-01"] | no |
| kms_key_prefix | Prefix to be used for creating the kms key | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| volumes | A map of created volumes where keys are volume names |