variable "name" {
  type        = string
  description = "Name of Queue"
  default     = "test-queue"
}

variable "deadLetterTargetArn" {
  type        = string
  description = "use this for SQS endpoint configs"
  default     = ""
}

variable "create_policy" {
  type        = bool
  description = "If SQS policy is required."
  default     = false
}

variable "delay_seconds" {
  type        = number
  description = "delay seconds"
  default     = 0
}

variable "maxReceiveCount" {
  type        = number
  description = "setting for dead letter queue"
  default     = 1
}

variable "max_message_size" {
  type        = number
  description = "size of maximum message"
  default     = 262144
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Time out for visibility"
  default     = 0
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Time in seconds to wait"
  default     = 20
}

variable "message_retention_seconds" {
  type        = number
  description = "Time until message can be retained."
  default     = 3600
}

variable "fifo_queue" {
  type        = bool
  description = "If the Queue is going to be FIFO"
  default     = false
}

variable "content_based_deduplication" {
  type        = bool
  description = "Content based duplication"
  default     = false
}

variable "principals" {
  type = list(object({
    type        = string
    identifiers = list(string)
  }))
  description = "A mapping of principals to allow to the SQS policy."
  default = [
    {
      type        = "*"
      identifiers = ["*"]
    }
  ]
}

variable "actions" {
  type        = list(string)
  description = "A list of policy actions to allow to the SQS."
  default     = ["sqs:*"]
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the SQS."
  default = {
    Purpose = "SQS queue testing"
  }
}