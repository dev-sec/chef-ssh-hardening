# Change Log

## [v1.3.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.3.0) (2016-11-15)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.2.1...v1.3.0)

**Implemented enhancements:**

- Support for OpenSuse Leap, new enterprise distro of SUSE [\#128](https://github.com/dev-sec/chef-ssh-hardening/pull/128) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Avoid duplicate resource names because of warnings [\#127](https://github.com/dev-sec/chef-ssh-hardening/pull/127) ([artem-sidorenko](https://github.com/artem-sidorenko))

**Closed issues:**

- Allow to configure ChallengeResponseAuthentication \(currently it's hardcoded to no\) [\#125](https://github.com/dev-sec/chef-ssh-hardening/issues/125)
- Make LoginGraceTime configurable  [\#116](https://github.com/dev-sec/chef-ssh-hardening/issues/116)
- Failures when running kitchen test with tests-compliance-ssh profile [\#113](https://github.com/dev-sec/chef-ssh-hardening/issues/113)
- ERROR: Role ssh \(included by 'top level'\) is in the runlist but does not exist [\#101](https://github.com/dev-sec/chef-ssh-hardening/issues/101)
- Allow to configure MaxAuthTries [\#100](https://github.com/dev-sec/chef-ssh-hardening/issues/100)
- Default value for \['ssh'\]\['allow\_tcp\_forwarding'\] breaks Chef Zero [\#93](https://github.com/dev-sec/chef-ssh-hardening/issues/93)
- Wrong detection of os version number on debian 8 [\#85](https://github.com/dev-sec/chef-ssh-hardening/issues/85)

**Merged pull requests:**

- Distro information for supermarket [\#138](https://github.com/dev-sec/chef-ssh-hardening/pull/138) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Allow login grace time to be configurable [\#132](https://github.com/dev-sec/chef-ssh-hardening/pull/132) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Allow to configure ChallengeResponseAuthentication [\#131](https://github.com/dev-sec/chef-ssh-hardening/pull/131) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Configurable SSH Banner File [\#130](https://github.com/dev-sec/chef-ssh-hardening/pull/130) ([sidxz](https://github.com/sidxz))
- Update kitchen vagrant configuration [\#129](https://github.com/dev-sec/chef-ssh-hardening/pull/129) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Parameterise Banner and DebianBanner as attributes [\#126](https://github.com/dev-sec/chef-ssh-hardening/pull/126) ([tsenart](https://github.com/tsenart))
- Update Rubocop, Foodcritic, and Chefspec coverage [\#124](https://github.com/dev-sec/chef-ssh-hardening/pull/124) ([shortdudey123](https://github.com/shortdudey123))

## [v1.2.1](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.2.1) (2016-09-25)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.2.0...v1.2.1)

**Implemented enhancements:**

- add suse and opensuse support [\#122](https://github.com/dev-sec/chef-ssh-hardening/pull/122) ([chris-rock](https://github.com/chris-rock))
- activate fedora integration tests in travis [\#120](https://github.com/dev-sec/chef-ssh-hardening/pull/120) ([chris-rock](https://github.com/chris-rock))

**Merged pull requests:**

- Fix deprecation warnings [\#123](https://github.com/dev-sec/chef-ssh-hardening/pull/123) ([operatingops](https://github.com/operatingops))
- Use bracket syntax in attributes/default.rb [\#121](https://github.com/dev-sec/chef-ssh-hardening/pull/121) ([aried3r](https://github.com/aried3r))
- Use new ciphers, kex, macs and priv separation sandbox for redhat family 7 [\#119](https://github.com/dev-sec/chef-ssh-hardening/pull/119) ([atomic111](https://github.com/atomic111))
- change hardening-io to dev-sec domain for build status and code coverage [\#118](https://github.com/dev-sec/chef-ssh-hardening/pull/118) ([atomic111](https://github.com/atomic111))

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
- Configurable PasswordAuthentication  [\#102](https://github.com/dev-sec/chef-ssh-hardening/pull/102) ([sumitgoelpw](https://github.com/sumitgoelpw))
- x11 forwarding should be configurable like tcp and agent forwarding [\#99](https://github.com/dev-sec/chef-ssh-hardening/pull/99) ([patcon](https://github.com/patcon))

## [v1.1.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.1.0) (2015-04-28)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.0.3...v1.1.0)

**Closed issues:**

- Use new "UseDNS" openssh default [\#81](https://github.com/dev-sec/chef-ssh-hardening/issues/81)
- UseDNS no [\#79](https://github.com/dev-sec/chef-ssh-hardening/issues/79)
- Debian 8.0 \(Jessie\) ships with OpenSSH 6.7p1, enable modern algos [\#77](https://github.com/dev-sec/chef-ssh-hardening/issues/77)
- Allow management of allow/deny users [\#75](https://github.com/dev-sec/chef-ssh-hardening/issues/75)
- update tutorial.md [\#55](https://github.com/dev-sec/chef-ssh-hardening/issues/55)

## [v1.0.3](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.0.3) (2015-01-14)
[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.0.2...v1.0.3)

**Closed issues:**

- Suggestion: Don't populate /root/.ssh/authorized\_keys by default [\#69](https://github.com/dev-sec/chef-ssh-hardening/issues/69)
- prefer etm MACs [\#66](https://github.com/dev-sec/chef-ssh-hardening/issues/66)
- disable sha1-based key exchanges [\#64](https://github.com/dev-sec/chef-ssh-hardening/issues/64)

## [v1.0.2](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.0.2) (2015-01-12)
**Closed issues:**

- release on supermarket [\#62](https://github.com/dev-sec/chef-ssh-hardening/issues/62)
- host\_key\_files should not include ssh\_host\_ecdsa\_key on every host [\#61](https://github.com/dev-sec/chef-ssh-hardening/issues/61)
- Protocol 1 options while SSH 2 is hard coded [\#57](https://github.com/dev-sec/chef-ssh-hardening/issues/57)
- Configuration of root keys via databag and attributes [\#37](https://github.com/dev-sec/chef-ssh-hardening/issues/37)
- Bad ciphers on debian 7.0 [\#25](https://github.com/dev-sec/chef-ssh-hardening/issues/25)
- update ssh service on changes [\#24](https://github.com/dev-sec/chef-ssh-hardening/issues/24)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*