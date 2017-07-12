require 'aws-sdk'

description "CF Stack for Rails App"
# By not specifying a default value, a parameter becomes required.
# Specify this parameter by adding `--parameters KeyName:<ec2-keyname>` to your CLI options.
parameter :Environment, default: 'test'
parameter :DBInstanceType, default: 'db.t2.small'
parameter :MasterUsername, NoEcho: true, default: ""
parameter :MasterUserPassword, NoEcho: true, default: ""

# Define a security group to be applied to an instance.
# This one will allow SSH access from anywhere, and no other inbound traffic.
resource :DBEC2SecurityGroup, "AWS::EC2::SecurityGroup" do
  group_description 'DB Access for rails'

  # Parameter values can be Ruby arrays and hashes. These will be transformed to JSON.
  # You could write your own functions to make stuff like this easier, too.
  security_group_ingress [
    {
      CidrIp: '0.0.0.0/0',
      IpProtocol: 'tcp',
      FromPort: 3306,
      ToPort: 3306
    }
  ]
end

resource :PostgresDb, "AWS::RDS::DBInstance" do
  DBInstanceClass Fn::ref(:DBInstanceType)
  AllocatedStorage 100
  Engine "postgres"
  VPCSecurityGroups [Fn::get_att(:DBEC2SecurityGroup, "GroupId")]
  tag :Name, "RailsDb"
  MasterUsername Fn::ref(:MasterUsername)
  MasterUserPassword Fn::ref(:MasterUserPassword)

end
