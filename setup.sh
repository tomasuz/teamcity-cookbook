aws ec2 create-security-group --group-name "teamcity group" --description "teamcity group with enabled required incoming ports"
aws ec2 authorize-security-group-ingress --group-name "teamcity group" --protocol tcp --port 8111 --cidr "0.0.0.0/0" # enable http for teamcity server

