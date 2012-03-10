require 'biosphere/ui'
require 'biosphere/config'
require 'biosphere/runtime'

module Biosphere
  class Bio
    attr_reader :config, :ui, :runtime

    def initialize
      # The following instances depend on each other in the correct order
      @runtime = Runtime.new
      @ui = UI.new :config => @config, :argv => ARGV
      @config = Config.new :runtime => @runtime, :ui => @ui
    end

  end
end
