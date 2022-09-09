RSpec.describe GenerateCsvJob, type: :job do
  describe '#perform_async' do
    it 'gets enqueued' do
      user = create(:user)

      expect { GenerateCsvJob.perform_async(user.id) }.to change { GenerateCsvJob.jobs.size }.by(1)
    end
  end
end
