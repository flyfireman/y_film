require 'open-uri'
class Photo < ActiveRecord::Base
  belongs_to :director
  belongs_to :country
  belongs_to :user
  #……………………
  has_attached_file :image,
                      :default_url   => "/images/rails.png",
                      
                    #,
                      :styles => {
                                :thumb=> "100*100",
                                :gallery  => "150*150",
                                :avatar =>  "200*200"},
                                :withy => false
  #  使用Paperclip时遇到一个问题，在上传图片是一直显示图片临时文件not recognized by the 'identify' command，检查发现临时文件没有问题，网上资料说使用Paperclip.options[:command_path]变量可以解决，试过后无效。
  #
  #查看log看到有

  #	An error was received while processing: #<Paperclip::NotIdentifiedByImageMagickError

  #的提示信息，通过这个找到了解决方法，就是在has_attached_file后添加属性

  #	:whiny => false
  #
  #使用这个就不能删除图片了
  #validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ "image/gif", "image/png", "image/x-png", "image/jpeg", "image/pjpeg", "image/jpg"]
  #……………………
  #=============================其他代码=====================
  #=============================删除图片=====================
  def delete_image=(value)
    @delete_image = !value.to_i.zero?
  end

  def delete_image
    !!@delete_image
  end
  alias_method :delete_image?, :delete_image
  before_validation :clear_image

  def clear_image
    self.image = nil if delete_image? && !image.dirty?
  end
  #===============================其他代码===================
  #new attr
  attr_accessor :image_url
  before_validation :download_remote_image, :if => :image_url_provided?

  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => '地址不合法'

  private
  def image_url_provided?
    !self.image_url.blank?
  end

  def download_remote_image
    self.image = do_download_remote_image
    self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
