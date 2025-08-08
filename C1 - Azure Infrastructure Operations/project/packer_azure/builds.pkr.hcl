build {
  name = "ubuntu_packer_builders_Image"  
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["export DEBIAN_FRONTEND=noninteractive",
                       "apt-get update", 
                       "apt-get upgrade -y"
                       ]
    inline_shebang  = "/bin/sh -x"
  }

}