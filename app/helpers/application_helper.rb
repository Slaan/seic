module ApplicationHelper

  def thumbnail(model)
    (model.picture?) ? (image_tag model.picture.url) : (missing_img_thumb)
  end

  def missing_img_thumb
    image_tag 'https://s3.eu-central-1.amazonaws.com/seic-storage/public/images/missing_pic_thumb.png'
  end

end
