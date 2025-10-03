# DynamoDB table using the community module
module "books_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"
  # Optionally fix a version, e.g.: version = "~> 4.0"

  name         = var.table_name
  hash_key     = "ISBN"
  range_key    = "Genre"

  attributes = [
    {
      name = "ISBN"
      type = "S"
    },
    {
      name = "Genre"
      type = "S"
    }
  ]

  billing_mode = var.billing_mode

  # These are only used when PROVISIONED
 # read_capacity  = var.read_capacity
  #write_capacity = var.write_capacity

  # Keep other settings close to "defaults"
  point_in_time_recovery_enabled = false
  server_side_encryption_enabled = true
}

# Seed data as table items. Each item key is ISBN|Genre
locals {
  seed_map = {
    for item in var.seed_items :
    "${item.ISBN}|${item.Genre}" => item
  }
}

resource "aws_dynamodb_table_item" "seed" {
  for_each   = local.seed_map
  table_name = module.books_table.dynamodb_table_id
  hash_key   = "ISBN"
  range_key  = "Genre"

  # Construct DynamoDB JSON using jsonencode and conditional merge
  item = jsonencode(merge(
    {
      ISBN   = { S = each.value.ISBN }
      Genre  = { S = each.value.Genre }
      Title  = { S = each.value.Title }
      Author = { S = each.value.Author }
    },
    each.value.Stock == null ? {} : { Stock = { N = tostring(each.value.Stock) } }
  ))
}
