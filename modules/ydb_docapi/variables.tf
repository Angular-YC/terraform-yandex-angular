variable "app_name" {
  description = "Application name"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "enable_throttling" {
  description = "Enable RCU throttling"
  type        = bool
  default     = false
}

variable "throttling_rcu_limit" {
  description = "RCU throttling limit"
  type        = number
  default     = 0
}

variable "storage_size_limit" {
  description = "Storage size limit in bytes"
  type        = number
  default     = 53687091200 # 50GB
}

variable "tables" {
  description = "YDB table configurations for response cache metadata"
  type = map(object({
    hash_key      = string
    range_key     = optional(string)
    ttl_attribute = optional(string)
  }))
  default = {
    response_cache_entries = {
      hash_key      = "pk"
      range_key     = "sk"
      ttl_attribute = "ttl"
    }
    response_cache_tags = {
      hash_key      = "pk"
      range_key     = "sk"
      ttl_attribute = "ttl"
    }
    response_cache_locks = {
      hash_key      = "pk"
      ttl_attribute = "ttl"
    }
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
