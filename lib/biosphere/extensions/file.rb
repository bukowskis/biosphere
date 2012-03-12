require 'digest/md5'

module Biosphere
  module Extensions
    module FileExtensions

      # Returns true if the target file was modified at all. false if not.
      # Raises an exception if the file could not be augmented as it should.
      #
      def augment(target, options={})
        raise "Cannot augment file #{target.inspect}, because it doesn't exist." unless exists?(target)
        raise "Cannot augment file #{target.inspect}, because of missing permissions." unless writable?(target)
        start_tag = options[:start_tag] || '### BIOSPHERE MANAGED START ###'
        end_tag = options[:end_tag] || '### BIOSPHERE MANAGED STOP ###'
        implode = !!options[:implode]
        augmentation_file = options[:augmentation_file]
        if augmentation_file && exists?(augmentation_file)
          raise "Cannot read augmentation_file #{augmentation_file.inspect}, because of missing permissions." unless readable?(augmentation_file)
          augmentation = read(augmentation_file)
        else
          augmentation = (options[:augmentation] || '').to_s
        end
        augmentation = implode ? '' : start_tag + "\n" + augmentation + "\n"+ end_tag
        current_content = read(target)
        current_digest = Digest::MD5::hexdigest(current_content)
        if current_content.include?(start_tag)
          new_content = current_content.gsub(/#{start_tag}(.*)#{end_tag}/m, augmentation)
        else
          new_content = "#{current_content}\n#{augmentation}\n"
        end
        open(target, 'w') { |f| f.write(new_content) }
        current_digest != Digest::MD5::hexdigest(read(target))
      end

    end
  end
end

class File
  extend Biosphere::Extensions::FileExtensions
end