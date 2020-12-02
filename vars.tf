variable "prefix" {
  description = "The prefix used for all resources in this example"
  default = "app"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default = "westeurope"

}

variable "image_name" {
  description = "The name for the image used in the application's container"
  default = "flask-application"
}
