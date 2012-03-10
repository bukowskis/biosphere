module Biosphere
  class Config
    class User

      def name
        users = Dir.glob('/Users/*').map { |path| File.basename(path) }.reject { |user| user == 'Shared' }
        users.reject! { |name| !File.directory?("/Users/#{name}/.biosphere") }
        if users.size > 1
          raise "Sorry, I cannot (yet) handle multiple biosphere users. I found #{users.join(',')} in /Users.\nAs soon as it is needed, I will implement a configuration flag for this."
        else
          users.first
        end
      end

      def home
        "/Users/#{name}"
      end

    end
  end
end