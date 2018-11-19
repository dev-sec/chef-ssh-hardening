# encoding: utf-8

#
# Cookbook Name:: ssh-hardening
# Library:: devsec_ssh
#
# Copyright 2012, Dominik Richter
# Copyright 2014, Christoph Hartmann
# Copyright 2014, Deutsche Telekom AG
# Copyright 2016, Artem Sidorenko
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module DevSec
  # Class methods of this class can be called in order to
  # return different cryptographic configuration data. The calls
  # can be done based on the CRYPTO constant below. There is autodetection
  # of required ssh version. If ssh package can not be found, preconfigured OS
  # matrix is used.
  #
  # Syntax:
  #
  #   get_[client|server]_[kexs|macs|ciphers] (enable-weak-ciphers)
  #
  # Example:
  #
  #   DevSec::Ssh.get_server_macs(false)
  #   => 'hmac-ripemd160 hmac-sha1' # for openssh server version 5.3
  #
  class Ssh # rubocop:disable Metrics/ClassLength
    # Fallback ssh version for autodetection
    FALLBACK_SSH_VERSION ||= 5.9
    # Support types of ssh
    SSH_TYPES ||= %i[client server].freeze
    # Crypto configuration for different ssh parameters
    CRYPTO ||= {
      kexs: {
        5.3 => [],
        5.9 => %w[diffie-hellman-group-exchange-sha256],
        6.6 => %w[curve25519-sha256@libssh.org diffie-hellman-group-exchange-sha256],
        :weak => %w[diffie-hellman-group14-sha1 diffie-hellman-group-exchange-sha1 diffie-hellman-group1-sha1]
      },
      macs: {
        5.3 => %w[hmac-ripemd160 hmac-sha1],
        5.9 => %w[hmac-sha2-512 hmac-sha2-256 hmac-ripemd160],
        6.6 => %w[hmac-sha2-512-etm@openssh.com hmac-sha2-256-etm@openssh.com
                  umac-128-etm@openssh.com hmac-sha2-512 hmac-sha2-256],
        :weak => %w[hmac-sha1]
      },
      ciphers: {
        5.3 => %w[aes256-ctr aes192-ctr aes128-ctr],
        6.6 => %w[chacha20-poly1305@openssh.com aes256-gcm@openssh.com aes128-gcm@openssh.com
                  aes256-ctr aes192-ctr aes128-ctr],
        :weak => %w[aes256-cbc aes192-cbc aes128-cbc]
      }
    }.freeze
    # Privilege separation values
    PRIVILEGE_SEPARATION ||= {
      5.3 => 'yes',
      5.9 => 'sandbox'
    }.freeze
    # Hostkey algorithms
    # In the current implementation they are server specific so we need own data hash for it
    HOSTKEY_ALGORITHMS ||= {
      5.3 => %w[rsa],
      6.0 => %w[rsa ecdsa],
      6.6 => %w[rsa ecdsa ed25519]
    }.freeze

    class << self
      def get_server_privilege_separarion # rubocop:disable Style/AccessorMethodName
        Chef::Log.debug('Called get_server_privilege_separarion')
        found_ssh_version = find_ssh_version(get_ssh_server_version, PRIVILEGE_SEPARATION.keys)
        ret = PRIVILEGE_SEPARATION[found_ssh_version]
        Chef::Log.debug("Using configuration for ssh version #{found_ssh_version}, value: #{ret}")
        ret
      end

      def get_server_algorithms # rubocop:disable Style/AccessorMethodName
        Chef::Log.debug('Called get_server_algorithms')
        found_ssh_version = find_ssh_version(get_ssh_server_version, HOSTKEY_ALGORITHMS.keys)
        ret = HOSTKEY_ALGORITHMS[found_ssh_version]
        Chef::Log.debug("Using configuration for ssh version #{found_ssh_version}, value: #{ret}")
        ret
      end

      def get_client_macs(enable_weak = false)
        get_crypto_data(:macs, :client, enable_weak)
      end

      def get_server_macs(enable_weak = false)
        get_crypto_data(:macs, :server, enable_weak)
      end

      def get_client_ciphers(enable_weak = false)
        get_crypto_data(:ciphers, :client, enable_weak)
      end

      def get_server_ciphers(enable_weak = false)
        get_crypto_data(:ciphers, :server, enable_weak)
      end

      def get_client_kexs(enable_weak = false)
        get_crypto_data(:kexs, :client, enable_weak)
      end

      def get_server_kexs(enable_weak = false)
        get_crypto_data(:kexs, :server, enable_weak)
      end

      { client: 'sshclient',
        server: 'sshserver' }.each do |k, v|
        define_method("get_ssh_#{k}_version") do
          get_ssh_version(node['ssh-hardening'][v]['package'])
        end
      end

      # Verify values of permit_tunnel
      def validate_permit_tunnel(value)
        case value
        when true
          'yes'
        when false
          'no'
        when 'yes', 'no', 'point-to-point', 'ethernet'
          value
        else
          raise "Incorrect value for attribute node['ssh-hardening']['ssh']['server']['permit_tunnel']: must be boolean or a string as defined in the sshd_config man pages, you passed \"#{value}\""
        end
      end

      private

      # :nocov:
      def node
        Chef.node
      end
      # :nocov:

      # Return the crypto data for given crypto type and ssh type
      # crypto_type is a subkey of CRYPTO constant, e.g. :kex, :macs, :ciphers
      # ssh_type is :client or :server
      def get_crypto_data(crypto_type, ssh_type, enable_weak)
        Chef::Log.debug("Called get_crypto_data for crypto_type #{crypto_type} and ssh_type #{ssh_type}")
        ssh_version = send("get_ssh_#{ssh_type}_version")
        Chef::Log.debug("Detected ssh version #{ssh_version}")
        found_ssh_version = find_ssh_version(ssh_version, CRYPTO[crypto_type].keys)
        Chef::Log.debug("Using configuration for ssh version #{found_ssh_version}")
        crypto = []
        crypto += CRYPTO[crypto_type][found_ssh_version]
        # Sometimes we do not have a value, e.g. this feature is not supported
        # on the particilar ssh version. Return nil in such cases
        if crypto.empty?
          Chef::Log.debug("No value present for ssh version #{found_ssh_version}. Returning nil.")
          return nil
        end

        if enable_weak
          weak = CRYPTO[crypto_type][:weak]
          Chef::Log.info("Enabling weak #{crypto_type}: #{weak}")
          crypto += weak
        end

        Chef::Log.debug("get_crypto_data result for crypto_type #{crypto_type} and ssh_type #{ssh_type}: #{crypto}")

        crypto.uniq.join(',')
      end

      # Find the ssh version, matching to the next small
      # version in versions array
      def find_ssh_version(version, versions)
        found_ssh_version = nil
        versions.map do |v|
          next unless v.is_a?(Float) # skip everything what does not look like a version
          found_ssh_version = v if version >= v
        end

        raise "Unsupported ssh version #{version}" unless found_ssh_version

        found_ssh_version
      end

      def get_ssh_version(package)
        version = node['packages'][package]['version']
        # on debian we get the epoch in front of version number: 1:7.2p2-4ubuntu2.1
        version = version.split(':')[1] if node['platform_family'] == 'debian'
        Chef::Log.debug("Detected openssh version #{version} for package #{package}")
        version.to_f
      rescue NoMethodError
        # Detection via installed package failed, lets guess the installed version
        version = guess_ssh_version
        Chef::Log.debug("Failed to get the openssh version from installed package. Guessed version is #{version}")
        version
      end

      # Guess the version of ssh via OS matrix
      def guess_ssh_version # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
        family = node['platform_family']
        platform = node['platform']
        version = node['platform_version'].to_f

        case family
        when 'debian'
          case platform
          when 'ubuntu'
            return 6.6 if version >= 14.04
          when 'debian'
            return 6.6 if version >= 8
            return 6.0 if version >= 7
            return 5.3 if version <= 6
          end
        when 'rhel'
          return 6.6 if version >= 7
          return 5.3 if version >= 6
        when 'fedora'
          return 7.3 if version >= 25
          return 7.2 if version >= 24
        when 'suse'
          case platform
          when 'opensuse'
            return 6.6 if version >= 13.2
          when 'opensuseleap'
            return 7.2 if version >= 42.1
          end
        end
        Chef::Log.info("Unknown platform #{node['platform']} with version #{node['platform_version']} and family #{node['platform_family']}. Assuming ssh version #{FALLBACK_SSH_VERSION}")
        FALLBACK_SSH_VERSION
      end
    end
  end
end
