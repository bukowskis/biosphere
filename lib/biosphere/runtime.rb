module Biosphere
  class Runtime

    def whoami
      `whoami`.strip
    end

    def privileged?
      Process.uid == 0
    end

    def unprivileged?
      !privileged?
    end

    def bio_executable
      File.expand_path('../../bin/bio', File.dirname(__FILE__))
    end

  end
end
