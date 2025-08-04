resource "aws_db_instance" "db_instance" {
  engine                   = var.engine_name                              # DB engine type (e.g., "mysql", "postgres")
  db_name                  = var.db_name                                  # Database name inside the instance
  username                 = var.user_name                                # Master username for DB
  password                 = var.pass                                     # Master password (should come from a secure variable)
  skip_final_snapshot      = var.skip_finalSnapshot                       # Skip snapshot on delete (true/false)
  db_subnet_group_name     = aws_db_subnet_group.db_sub_group.id          # Subnet group for DB (used for VPC setup)
  delete_automated_backups = var.delete_automated_backup                  # Whether to delete automated backups (true/false)
  multi_az                 = var.multi_az_deployment                      # Deploy in multiple availability zones (for high availability)
  publicly_accessible      = var.public_access                            # Make DB accessible from public internet (true/false)
  vpc_security_group_ids   = [data.aws_security_group.tcw_sg.id]          # Security group to control DB access
  instance_class           = var.instance_class                           # DB instance type (e.g., "db.t3.micro")                          
  allocated_storage        = 20                                           # Storage in GB (e.g., 20)
}
