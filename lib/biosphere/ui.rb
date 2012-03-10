require 'biosphere/extensions/string'

module Biosphere
  class UI
    attr_reader :debug_mode, :batch_mode

    def initialize(options={})
      argv = options[:argv] || []
      @debug_mode = argv.include?('--debug')
      @silent_mode = !@debug_mode && argv.include?('--silent')
      @batch_mode = !@silent_mode && argv.include?('--batch')
    end

    def batch(message)
      say(message, :batch) if batch_mode
    end

    def debug(message)
      say(message, :debug) if debug_mode
    end

    def separator
      say('') unless batch_mode
    end

    def info(message)
      say(message, :info) unless batch_mode
    end

    def error(message)
      say(message, :error) unless batch_mode
    end

    def pause
      read
    end

    def read(prefix='')
      raise "You cannot yet ask questions in batch mode." if batch_mode
      print prefix
      begin
        result = gets.chomp
      rescue Interrupt => exception
        puts
        puts
        puts 'Interrupted by user...'.red
        exit 989
      end
      if result.strip.empty?
        nil
      elsif result.strip == result.strip.to_i.to_s
        result.to_i
      else
        result.strip
      end
    end

    protected

    def say(message, mode=nil)
      prefix = case mode
      when :debug then 'DEBUG: '.blue
      when :info  then 'INFO : '
      when :error then 'ERROR: '.red
      when :batch then 'BATCH: '.cyan
      else             ''
      end

      message = "#{prefix} #{message}" if debug_mode
      output message
    end

    def output(message)
      puts message
    end

  end
end