require 'active_storage/service/s3_service'
require 'active_storage/service'

module ActiveStorage
  class Service
    class S3Service < ActiveStorage::Service
      def url(key, **_options)
        "#{ENV['AWS_FILES_DISTRIBUTION']}/#{key}"
      end
    end
  end
end
