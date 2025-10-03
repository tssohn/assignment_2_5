variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "Optional AWS named profile to use with the provider"
  type        = string
  default     = null
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "yourname-bookinventory"
}

variable "billing_mode" {
  description = "Billing mode for the table: PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED"
  }
}

variable "read_capacity" {
  description = "Read capacity (only used when billing_mode=PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity (only used when billing_mode=PROVISIONED)"
  type        = number
  default     = 5
}

variable "seed_items" {
  description = "List of seed items to upsert into the table"
  type = list(object({
    ISBN   : string
    Genre  : string
    Title  : string
    Author : string
    Stock  : number
    # Stock can be set to null if an item doesn't have it
  }))
  default = [
    {
      ISBN   = "978-0134685991"
      Genre  = "Technology"
      Title  = "Effective Java"
      Author = "Joshua Bloch"
      Stock  = 1
    },
    {
      ISBN   = "978-0134685009"
      Genre  = "Technology"
      Title  = "Learning Python"
      Author = "Mark Lutz"
      Stock  = 2
    },
    {
      ISBN   = "974-0134789698"
      Genre  = "Fiction"
      Title  = "The Hitchhiker"
      Author = "Douglas Adams"
      Stock  = 10
    },
    {
      ISBN   = "982-01346653457"
      Genre  = "Fiction"
      Title  = "Dune"
      Author = "Frank Herbert"
      Stock  = 8
    },
    {
      ISBN   = "978-01346854325"
      Genre  = "Technology"
      Title  = "System Design"
      Author = "Mark Lutz"
      Stock  = null
    }
  ]
}
