resource "aws_sqs_queue" "this" {
  name                        = var.fifo_queue == true ? "${var.name}.fifo" : var.name
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  message_retention_seconds   = var.message_retention_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  tags = merge({
    Name = var.fifo_queue == true ? "${var.name}.fifo" : var.name
  }, var.tags)

  ####---------- use if dead letter queue needed ----------####
  redrive_policy = var.deadLetterTargetArn != "" && var.maxReceiveCount > 0 ? jsonencode({
    deadLetterTargetArn = var.deadLetterTargetArn
    maxReceiveCount     = var.maxReceiveCount
  }) : null
}