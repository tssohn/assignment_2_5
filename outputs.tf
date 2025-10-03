output "table_name" {
  value = module.books_table.dynamodb_table_id
}

output "table_arn" {
  value = module.books_table.dynamodb_table_arn
}
