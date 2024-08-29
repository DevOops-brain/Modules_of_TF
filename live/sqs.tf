###########--------------- SQS Modlue ---------------###########
#
#   For all the required SQS parameters and their use please follow the official documentation.
#   standard: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/creating-sqs-standard-queues.html
#   FIFO: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/creating-sqs-fifo-queues.html
#
# ---------- Points to note ----------
# 1. Update `source` path to the actual path of your module.
# 2. The variables 'vendor', 'project_name' and 'environment' must be set in `.tfvars` if used with distributed environment structure.
# 3. All the required and optional variables will go in locals `sqs_configs` as an object.
# 4. Do not add 'fifo' extention it's handled automatically.
# 5. Set `fifo_queue` to true if FIFO queue is required.
# 6. SQS policy is optional. `create_policy` to true if FIFO queue is required.
# 7. When `create_policy` is set to true `principals` and `actions` variables are required for the Policy.
# 8. For `deadLetterTargetArn` explicitly add the SQS ARN or reference from any module if DDL is separately created. 
#

locals {
  sqs_configs = [
    #---- FIFO Queue start ----# EXAMPLE 1
    {
      name                        = "${var.project_name}-${var.prefix}-${var.environment}-queue-one"
      delay_seconds               = 0
      max_message_size            = 262144
      visibility_timeout_seconds  = 120
      receive_wait_time_seconds   = 20
      message_retention_seconds   = 3600
      fifo_queue                  = true
      content_based_deduplication = false
      deadLetterTargetArn         = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:test.fifo"
      maxReceiveCount             = 1

      #---- Services specific tags must go here ----#
      tags = {
        Purpose = "Test SQS using terraform"
      }
      create_policy = false
    },
    #---- FIFO Queue end ----#

    #---- Standard Queue start ----# EXAMPLE 2
    {
      name                        = "${var.project_name}-${var.environment}-queue-ten"
      delay_seconds               = 0
      max_message_size            = 262144
      visibility_timeout_seconds  = 120
      receive_wait_time_seconds   = 20
      message_retention_seconds   = 3600
      fifo_queue                  = true
      content_based_deduplication = false
      deadLetterTargetArn         = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:test.fifo"
      maxReceiveCount             = 1

      #---- Services specific tags must go here ----#
      tags = {
        Purpose = "Test SQS using terraform"
        Other   = "value"
      }

      create_policy = false
    },
    #---- Standard Queue end ----#

    #---- Another Standard Queue start ----# EXAMPLE 3
    {
      name                        = "${var.project_name}-${var.prefix}-${var.environment}-queue-two"
      delay_seconds               = 10
      max_message_size            = 131072
      visibility_timeout_seconds  = 60
      receive_wait_time_seconds   = 10
      message_retention_seconds   = 7200
      fifo_queue                  = false
      content_based_deduplication = false
      tags = {
        Purpose = "Test SQS using terraform"
        Other   = "value"
      }

      #---- Policy configs ----#
      create_policy = true
      principals = [{
        type        = "*",
        identifiers = ["*"]
      }]
      actions = ["sqs:SendMessage"]
    }
    #---- Another Standard Queue start ----#
  ]

  sqs_configs_map = { for idx, config in local.sqs_configs : config.name => config }
}

module "sqs" {
  for_each = local.sqs_configs_map
  source   = "../modules/SQS"

  name                        = each.value.name
  delay_seconds               = each.value.delay_seconds
  max_message_size            = each.value.max_message_size
  visibility_timeout_seconds  = each.value.visibility_timeout_seconds
  receive_wait_time_seconds   = each.value.receive_wait_time_seconds
  message_retention_seconds   = each.value.message_retention_seconds
  fifo_queue                  = each.value.fifo_queue
  content_based_deduplication = each.value.content_based_deduplication
  deadLetterTargetArn         = try(each.value.deadLetterTargetArn, "")
  maxReceiveCount             = try(each.value.maxReceiveCount, 0)
  tags                        = each.value.tags

  ###--- Policy Document configs ---###
  create_policy = each.value.create_policy
  principals    = try(each.value.principals, null)
  actions       = try(each.value.actions, null)
}

###-------------- Module outputs --------------###
# Example
# module.sqs["name-key"].sqs_arn
output "sqs_arn" {
  value = module.sqs["demo-queue-ten"].sqs_arn
}

#---------------- Get all ARNs in one ----------------#
output "sqs_arns" {
  value = { for k, v in module.sqs : k => v.sqs_arn }
}
