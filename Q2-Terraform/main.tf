
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "web" {
  count = 2

  name  = "lab3-web-${count.index + 1}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8081 + count.index
  }
}

output "container_names" {
  value = docker_container.web[*].name
}

output "application_urls" {
  value = [
    for container in docker_container.web :
    "http://localhost:${container.ports[0].external}"
  ]
}
