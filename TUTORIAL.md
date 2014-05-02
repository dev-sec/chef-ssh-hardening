# Tutorial

## Deutsche Telekom AG

### Debian / Ubuntu

1. Install ruby

        apt-get install ruby1.9.1-full

2. Install chef

        gem1.9.1 install chef

3. May be you have to adjust the `$PATH` variable

        export PATH=$PATH:/var/lib/gems/1.9.1/bin/

4. Download the chef cookbook

        git clone https://github.com/TelekomLabs/chef-ssh-hardening.git

5. Move hardening to `cookbooks`

        mkdir cookbooks
        mv chef-ssh-hardening cookbooks/ssh-hardening

6. Download some dependences for the os-hardening cookbook

        cd cookbooks
        git clone https://github.com/edelight/chef-solo-search
        cd ..

7. Add a public key to the root user `data_bags/users/root.json`

        {
          "id" : "root",
          "ssh_rootkeys" : "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TCCCCCCjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qPasgCgzUFtdOKLv6IedplqoPasdasd0aYet2PkEDo3MlTBckFXPITAMzF8dJSICCCCFo9D8HfdOV0IAdx4O7dETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIUc9c9WhQ== vagrant insecure public key"
        }

8. Create `solo.rb`

    This file is used to specify the configuration details for chef-solo. So create a `solo.rb` that include the `cookbook_path` and the `data_bags`.

        cookbook_path "cookbooks"
        data_bag_path "data_bags

9. Create `solo.json`

    Chef-solo does not interact with the Chef Server. Consequently, node-specific attributes must be located in a JSON file on the target system. Create the following `solo.json`.

        {

            "ssh" : {
                "listen_to" : "10.0.2.15"
           },
            "run_list":[
                "recipe[chef-solo-search]",
                "recipe[ssh-hardening::server]"
            ]
        }

10. Run chef-solo

        chef-solo -c solo.rb -j solo.json




