module AdminsHelper
  def gravatar_for admin, size: Settings.img_size
    gravatar_id = Digest::MD5.hexdigest(admin.name)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: admin.name, class: "gravatar")
  end
end
