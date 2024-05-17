variable "projects" {
  type        = map(string)
  description = "A map of project names to project descriptions."
}

locals {
  builtin_projects = [
    "eu-de",
    "eu-nl",
    "MOS",
  ]
}
