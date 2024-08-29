data "aws_iam_policy_document" "this" {
  count = var.create_policy ? 1 : 0
  statement {
    effect = "Allow"
    dynamic "principals" {
      for_each = var.principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
    actions   = var.actions
    resources = [aws_sqs_queue.this.arn]
  }
}

resource "aws_sqs_queue_policy" "this" {
  count     = (var.principals != null && var.actions != null) ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.this[0].json

  depends_on = [data.aws_iam_policy_document.this]
}