module Biosphere
  class Config
    class Paths

      def biosphere
        File.join(ENV['HOME'], '.biosphere')
      end

      def config
        File.join(biosphere, 'config')
      end


      private



      def biosphere_cache_path
        File.join(biosphere_path, 'cache')
      end

      def biosphere_config_path
        File.join(biosphere_path, 'config')
      end

      def etc_hosts_file
        '/etc/hosts'
      end

      def ssh_path
        File.join(home_path, '.ssh')
      end

      def ssh_config_file
        File.join(ssh_path, 'config')
      end

      def ssh_known_hosts_file
        File.join(ssh_path, 'known_hosts')
      end

      def biosphere_spheres_path
        File.join(biosphere_path, 'spheres')
      end

    end
  end
end