##################################################
# Generate a random id in case user wants us to generate admin password
###################################################
resource "random_id" "wspasswd" {
  byte_length = "4"
}

##################################################
# Create a new profile
###################################################
resource "null_resource" "create_profile" {
  
  # This will accept either or all of SSH password, ssh key file and base64 encoded content of private key
  connection {
    host = "${var.server}"
    user = "${var.ssh_user}"
    private_key = "${var.ssh_key_content == "None" ? file(coalesce(var.ssh_key, format("%s/devnull", path.module))) : base64decode(var.ssh_key_content)}"
    password    = "${var.ssh_password}"
  }
  
  # JSON dump the contents of sw_archive items
  provisioner "file" {
    content     = "${jsonencode(var.profile_create_opts)}"
    destination = "/tmp/wsadmin-profile-create-config.yaml"
  }

  # Simple python script to parse the json encoded options map.
  # Outputs the JSON in the format "-key1 value1 -key2 value2.....-keyN valueN"
  # Supports empty values
  provisioner "file" {
    destination = "/tmp/parseoptions.py"
 content     = <<EOF
import os, sys, json
# Hard coded options file for now
optionjson = '/tmp/wsadmin-profile-create-config.yaml'

# Read parameter items
with open(optionjson, 'r') as stream:
  o = json.load(stream)

parameters = ''
if len(o) > 0:
  for key, val in o.iteritems():
    parameters += ' -%s %s' % (key, val)

print parameters
EOF
  }
  
  # If we want to support other archive locations we can refactor this to be run from a script later
  # Right now run manageprofiles with parsed options
  provisioner "remote-exec" {
    inline = [
      "while ! test -e ${var.base_dir}/.install_complete ; do  echo \"Waiting for software install to complete\" ; sleep 10s ; done",       # Workaround for lack of module dependency
      "echo \"========== Creating profile ============\"",
      "${var.base_dir}/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -adminUserName ${var.wsadmin_user} -adminPassword ${var.admin_password != "Generate" ? var.admin_password : random_id.wspasswd.hex} `python /tmp/parseoptions.py`"
    ]
  }
}
