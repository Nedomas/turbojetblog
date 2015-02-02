class UploadsController < ApplicationController
  def propose
  end

  def upload
    uploader = PostUploader.new
    uploader.store!(params[:post])
  end
end
