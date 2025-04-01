require 'active_storage/service/s3_service'

ActiveStorage::Service::S3Service.class_eval do
  def url(key, **_options)
    "#{ENV['AWS_FILES_DISTRIBUTION']}/#{key}"
  end
end
