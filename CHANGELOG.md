# Change Log

## [v1.2.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.2.0) (2016-05-29)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

- add changelog generator [\#104](https://github.com/dev-sec/chef-ssh-hardening/pull/104) ([chris-rock](https://github.com/chris-rock))

**Closed issues:**

- SFTP not configurable [\#110](https://github.com/dev-sec/chef-ssh-hardening/issues/110)
- default to 'UseRoaming no' [\#109](https://github.com/dev-sec/chef-ssh-hardening/issues/109)
- Consider using blank config\_disclaimer by default [\#94](https://github.com/dev-sec/chef-ssh-hardening/issues/94)

**Merged pull requests:**

- Document MaxAuthTries and MaxSessions added in 66e7ebfd [\#115](https://github.com/dev-sec/chef-ssh-hardening/pull/115) ([bazbremner](https://github.com/bazbremner))
- Use new InSpec integration tests [\#114](https://github.com/dev-sec/chef-ssh-hardening/pull/114) ([atomic111](https://github.com/atomic111))
- Add conditional to cover systemd in Ubuntu 15.04+ [\#112](https://github.com/dev-sec/chef-ssh-hardening/pull/112) ([elijah](https://github.com/elijah))
- Feature/sftp [\#111](https://github.com/dev-sec/chef-ssh-hardening/pull/111) ([jmara](https://github.com/jmara))
- Disable experimental client roaming [\#108](https://github.com/dev-sec/chef-ssh-hardening/pull/108) ([ascendantlogic](https://github.com/ascendantlogic))
- Made MaxAuthTries and MaxSessions configurable [\#107](https://github.com/dev-sec/chef-ssh-hardening/pull/107) ([runningman84](https://github.com/runningman84))
- added inspec support \(kitchen.yml and Gemfile\) [\#106](https://github.com/dev-sec/chef-ssh-hardening/pull/106) ([atomic111](https://github.com/atomic111))
- Apply PasswordAuthentication attribute to SSH [\#105](https://github.com/dev-sec/chef-ssh-hardening/pull/105) ([SteveLowe](https://github.com/SteveLowe))
- Configurable PasswordAuthentication  [\#102](https://github.com/dev-sec/chef-ssh-hardening/pull/102) ([sumit-goel](https://github.com/sumit-goel))
- x11 forwarding should be configurable like tcp and agent forwarding [\#99](https://github.com/dev-sec/chef-ssh-hardening/pull/99) ([patcon](https://github.com/patcon))
- Correct recipe names in the README [\#98](https://github.com/dev-sec/chef-ssh-hardening/pull/98) ([michaelklishin](https://github.com/michaelklishin))
- update common kitchen.yml platforms [\#97](https://github.com/dev-sec/chef-ssh-hardening/pull/97) ([chris-rock](https://github.com/chris-rock))
- fixes \#94 [\#95](https://github.com/dev-sec/chef-ssh-hardening/pull/95) ([chris-rock](https://github.com/chris-rock))
- remove old slack notification [\#92](https://github.com/dev-sec/chef-ssh-hardening/pull/92) ([chris-rock](https://github.com/chris-rock))
- update common Gemfile for chef11+12 [\#91](https://github.com/dev-sec/chef-ssh-hardening/pull/91) ([arlimus](https://github.com/arlimus))
- common files: centos7 + rubocop [\#90](https://github.com/dev-sec/chef-ssh-hardening/pull/90) ([arlimus](https://github.com/arlimus))
- improve metadata description [\#88](https://github.com/dev-sec/chef-ssh-hardening/pull/88) ([chris-rock](https://github.com/chris-rock))

## [v1.1.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.1.0) (2015-04-28)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.0.3...v1.1.0)

**Closed issues:**

- Use new "UseDNS" openssh default [\#81](https://github.com/dev-sec/chef-ssh-hardening/issues/81)
- UseDNS no [\#79](https://github.com/dev-sec/chef-ssh-hardening/issues/79)
- Debian 8.0 \(Jessie\) ships with OpenSSH 6.7p1, enable modern algos [\#77](https://github.com/dev-sec/chef-ssh-hardening/issues/77)
- Allow management of allow/deny users [\#75](https://github.com/dev-sec/chef-ssh-hardening/issues/75)
- update tutorial.md [\#55](https://github.com/dev-sec/chef-ssh-hardening/issues/55)

**Merged pull requests:**

- add Debian 8  to local test-kitchen [\#84](https://github.com/dev-sec/chef-ssh-hardening/pull/84) ([chris-rock](https://github.com/chris-rock))
- Modern alogs for Jessie [\#83](https://github.com/dev-sec/chef-ssh-hardening/pull/83) ([Rockstar04](https://github.com/Rockstar04))
- Update README and use OpenSSH defaults for UseDNS [\#82](https://github.com/dev-sec/chef-ssh-hardening/pull/82) ([aried3r](https://github.com/aried3r))
- Make UseDNS configurable [\#80](https://github.com/dev-sec/chef-ssh-hardening/pull/80) ([aried3r](https://github.com/aried3r))
- update common readme badges [\#78](https://github.com/dev-sec/chef-ssh-hardening/pull/78) ([arlimus](https://github.com/arlimus))
- Allow deny users to be managed from attributes [\#76](https://github.com/dev-sec/chef-ssh-hardening/pull/76) ([Rockstar04](https://github.com/Rockstar04))
- fix typo in opensshdconf.erb, remove trailing whitespace [\#74](https://github.com/dev-sec/chef-ssh-hardening/pull/74) ([zachallett](https://github.com/zachallett))
- bugfix: adjust travis to work with chef12/ruby2 [\#73](https://github.com/dev-sec/chef-ssh-hardening/pull/73) ([arlimus](https://github.com/arlimus))
- add privilege separation via sandbox mode for ssh \>= 5.9 [\#72](https://github.com/dev-sec/chef-ssh-hardening/pull/72) ([arlimus](https://github.com/arlimus))
- Adding attributes to enable printing the MOTD. [\#71](https://github.com/dev-sec/chef-ssh-hardening/pull/71) ([dmerrick](https://github.com/dmerrick))

## [v1.0.3](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.0.3) (2015-01-14)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.0.2...v1.0.3)

**Closed issues:**

- Suggestion: Don't populate /root/.ssh/authorized\_keys by default [\#69](https://github.com/dev-sec/chef-ssh-hardening/issues/69)
- prefer etm MACs [\#66](https://github.com/dev-sec/chef-ssh-hardening/issues/66)
- disable sha1-based key exchanges [\#64](https://github.com/dev-sec/chef-ssh-hardening/issues/64)

**Merged pull requests:**

- remove sha1 key-exchange mechanisms from default [\#70](https://github.com/dev-sec/chef-ssh-hardening/pull/70) ([arlimus](https://github.com/arlimus))
- reprioritize etm macs [\#68](https://github.com/dev-sec/chef-ssh-hardening/pull/68) ([arlimus](https://github.com/arlimus))

## [v1.0.2](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.0.2) (2015-01-12)
**Closed issues:**

- release on supermarket [\#62](https://github.com/dev-sec/chef-ssh-hardening/issues/62)
- host\_key\_files should not include ssh\_host\_ecdsa\_key on every host [\#61](https://github.com/dev-sec/chef-ssh-hardening/issues/61)
- Protocol 1 options while SSH 2 is hard coded [\#57](https://github.com/dev-sec/chef-ssh-hardening/issues/57)
- Configuration of root keys via databag and attributes [\#37](https://github.com/dev-sec/chef-ssh-hardening/issues/37)
- Bad ciphers on debian 7.0 [\#25](https://github.com/dev-sec/chef-ssh-hardening/issues/25)
- update ssh service on changes [\#24](https://github.com/dev-sec/chef-ssh-hardening/issues/24)

**Merged pull requests:**

- add back GCM cipher [\#67](https://github.com/dev-sec/chef-ssh-hardening/pull/67) ([arlimus](https://github.com/arlimus))
- updating common files [\#63](https://github.com/dev-sec/chef-ssh-hardening/pull/63) ([arlimus](https://github.com/arlimus))
- update to rubocop 0.27, exclude Berksfile [\#60](https://github.com/dev-sec/chef-ssh-hardening/pull/60) ([bkw](https://github.com/bkw))
- updating common files [\#59](https://github.com/dev-sec/chef-ssh-hardening/pull/59) ([arlimus](https://github.com/arlimus))
- remove options that only apply to SSH protocol version 1 [\#58](https://github.com/dev-sec/chef-ssh-hardening/pull/58) ([arlimus](https://github.com/arlimus))
- bring back support for chef-solo [\#56](https://github.com/dev-sec/chef-ssh-hardening/pull/56) ([bkw](https://github.com/bkw))
- add coverage dir to gitignore, add chefignore [\#54](https://github.com/dev-sec/chef-ssh-hardening/pull/54) ([bkw](https://github.com/bkw))
- Deprecate managing authorized\_keys for root via data bag [\#52](https://github.com/dev-sec/chef-ssh-hardening/pull/52) ([bkw](https://github.com/bkw))
- Add slack notifications [\#51](https://github.com/dev-sec/chef-ssh-hardening/pull/51) ([bkw](https://github.com/bkw))
- make users data bag optional [\#50](https://github.com/dev-sec/chef-ssh-hardening/pull/50) ([bkw](https://github.com/bkw))
- allow cbc, hmac and kex to be configured individually for client and server. [\#49](https://github.com/dev-sec/chef-ssh-hardening/pull/49) ([bkw](https://github.com/bkw))
- supply proper links for the badges [\#48](https://github.com/dev-sec/chef-ssh-hardening/pull/48) ([bkw](https://github.com/bkw))
- update travis builds to ruby 2.1.3  [\#47](https://github.com/dev-sec/chef-ssh-hardening/pull/47) ([bkw](https://github.com/bkw))
- add gymnasium badge for dependencies [\#46](https://github.com/dev-sec/chef-ssh-hardening/pull/46) ([bkw](https://github.com/bkw))
- update to chefspec 4.1.1 [\#45](https://github.com/dev-sec/chef-ssh-hardening/pull/45) ([bkw](https://github.com/bkw))
- Add badges [\#44](https://github.com/dev-sec/chef-ssh-hardening/pull/44) ([bkw](https://github.com/bkw))
- Add chef spec [\#43](https://github.com/dev-sec/chef-ssh-hardening/pull/43) ([bkw](https://github.com/bkw))
- Update rubocop [\#42](https://github.com/dev-sec/chef-ssh-hardening/pull/42) ([bkw](https://github.com/bkw))
- fix filenames in comments [\#41](https://github.com/dev-sec/chef-ssh-hardening/pull/41) ([bkw](https://github.com/bkw))
- updating common files [\#40](https://github.com/dev-sec/chef-ssh-hardening/pull/40) ([arlimus](https://github.com/arlimus))
- Chef Spec Tests [\#39](https://github.com/dev-sec/chef-ssh-hardening/pull/39) ([chris-rock](https://github.com/chris-rock))
- improvement: switch to site location in berkshelf [\#38](https://github.com/dev-sec/chef-ssh-hardening/pull/38) ([chris-rock](https://github.com/chris-rock))
- Lint [\#36](https://github.com/dev-sec/chef-ssh-hardening/pull/36) ([chris-rock](https://github.com/chris-rock))
- minor change to make md table in COMPLIANCE.md work [\#35](https://github.com/dev-sec/chef-ssh-hardening/pull/35) ([jklare](https://github.com/jklare))
- added info on crypto to readme [\#34](https://github.com/dev-sec/chef-ssh-hardening/pull/34) ([arlimus](https://github.com/arlimus))
- improvement: added faq on locked accounts to readme [\#33](https://github.com/dev-sec/chef-ssh-hardening/pull/33) ([arlimus](https://github.com/arlimus))
- updated kitchen images to current batch \(mysql-equivalent\) [\#32](https://github.com/dev-sec/chef-ssh-hardening/pull/32) ([arlimus](https://github.com/arlimus))
- add recipe to unlock user accounts [\#31](https://github.com/dev-sec/chef-ssh-hardening/pull/31) ([arlimus](https://github.com/arlimus))
- add pam option to readme [\#30](https://github.com/dev-sec/chef-ssh-hardening/pull/30) ([chris-rock](https://github.com/chris-rock))
- fixes \#24 [\#29](https://github.com/dev-sec/chef-ssh-hardening/pull/29) ([chris-rock](https://github.com/chris-rock))
- fix end keyword [\#28](https://github.com/dev-sec/chef-ssh-hardening/pull/28) ([arlimus](https://github.com/arlimus))
- Debian6fix [\#27](https://github.com/dev-sec/chef-ssh-hardening/pull/27) ([arlimus](https://github.com/arlimus))
- update kitchen tests for vagrant [\#26](https://github.com/dev-sec/chef-ssh-hardening/pull/26) ([arlimus](https://github.com/arlimus))
- update rubocop, add default rake task. fix errors with default task [\#23](https://github.com/dev-sec/chef-ssh-hardening/pull/23) ([ehaselwanter](https://github.com/ehaselwanter))
- update with common run\_all\_linters task [\#22](https://github.com/dev-sec/chef-ssh-hardening/pull/22) ([ehaselwanter](https://github.com/ehaselwanter))
- adapt to new tests [\#21](https://github.com/dev-sec/chef-ssh-hardening/pull/21) ([chris-rock](https://github.com/chris-rock))
- add openstack kitchen gem [\#20](https://github.com/dev-sec/chef-ssh-hardening/pull/20) ([chris-rock](https://github.com/chris-rock))
- rename package name attribute from ssl\* to ssh\* [\#19](https://github.com/dev-sec/chef-ssh-hardening/pull/19) ([bkw](https://github.com/bkw))
- passwordless users not able to log in [\#18](https://github.com/dev-sec/chef-ssh-hardening/pull/18) ([bkw](https://github.com/bkw))
- add utf8 header and use ruby 1.9 hash syntax [\#17](https://github.com/dev-sec/chef-ssh-hardening/pull/17) ([chris-rock](https://github.com/chris-rock))
- add Berksfile.lock Gemfile.lock to ignore list and remove it from tree [\#15](https://github.com/dev-sec/chef-ssh-hardening/pull/15) ([ehaselwanter](https://github.com/ehaselwanter))
- Typo in username of ssh connection [\#14](https://github.com/dev-sec/chef-ssh-hardening/pull/14) ([sirkkalap](https://github.com/sirkkalap))
- streamline .rubocop config [\#13](https://github.com/dev-sec/chef-ssh-hardening/pull/13) ([ehaselwanter](https://github.com/ehaselwanter))
- use the role from the integration test suite, not distinct recipes [\#12](https://github.com/dev-sec/chef-ssh-hardening/pull/12) ([ehaselwanter](https://github.com/ehaselwanter))
- fix rubocop violations [\#11](https://github.com/dev-sec/chef-ssh-hardening/pull/11) ([ehaselwanter](https://github.com/ehaselwanter))
- fix foodcritic violations [\#10](https://github.com/dev-sec/chef-ssh-hardening/pull/10) ([ehaselwanter](https://github.com/ehaselwanter))
- made TCP and Agent Forwarding configurable [\#9](https://github.com/dev-sec/chef-ssh-hardening/pull/9) ([atomic111](https://github.com/atomic111))
- be more forgiving and relax rubocop [\#8](https://github.com/dev-sec/chef-ssh-hardening/pull/8) ([ehaselwanter](https://github.com/ehaselwanter))
- add lint and spec infrastructure [\#7](https://github.com/dev-sec/chef-ssh-hardening/pull/7) ([ehaselwanter](https://github.com/ehaselwanter))
- integrate sharedtests [\#6](https://github.com/dev-sec/chef-ssh-hardening/pull/6) ([ehaselwanter](https://github.com/ehaselwanter))
- remove aes-gcm algos from Ciphers, because of http://www.openssh.com/txt/gcmrekey.adv [\#5](https://github.com/dev-sec/chef-ssh-hardening/pull/5) ([atomic111](https://github.com/atomic111))
- fix really old copy-n-paste error in readme [\#4](https://github.com/dev-sec/chef-ssh-hardening/pull/4) ([arlimus](https://github.com/arlimus))
- Contributing guide [\#3](https://github.com/dev-sec/chef-ssh-hardening/pull/3) ([arlimus](https://github.com/arlimus))
- added all kitchen test for ssh\_config + sshd\_config and added TUTORIAL.md [\#2](https://github.com/dev-sec/chef-ssh-hardening/pull/2) ([atomic111](https://github.com/atomic111))
- add license and improve styling [\#1](https://github.com/dev-sec/chef-ssh-hardening/pull/1) ([chris-rock](https://github.com/chris-rock))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*