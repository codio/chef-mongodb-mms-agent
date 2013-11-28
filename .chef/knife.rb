# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

node_name               ENV["USER"] || "solo"
validation_client_name  "codio-validator"
validation_key          File.expand_path("~/.chef/codio/validator.pem", __FILE__)
chef_server_url         "https://api.opscode.com/organizations/codio"
client_key              File.expand_path("~/.chef/codio/client.pem", __FILE__)
