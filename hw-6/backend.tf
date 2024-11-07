terraform {
  backend "s3" {
    bucket = "wheremybucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
