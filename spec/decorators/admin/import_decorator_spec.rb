require 'rails_helper'

RSpec.describe Admin::ImportDecorator do
  describe '.date' do
    it 'returns the date in the correct format' do
      import = Import.new(created_at: DateTime.new(2022, 12, 1))

      decorator = Admin::ImportDecorator.decorate(import)

      expect(decorator.date).to eq('01/12/2022')
    end
  end
end
