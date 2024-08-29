variable "environment" {
  type        = string
  description = "Must be one of: dev, stg or prod"
  default     = "demo"
}

variable "project_name" {
  type        = string
  description = "Indicates the name of the project."
  default     = "test"
}

variable "prefix" {
  type        = string
  description = "Used as a AWS service prefix or App specific names if available. If not specified it returns null."
  default     = "some-service"
  nullable    = true
}