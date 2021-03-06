resource "aws_instance" "MYSQL_EC2" {
   ami = "ami-0db188056a6ff81ae"
   instance_type = "t2.micro"
   key_name = "ansible"
   subnet_id = element(aws_subnet.private_subnet.*.id, 1)
   vpc_security_group_ids = [aws_security_group.sg_db.id, ]
   tags = {
    Name        = "MYSQL"  
    Function        = "Database"
   }
}

resource "aws_instance" "FLASK_EC2" {
   ami = "ami-0db188056a6ff81ae"
   instance_type = "t2.micro"
   key_name = "ansible"
   subnet_id = element(aws_subnet.public_subnet.*.id, 1)
   vpc_security_group_ids = [aws_security_group.sg_app.id, ]
   tags = {
    Name        = "Flask"  
    Function       = "Application"
   }
}
