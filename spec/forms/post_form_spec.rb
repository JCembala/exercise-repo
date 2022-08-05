RSpec.describe PostForm do
  describe '#save' do
    context 'when adding new post by form' do
      it 'persists post in database' do
        user = create(:user)
        post = Post.new
        form = PostForm.new(
          post,
          title: 'Example Post Title',
          content: 'Example Post Content',
          user_id: user.id
        )

        result = form.save

        expect(result).to be true
        expect(post).to be_persisted
        expect(post).to have_attributes(
          title: 'Example Post Title',
          content: 'Example Post Content',
          user_id: user.id
        )
      end
    end

    context 'when modifying existing post data' do
      it 'updates existing post except its user_id' do
        user = create(:user)
        another_user = create(:user)
        post = create(
          :post,
          title: 'My new post title',
          content: 'My new post content',
          user_id: user.id
        )
        form = PostForm.new(
          post,
          title: 'My updated post title',
          content: 'My updated post content',
          user_id: another_user.id
        )

        result = form.save

        expect(result).to be true
        expect(post).to be_persisted
        expect(post).to have_attributes(
          title: 'My updated post title',
          content: 'My updated post content',
          user_id: user.id
        )
      end
    end

    context 'when content length excess max length of 160' do
      it 'does not persist post in database' do
        user = create(:user)
        post = Post.new
        form = PostForm.new(
          post,
          title: 'Example Post Title',
          content: 'Example Post Content Example Post Content Example Post Content
          Example Post Content Example Post Content Example Post Content Example Post Content
          Example Post Content Example Post Content Example Post Content Example Post Content',
          user_id: user.id
        )

        result = form.save

        expect(result).to be false
        expect(post).not_to be_persisted
        expect(form.errors.full_messages).to eq ['Content is too long (maximum is 160 characters)']
      end
    end
  end
end
