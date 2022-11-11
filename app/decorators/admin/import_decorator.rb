module Admin
  class ImportDecorator < Draper::Decorator
    delegate_all

    def date
      object.created_at.strftime('%d/%m/%Y')
    end
  end
end
