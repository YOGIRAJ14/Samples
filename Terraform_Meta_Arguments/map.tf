#Use to provide same tags to multiple resources

resource "aws_instance" "example" {
  ami  = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"
  tags  = var.tag_values                #It will take tags from below variable values

}



variable "tag_values" {
  description = "Map of tags to assign to the resources"
  type  = map(string)
  default  = {
  Environment = "Dev"
  Team  = "Cloudengg"
  Cloudtype = "aws"
  os = "Ubuntu"
  costcentre = 0022        #We allot no 0022 (can be diff) for each team so company can calculate resources cost for particular team
  }
}
