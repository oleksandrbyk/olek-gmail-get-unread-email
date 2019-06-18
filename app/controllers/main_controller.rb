class MainController < ApplicationController
  def index
  end

  def get_unread_email
    result = Email.process
    respond_to do |format|
      format.json do
        render json: { result: result }
      end
      format.html do
      end
    end
  end
end
