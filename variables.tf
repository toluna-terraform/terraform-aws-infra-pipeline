variable "env_name" {
  type = string
}

variable "source_repository" {
  type    = string
  default = "tolunaengineering/chorus"
}

variable "trigger_branch" {
  type = string
}

variable "tf_backend_bucket" {
  type = string
}

