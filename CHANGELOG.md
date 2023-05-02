# Changelog

## [v2.9.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.9.0) (2019-11-21)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.8.0...v2.9.0)

**Merged pull requests:**

- CentOS 8: proper selinux package naming [\#223](https://github.com/dev-sec/chef-ssh-hardening/pull/223) ([artem-sidorenko](https://github.com/artem-sidorenko))
- CI: enable testing on centos-8 [\#222](https://github.com/dev-sec/chef-ssh-hardening/pull/222) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Allow to specify an alternate AuthorizedKeysFile inside the Match block [\#214](https://github.com/dev-sec/chef-ssh-hardening/pull/214) ([dud225](https://github.com/dud225))

## [v2.8.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.8.0) (2019-07-17)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.7.0...v2.8.0)

**Merged pull requests:**

- Support of custom match configuration blocks [\#221](https://github.com/dev-sec/chef-ssh-hardening/pull/221) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Enable CI testing of Debian 10 [\#220](https://github.com/dev-sec/chef-ssh-hardening/pull/220) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Updating supported fedora versions and include Fedora 30 [\#219](https://github.com/dev-sec/chef-ssh-hardening/pull/219) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Removal of Ubuntu 14.04 because of EOL [\#218](https://github.com/dev-sec/chef-ssh-hardening/pull/218) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Switching testing to chef 14&15 [\#217](https://github.com/dev-sec/chef-ssh-hardening/pull/217) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Tests: update of gems [\#213](https://github.com/dev-sec/chef-ssh-hardening/pull/213) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Tests: try to use SoloRunner instead of ServerRunner [\#212](https://github.com/dev-sec/chef-ssh-hardening/pull/212) ([artem-sidorenko](https://github.com/artem-sidorenko))

## [v2.7.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.7.0) (2018-11-21)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.6.0...v2.7.0)

**Merged pull requests:**

- permit\_tunnel attribute - allow tun device forwarding [\#211](https://github.com/dev-sec/chef-ssh-hardening/pull/211) ([bobchaos](https://github.com/bobchaos))
- Update the CI settings [\#207](https://github.com/dev-sec/chef-ssh-hardening/pull/207) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Update issue templates [\#206](https://github.com/dev-sec/chef-ssh-hardening/pull/206) ([rndmh3ro](https://github.com/rndmh3ro))

## [v2.6.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.6.0) (2018-10-19)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.5.0...v2.6.0)

**Closed issues:**

- Removal of deprecated options [\#202](https://github.com/dev-sec/chef-ssh-hardening/issues/202)

**Merged pull requests:**

- Update of badges in README [\#205](https://github.com/dev-sec/chef-ssh-hardening/pull/205) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Removal of deprecated options for newer openssh versions [\#203](https://github.com/dev-sec/chef-ssh-hardening/pull/203) ([artem-sidorenko](https://github.com/artem-sidorenko))

## [v2.5.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.5.0) (2018-10-10)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.4.0...v2.5.0)

**Closed issues:**

- Change log level for SFTP Subsystem [\#199](https://github.com/dev-sec/chef-ssh-hardening/issues/199)

**Merged pull requests:**

- CI fix: pin cucumber 3 [\#201](https://github.com/dev-sec/chef-ssh-hardening/pull/201) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Add attribute for sftp subsystem logging [\#200](https://github.com/dev-sec/chef-ssh-hardening/pull/200) ([rediculum](https://github.com/rediculum))

## [v2.4.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.4.0) (2018-08-01)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.3.1...v2.4.0)

**Closed issues:**

- Errors on Ubuntu 18.04 [\#195](https://github.com/dev-sec/chef-ssh-hardening/issues/195)

**Merged pull requests:**

- Avoid some deprecated options for OpenSSH \>=7.6 [\#198](https://github.com/dev-sec/chef-ssh-hardening/pull/198) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Update of tests and supported distros and chef versions [\#197](https://github.com/dev-sec/chef-ssh-hardening/pull/197) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Update of CI and test environment [\#196](https://github.com/dev-sec/chef-ssh-hardening/pull/196) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Make ForwardAgent configurable for Client Configuration [\#193](https://github.com/dev-sec/chef-ssh-hardening/pull/193) ([kabakakao](https://github.com/kabakakao))
- minor update to the template [\#192](https://github.com/dev-sec/chef-ssh-hardening/pull/192) ([crashdummymch](https://github.com/crashdummymch))
- amazonlinux support [\#188](https://github.com/dev-sec/chef-ssh-hardening/pull/188) ([chris-rock](https://github.com/chris-rock))

## [v2.3.1](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.3.1) (2018-02-13)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.3.0...v2.3.1)

**Merged pull requests:**

- Modified the client\_alive\_interval default to 300 [\#187](https://github.com/dev-sec/chef-ssh-hardening/pull/187) ([iennae](https://github.com/iennae))

## [v2.3.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.3.0) (2017-12-19)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.2.1...v2.3.0)

**Closed issues:**

- remove ripemd from MAC list [\#185](https://github.com/dev-sec/chef-ssh-hardening/issues/185)
- allowtcpforwarding with sftp enabled is declared twice [\#182](https://github.com/dev-sec/chef-ssh-hardening/issues/182)

**Merged pull requests:**

- remove ripemd from MAC list [\#186](https://github.com/dev-sec/chef-ssh-hardening/pull/186) ([atomic111](https://github.com/atomic111))
- Allow password authentication for sftp [\#184](https://github.com/dev-sec/chef-ssh-hardening/pull/184) ([avanier](https://github.com/avanier))
- Fix Extra Configuration [\#183](https://github.com/dev-sec/chef-ssh-hardening/pull/183) ([bdwyertech](https://github.com/bdwyertech))

## [v2.2.1](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.2.1) (2017-08-22)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.2.0...v2.2.1)

**Closed issues:**

- The cookbooks fails on Amazon Linux. [\#180](https://github.com/dev-sec/chef-ssh-hardening/issues/180)

**Merged pull requests:**

- Fix to Issue \#180. Cookbook fails on Amazon Linux [\#181](https://github.com/dev-sec/chef-ssh-hardening/pull/181) ([jonasduarte](https://github.com/jonasduarte))

## [v2.2.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.2.0) (2017-06-18)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.1.0...v2.2.0)

**Closed issues:**

- Issues on OpenSuse Leap 42.2 [\#177](https://github.com/dev-sec/chef-ssh-hardening/issues/177)
- Chef 13 support [\#174](https://github.com/dev-sec/chef-ssh-hardening/issues/174)

**Merged pull requests:**

- Running rubocop in the 2.1 mode [\#179](https://github.com/dev-sec/chef-ssh-hardening/pull/179) ([artem-sidorenko](https://github.com/artem-sidorenko))
- CI: update to ruby 2.4.1 and gem update [\#178](https://github.com/dev-sec/chef-ssh-hardening/pull/178) ([artem-sidorenko](https://github.com/artem-sidorenko))
- CI, Harmonization of tests, Testing of Chef 13 and Chef 12 [\#176](https://github.com/dev-sec/chef-ssh-hardening/pull/176) ([artem-sidorenko](https://github.com/artem-sidorenko))
- CI: removal of EOL distros from testing and support [\#175](https://github.com/dev-sec/chef-ssh-hardening/pull/175) ([artem-sidorenko](https://github.com/artem-sidorenko))

## [v2.1.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.1.0) (2017-04-19)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Suse support missing in metadata [\#170](https://github.com/dev-sec/chef-ssh-hardening/issues/170)

**Merged pull requests:**

- Add Support for Extra Configuration Options [\#173](https://github.com/dev-sec/chef-ssh-hardening/pull/173) ([bdwyertech](https://github.com/bdwyertech))
- Authorized keys custom path [\#172](https://github.com/dev-sec/chef-ssh-hardening/pull/172) ([lubomir-kacalek](https://github.com/lubomir-kacalek))
- Add suse to the supported list in metadata [\#171](https://github.com/dev-sec/chef-ssh-hardening/pull/171) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Removal of apt/yum cookbooks from tests [\#169](https://github.com/dev-sec/chef-ssh-hardening/pull/169) ([artem-sidorenko](https://github.com/artem-sidorenko))

## [v2.0.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v2.0.0) (2017-02-06)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.3.0...v2.0.0)

**Implemented enhancements:**

- Send and Accept locale environment variables [\#167](https://github.com/dev-sec/chef-ssh-hardening/pull/167) ([mikemoate](https://github.com/mikemoate))
- Removal of DSA key from defaults [\#161](https://github.com/dev-sec/chef-ssh-hardening/pull/161) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Allow log level configuration of sshd [\#159](https://github.com/dev-sec/chef-ssh-hardening/pull/159) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Split the attributes to the client and server areas [\#150](https://github.com/dev-sec/chef-ssh-hardening/pull/150) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Attribute namespace \['ssh-hardening'\] added [\#144](https://github.com/dev-sec/chef-ssh-hardening/pull/144) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Add node attributes to override KEX, MAC and cipher values [\#141](https://github.com/dev-sec/chef-ssh-hardening/pull/141) ([bazbremner](https://github.com/bazbremner))
- Use different algorithms depending on the ssh version [\#166](https://github.com/dev-sec/chef-ssh-hardening/pull/166) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Avoid small primes for DH and allow rebuild of DH primes [\#163](https://github.com/dev-sec/chef-ssh-hardening/pull/163) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Switch UsePAM default to yes [\#157](https://github.com/dev-sec/chef-ssh-hardening/pull/157) ([artem-sidorenko](https://github.com/artem-sidorenko))

**Fixed bugs:**

- IPv6 is not working still if its enabled  [\#140](https://github.com/dev-sec/chef-ssh-hardening/issues/140)

**Closed issues:**

- Possibly missing locale handling [\#160](https://github.com/dev-sec/chef-ssh-hardening/issues/160)
- Verify the current crypto settings [\#162](https://github.com/dev-sec/chef-ssh-hardening/issues/162)
- Error message about DSA key on RHEL 7 [\#158](https://github.com/dev-sec/chef-ssh-hardening/issues/158)
- Attributes should be in the own namespace ssh-hardening [\#142](https://github.com/dev-sec/chef-ssh-hardening/issues/142)
- Move entire crypto parameter configuration in tests to the centralized place [\#137](https://github.com/dev-sec/chef-ssh-hardening/issues/137)
- Move UsePrivilegeSeparation.get to the new library [\#136](https://github.com/dev-sec/chef-ssh-hardening/issues/136)
- Release 2.0.0 [\#133](https://github.com/dev-sec/chef-ssh-hardening/issues/133)
- configure log level [\#117](https://github.com/dev-sec/chef-ssh-hardening/issues/117)
- UsePAM should probably default to yes on Red Hat Linux 7 [\#96](https://github.com/dev-sec/chef-ssh-hardening/issues/96)
- refactor library kex and cipher implementation [\#87](https://github.com/dev-sec/chef-ssh-hardening/issues/87)
- prohibit use of weak dh moduli [\#65](https://github.com/dev-sec/chef-ssh-hardening/issues/65)
- Harmonize API [\#53](https://github.com/dev-sec/chef-ssh-hardening/issues/53)
- SSH rootkey configuration is too open [\#16](https://github.com/dev-sec/chef-ssh-hardening/issues/16)

**Merged pull requests:**

- Add oracle bento boxes to vagrant testing [\#168](https://github.com/dev-sec/chef-ssh-hardening/pull/168) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Project data for changelog generator [\#164](https://github.com/dev-sec/chef-ssh-hardening/pull/164) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Improve the docs on the attribute overriding [\#156](https://github.com/dev-sec/chef-ssh-hardening/pull/156) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Tests for GH-131 and GH-132 [\#155](https://github.com/dev-sec/chef-ssh-hardening/pull/155) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Update attribute documentation in README [\#154](https://github.com/dev-sec/chef-ssh-hardening/pull/154) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Fix the broken master [\#153](https://github.com/dev-sec/chef-ssh-hardening/pull/153) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Fixing the broken links in docs [\#152](https://github.com/dev-sec/chef-ssh-hardening/pull/152) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Some tests for attributes of last merged PRs [\#151](https://github.com/dev-sec/chef-ssh-hardening/pull/151) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Get rid of chefspec/fauxhai warnings in the unit tests [\#149](https://github.com/dev-sec/chef-ssh-hardening/pull/149) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Bugfix: sshd listens on IPv6 interface if enabled [\#148](https://github.com/dev-sec/chef-ssh-hardening/pull/148) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Update and cleanup of Gemfile [\#147](https://github.com/dev-sec/chef-ssh-hardening/pull/147) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Cleanup of some unmaintained docs/files [\#146](https://github.com/dev-sec/chef-ssh-hardening/pull/146) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Removal of deprecated attributes [\#145](https://github.com/dev-sec/chef-ssh-hardening/pull/145) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Removal of deprecated authorized\_keys handling [\#143](https://github.com/dev-sec/chef-ssh-hardening/pull/143) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Refactoring of library to simplify the kex/cipher handling [\#134](https://github.com/dev-sec/chef-ssh-hardening/pull/134) ([artem-sidorenko](https://github.com/artem-sidorenko))

## [v1.3.0](https://github.com/dev-sec/chef-ssh-hardening/tree/v1.3.0) (2016-11-23)

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/v1.2.1...v1.3.0)

**Implemented enhancements:**

- Support for OpenSuse Leap, new enterprise distro of SUSE [\#128](https://github.com/dev-sec/chef-ssh-hardening/pull/128) ([artem-sidorenko](https://github.com/artem-sidorenko))
- Avoid duplicate resource names because of warnings [\#127](https://github.com/dev-sec/chef-ssh-hardening/pull/127) ([artem-sidorenko](https://github.com/artem-sidorenko))

**Closed issues:**

- Allow to configure ChallengeResponseAuthentication \(currently it's hardcoded to no\) [\#125](https://github.com/dev-sec/chef-ssh-hardening/issues/125)
- Make LoginGraceTime configurable  [\#116](https://github.com/dev-sec/chef-ssh-hardening/issues/116)
- Allow to configure MaxAuthTries [\#100](https://github.com/dev-sec/chef-ssh-hardening/issues/100)

**Merged pull requests:**

- Fixing metadata as supermarket API expects a float [\#139](https://github.com/dev-sec/chef-ssh-hardening/pull/139) ([artem-sidorenko](https://github.com/artem-sidorenko))
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

[Full Changelog](https://github.com/dev-sec/chef-ssh-hardening/compare/21e5369c17790bf3096ad51f3d67dc998c74b632...v1.0.2)

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



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
