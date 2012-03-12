require 'biosphere/config/paths'
require 'biosphere/config/user'
require 'fileutils'

module Biosphere
  class Config

    def initialize(options={})
      @runtime = options[:runtime]
      @ui = options[:ui]
    end

    def paths
      Paths.new
    end

    def user
      User.new
    end

    def [](key)
      path = File.join(paths.config, key.to_s)
      return File.read(path).chomp if File.exists?(path) && File.readable?(path)
      nil
    end

    def []=(key, value)
      ensure_config_path
      path = File.join(paths.config, key.to_s)
      if value
        if runtime.privileged? && !File.exists?(path)
          # We can write to an existing file as root without changing it's permissions.
          # But we cannot create a file being root without messing up the permissions. So let's drop down to the biosphere user for this.
          system("sudo -u #{user.name} touch #{path}") || raise("Could not touch file #{path} for user #{user.name}")
        end
        ui.debug "Saving config file #{path.inspect} with value #{value.inspect} to disk..."
        File.open(path, 'w') { |file| file.write(value) }
      elsif File.exists?(path)
        ui.debug "Removing config file #{path.inspect}..."
        File.delete(path)
      end
    end

    protected

    def ensure_config_path
      unless File.directory?(paths.config)
        if runtime.privileged?
          system("sudo -u #{user.name} mkdir -p #{paths.config}") || raise("Could not create directory #{paths.config} for user #{user.name}")
        else
          FileUtils.mkdir_p(paths.config)
        end
      end
    end

    def runtime
      @runtime
    end

    def ui
      @ui
    end

  end
end