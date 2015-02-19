This is a re-usable [Ansible] playbook and roles for setting up FarCry servers.
It is intended to work for both local Vagrant instances and production servers, 
for example in AWS. Some of the design goals of this provisioning script are
that it:

* can be used to set up any FarCry project
* all customisations are in the form of inventory variables, and that 
  consequently, it
* does not need to be modified - it can be sub-moduled into a "super-project"
  that provides project specific settings

## Usage

Create a container project to contain the project specific settings. This 
project is also a good place to put a Vagrantfile if appropriate. You should 
also put Ansible [inventory files] there if you're using them. You _can_ use 
this playbook without one.

### Settings

Add a `group_vars` directory to the container project. Create Ansible 
[variable files] here to hold the playbook settings. Common settings, like the
project repository should go in `group_vars/webservers`. For example:

    ---
      farcry_repository: git@github.com:farcrycore/project-barebones.git

Environment specific settings should go into files named for the environment.
Examples of environments we use are `vagrant`, `stage` and `production`. The
settings in these files override the settings in the `webservers` file. For
example:

    ---
      domains: [ "barebones.stage.someplace.online.com", "1.2.3.4" ]
      nginx_sendfile: "off"
      application_environment: stage

You can see what variables each role uses by looking through the 
`defaults/main.yml` in each one. But there are some other important settings
that turn a whole role off. These settings are named `role_name`, and are 
simple to use:

    ---
      role_awscli: no

### Running

You can run this playbook against a remote machine from your local computer,
or directly on the server being updated.

#### From a Local Machine

You can only run the playbook from a local machine if you have 
[installed Ansible]. At the moment that means Linux and Mac only. Make sure you
also have this repository and your container project checked out on the machine.

You also need to set up an [inventory file][inventory files] like this in your
container project:

    [stage]
    1.2.3.4 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=aws-key.pem application_environment=prod
    
    [webservers]
    stage

Your inventory can contain as many environments as you like, and even other 
servers. You would just need to target your updates using [patterns]. 

Run this command in the shell:

    ansible-playbook -i /path-to-container-project/your_inventory_file /path-to-this-project/webserver.yml

#### On the Server

First make sure you have both this playbook repository and your container 
project checked out on the server. Then run this command in the shell:

    /path-to-this-project/ansible-run.sh --playbook /path-to-this-project/webserver.yml --inventory /path-to-container-project/inventory_temp --group webservers --environment [environment name]

A couple of things to notice here:

* the playbook is passed in, even though it comes with this project - this
  will make it easy for you to use your own playbooks, and for us to add extra
  playbooks in the future
* the command specifies a temporary inventory with a group and environment
  argument - you can also create your own inventory files and use those, 
  leaving out the group and environment variables

[Vagrant]: http://docs.ansible.com/index.html
[submodules]: http://git-scm.com/book/en/v2/Git-Tools-Submodules
[inventory files]: http://docs.ansible.com/intro_inventory.html
[variable files]: http://docs.ansible.com/playbooks_variables.html#variable-file-separation
[installed Ansible]: http://docs.ansible.com/intro_installation.html
[patterns]: http://docs.ansible.com/intro_patterns.html