FactoryBot.define do
  factory :post do
    title { 'My title' }
    content { 'Valid content' }
    user
  end
end
