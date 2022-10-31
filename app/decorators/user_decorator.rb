class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}".strip.presence || 'Anonymous'
  end
end
