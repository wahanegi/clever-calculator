module ActiveStorage
  class Service
    class S3Service
      def url(key, **)
        "#{ENV['AWS_FILES_DISTRIBUTION']}/#{key}"
      end
    end
  end
end
