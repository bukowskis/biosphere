require 'biosphere/extensions/file'

module Biosphere
  class Sphere
    attr_reader :bio, :path, :name
    attr_accessor :changed, :skipped

    def initialize(name, options={})
      @bio = options[:bio]
      @name = name.to_s.strip
      @path = File.join(@bio.config.paths.spheres, @name)
    end

    def valid?
      off? || File.directory?(path)
    end

    def activate
      self.changed, self.skipped = 0, 0
      sync_bash_profile
      sync_ssh_config
      sync_known_hosts
      sync_hosts
      summary
      if off?
        bio.config[:current_sphere] = nil
      else
        bio.config[:current_sphere] = name
      end
    end

    protected

    # INTERNAL METHODS

    def off?
      name == 'off'
    end

    def sync_bash_profile
      sync paths.active_bash_profile, File.join(augmentations_path, 'bash_profile')
    end

    def sync_ssh_config
      sync paths.ssh_config, File.join(augmentations_path, 'ssh_config')
    end

    def sync_known_hosts
      sync paths.known_hosts, File.join(augmentations_path, 'known_hosts')
    end

    def sync_hosts
      if File.writable?(paths.hosts)
        sync paths.hosts, File.join(augmentations_path, 'etc_hosts')
      else
        say 'Skipping'.red, paths.hosts
        self.skipped += 1
      end
    end

    def sync(target, source)
      bio.ensure_file(target)
      status = "No changes for".cyan
      if File.augment(target, :implode => off?, :augmentation_file => source)
        status = off? ? "Cleaned up".green : "Augmented".green
        self.changed += 1
      end
      say status, target
    end

    # USER INTERFACE

    def say(status, path)
      ui.info "  #{status.ljust(14)} #{path}"
    end

    def summary
      messages = []
      messages << "NOTE: ".bold.cyan + "Nothing changed, maybe need to run ".cyan + "bio update".bold.cyan + "?".cyan if changed == 0
      messages << "NOTE: ".bold.green + "Close all Termial windows for changes to take effect!".green if changed > 0
      messages << "NOTE: ".bold.yellow + "Run this command with sudo to process skipped files.".yellow if skipped > 0
      if messages.size > 0
        ui.separator
        ui.info messages.map { |message| "  #{message}" }
      end
    end

    # INTERNAL HELPERS

    def augmentations_path
      File.join(path, 'augmentations')
    end

    def ui
      bio.ui
    end

    def paths
      bio.config.paths
    end

  end
end
