# AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM
AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM

This module was built VPC IN ACCOUN-A AND BUILD S3 BUCKET IN ACCOUN-B [cookiecutter-microservice](https://github.com/Bkoji1150/AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM).


# RESOURCES
ACCOUNT-A

vpc
ec2
s3 private link

ACCOUNT-B
In Account B 
s3 Bucket
bucket policy

# Usage
There are two instances in ACCOUNT-A both PUBLIC and AND PRIVATE instance in ACCOUNT-A. 
and the private instance kept in a private subnet needs to Access in s3 bucket Found in Account-B

# Account a is open to port 22
```hcl
ssh -i id_rsa ec2-user@publicIpp
```
# Create a file in and and copy the content of "id_rsa" in the file
```hcl
cat > id_rsa 
-----BEGIN RSA PRIVATE KEY-----
MIIG5AIBAAKCAYEA4zQL1pUg7p4AWeTrtsgwwbLobfGUqAB11hlDGYDWeOWKXpbCq
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dS9pIuI0jwOrfjGM4sWyGKk8hPehg92e^%%%Iwpa38CpCd42yb68w==
-----END RSA PRIVATE KEY-----
```
# change permision on the file
```hcl
chmod 400 id_rsa
```
# ssh to private instance in using the newly created key
```hcl
ssh -i id_rsa ec2-user@private_ip
```

# Now the test the connection and make sure we can access s3 object in ACCOUNT-B
```hcl
aws s3 ls s3://BUCKETNAME
```

# Authour 
kojibello058@gmail.com
