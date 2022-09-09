class User
  class FeedExportsController < BaseController
    def index
      @blobs = current_user.feed_exports.blobs.page params[:page]
    end

    def create
      GenerateCsvJob.perform_async(current_user.id)
      redirect_to user_feed_exports_path, notice: t('feed.export_enqueued')
    end
  end
end
