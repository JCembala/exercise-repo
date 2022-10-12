RSpec.describe GenerateCsvJob, type: :job do
  describe '#perform' do
    it 'generates feed export' do
      user = create(:user)
      followee_1 = create(:user)
      followee_2 = create(:user)
      Follow.create(follower: user, followed: followee_1)
      Follow.create(follower: user, followed: followee_2)
      post_1 = create(:post, user: followee_1)
      post_2 = create(:post, user: followee_2)
      post_3 = create(:post)

      GenerateCsvJob.new.perform(user.id)

      export_data = user.feed_exports.first.download
      expect(user.feed_exports.count).to eq(1)
      expect(export_data).to include("id,content,created_at,author,email\n")
      expect(export_data).to include("#{post_1.id},#{post_1.content},#{post_1.created_at},#{post_1.user.id},#{post_1.user.email}")
      expect(export_data).to include("#{post_2.id},#{post_2.content},#{post_2.created_at},#{post_2.user.id},#{post_2.user.email}")
      expect(export_data).not_to include("#{post_3.id},#{post_3.content},#{post_3.created_at},#{post_3.user.id},#{post_3.user.email}")
    end
  end
end
