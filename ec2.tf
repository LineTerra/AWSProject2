# Create EC2 Instances

resource "aws_instance" "web1" { 

    ami = "ami-0df435f331839b2d6"   # provided Amzone Linux AMI ID
     
    instance_type = "t2.micro"

    # count = 1 #No of instances needed
    
    security_groups = [aws_security_group.allow-ssh.id] 

    subnet_id = aws_subnet.main-public-1.id
    
    #key_name = "terraform" 

    user_data = <<-EOF
                #!/bin/bash
                echo "Web-1"
                EOF
    
    tags = { 
        Name = "test-server1" 
    } 
} 

resource "aws_instance" "web2" { 

    ami = "ami-0df435f331839b2d6"   # provided Amzone Linux AMI ID
     
    instance_type = "t2.micro"

    count = 1 #No of instances needed
    
    security_groups = [aws_security_group.allow-ssh.id] 

    subnet_id = element(aws_subnet.main-public-2[*].id, count.index)
    
    #key_name = "terraform" 

    user_data = <<-EOF
                #!/bin/bash
                echo "Web-2"
                EOF
    
    tags = { 
        Name = "test-server2" 
    } 
} 

resource "aws_instance" "web3" { 

    ami = "ami-0df435f331839b2d6"   # provided Amzone Linux AMI ID
     
    instance_type = "t2.micro"

    count = 1 #No of instances needed
    
    security_groups = [aws_security_group.allow-ssh.id] 

    subnet_id = element(aws_subnet.main-public-3[*].id, count.index)
    
    #key_name = "terraform" 

    user_data = <<-EOF
                #!/bin/bash
                echo "Web-3"
                EOF
    
    tags = { 
        Name = "test-server3" 
    } 
} 


# attach EC2 instance to target group

resource "aws_lb_target_group_attachment" "my_target_group_attachment1" {
  count=3
  target_group_arn = aws_lb_target_group.myalb_target_group.arn
  target_id = aws_instance.web1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment2" {
  count=3
  target_group_arn = aws_lb_target_group.myalb_target_group.arn
  #target_id = aws_instance.web2.id
  target_id = element(aws_instance.web2.*.id, count.index)
  
  port = 80
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment3" {
  count=3
  target_group_arn = aws_lb_target_group.myalb_target_group.arn
  #target_id = aws_instance.web2.id
  target_id = element(aws_instance.web3.*.id, count.index)
  
  port = 80
}
