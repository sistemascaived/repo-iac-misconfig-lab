provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "open_sg" {
  name        = "open-sg"
  description = "Security group intentionally insecure"

  ingress {
    description = "SSH open to world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP open to world"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "trend-lab-insecure-bucket-123456789"

  tags = {
    Environment = "lab"
  }
}

resource "aws_s3_bucket_public_access_block" "bad_bucket_pab" {
  bucket = aws_s3_bucket.bad_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_db_instance" "bad_db" {
  identifier             = "lab-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "WeakPassword123!"
  skip_final_snapshot    = true
  publicly_accessible    = true
  backup_retention_period = 0
}
