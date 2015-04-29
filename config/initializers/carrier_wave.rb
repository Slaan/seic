if Rails.env.production?
	CarrierWave.configure do |config|
	  config.storage    = :aws
	  config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
	  config.aws_acl    = :public_read
	  AWS.config(:region => 'eu-central-1')
	  config.asset_host = 'https://s3.eu-central-1.amazonaws.com/seic-storage'
	  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

	  config.aws_credentials = {
		access_key_id:  ENV.fetch('AWS_ACCESS_KEY_ID'),
		secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
	  }
	end
end