require 'biosphere/config/paths'

module Biosphere
  class Config
    class Paths

      # BASICS

      def home
        File.expand_path(ENV['HOME'])
      end

      def biosphere
        File.join(home, '.biosphere')
      end

      def config
        File.join(biosphere, 'config')
      end

      # SPHERE-RELATED

      def spheres
        File.join(biosphere, 'spheres')
      end

      def active_bash_profile
        File.join(active, 'bash_profile')
      end

      # SYSTEM

      def bash_profiles
        files = %w{ .zshenv .bash_profile }
        paths = files.map { |file| File.join(home, file) }
        paths.select { |path| File.exists?(path) }
      end

      def ssh_config
        File.join(ssh, 'config')
      end

      def known_hosts
        File.join(ssh, 'known_hosts')
      end

      def hosts
        '/etc/hosts'
      end

      private

      def ssh
        File.join(home, '.ssh')
      end

      def active
        File.join(biosphere, 'active')
      end

    end
  end
end