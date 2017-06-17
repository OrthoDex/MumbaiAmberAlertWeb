class AvatarUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  version :standard do
    process :resize_to_fill => [200, 300, :north]
  end

  version :thumbnail do
    resize_to_fit(100, 100)
  end
end
