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

7. Create `solo.rb`

    This file is used to specify the configuration details for chef-solo. So create a `solo.rb` that includes the `cookbook_path`.

        cookbook_path "cookbooks"

8. Create `solo.json`

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

9. Run chef-solo

        chef-solo -c solo.rb -j solo.json




