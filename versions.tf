terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47"

      # acm certs must be in us-east-1, we require a provider in that region to create them
      configuration_aliases = [ aws.us_east_1 ]
    }
  }
}
