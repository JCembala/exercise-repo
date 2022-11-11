require 'csv'

module Admin
  class ImportsController < BaseController
    def index
      authorize [:admin, User]
      @imports = ImportDecorator.decorate_collection(Import.all)
    end

    def new
      authorize [:admin, User]
      @import = Import.new
    end

    def create
      @import = Import.new
      import_users
    rescue Patterns::Form::Invalid => e
      @import.failure(e)
      flash.now[:alert] = t('import.failure')
      render :new, status: :unprocessable_entity
    else
      @import.success
      redirect_to admin_imports_path, notice: t('import.success')
    ensure
      @import.save
    end

    private

    def import_users
      ActiveRecord::Base.transaction do
        CSV.foreach(params[:import].tempfile, headers: true) do |row|
          form = UserForm.new(User.new, row.to_h.merge(password: SecureRandom.hex(36)))
          raise Patterns::Form::Invalid, form.errors.full_messages.join(', ') unless form.save
        end
      end
    end
  end
end
