class Admin::RequestsController<ApplicationController
  load_and_authorize_resource
  before_action :load_request, only: [:destroy, :update]

  def index
    @requests = Request.all.order(updated_at: :desc).paginate page: params[:page]
  end

  def destroy
    if @request.destroy
      flash[:success] = t "request.destroyed"
    else
      flash[:danger] = t "request.not_destroyed"
    end
    redirect_to admin_requests_path
  end

  def update
    @request.is_approved = !@request.is_approved
    if @request.save
        flash[:success] = t "request.editted"
    else
        flash[:danger] = t"request.not_editted"
    end
    redirect_to admin_requests_path
  end

  private
  def load_request
    @request = Request.find_by id: params[:id]
    if @request.nil?
      flash[:danger]= t "request.not_found"
      redirect_to admin_requests_path
    end
  end
end
