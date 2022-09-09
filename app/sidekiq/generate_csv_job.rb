require 'csv'

class GenerateCsvJob
  include Sidekiq::Job

  def perform(user_id)
    @user = User.find(user_id)
    @user.feed_exports.attach(
      io: StringIO.new(prepare_data),
      filename: "feed_#{DateTime.now.strftime('%d%m%y%H%M%S')}.csv",
      content_type: 'text/csv'
    )
  end

  private

  def prepare_data
    followees = @user.followees
    feeds = Post.where(user: followees).includes(:user)
    attributes = %w[id content created_at user_id]

    CSV.generate(headers: true) do |csv|
      csv << %w[id content created_at author email]

      feeds.find_each do |post|
        csv << post.attributes.values_at(*attributes).push(post.user.email)
      end
    end
  end
end
