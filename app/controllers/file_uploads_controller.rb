class FileUploadsController < ApplicationController
  skip_after_action :verify_authorized, only: :destroy

  def destroy
    blob = ActiveStorage::Blob.find(params[:id])
    blob.attachments.each(&:purge_later) if blob.attachments.any?
    blob.purge_later
    
    head :ok
  end
end