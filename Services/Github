## Install ssh keys for github and clone git repo to ArchServer

# Generate SSH key for github
    ssh-keygen -t rsa -b 4096 -C "<emailaddress>"

# Copy ssh key from .ssh/id_rsa.pub, go to Github -> Settings and add SSH key there
# Enable ssh for the first time
    ssh -T git@github.com
        # Select yes to add domain to known_hosts

# Copy over repo
    git clone git@github.com:TimoVerbrugghe/ArchServer.git