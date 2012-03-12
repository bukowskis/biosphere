require 'biosphere/ui'
require 'biosphere/config'
require 'biosphere/runtime'
require 'biosphere/sphere'
require 'fileutils'

module Biosphere
  class Bio
    attr_reader :config, :ui, :runtime

    def initialize
      # The following instances depend on each other in the correct order
      @runtime = Runtime.new
      @ui = UI.new :config => @config, :argv => ARGV
      @config = Config.new :runtime => @runtime, :ui => @ui
    end

    def spheres
      spheres = Dir.glob(File.join(config.paths.spheres, '*')).map { |path| sphere(File.basename(path)) }.compact
    end

    def sphere(name)
      result = Sphere.new(name, :bio => self)
      result.valid? ? result : nil
    end

    def ensure_directory(path)
      path = File.expand_path(path)
      unless File.directory?(path)
        if runtime.privileged?
          system("sudo -u #{config.user.name} mkdir -p #{config.paths.config}") || raise("Could not create directory #{path} for user #{config.user.name}")
        else
          FileUtils.mkdir_p(path)
        end
      end
    end

    def ensure_file(path)
      path = File.expand_path(path)
      ensure_directory(File.dirname(path))
      unless File.exists?(path)
        if runtime.privileged?
          system("sudo -u #{config.user.name} touch #{path}") || raise("Could not touch file #{path} for user #{config.user.name}")
        else
          FileUtils.touch(path)
        end
      end
    end

  end
end
