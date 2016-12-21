class SignUpSheetsController < ApplicationController
  respond_to :html, :json

  add_breadcrumb "Sign Up Sheets", :sign_up_sheets_path

  def index
    @sign_up_sheets = SignUpSheet.all
    respond_with @sign_up_sheets
  end

  def show
    @sign_up_sheet = SignUpSheet.find_by_id(params[:id])
    if @sign_up_sheet
      add_breadcrumb @sign_up_sheet.name, sign_up_sheet_path(@sign_up_sheet)
      respond_with @sign_up_sheet
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @sign_up_sheet = SignUpSheet.new
    add_breadcrumb "New Sign Up Sheet", new_sign_up_sheet_path
    respond_to :html
  end

  def edit
    @sign_up_sheet = SignUpSheet.find_by_id(params[:id])
    if @sign_up_sheet
      add_breadcrumb "Edit " + @sign_up_sheet.name, edit_sign_up_sheet_path(@sign_up_sheet)
      respond_with @sign_up_sheet
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def report
    @sign_up_sheet = SignUpSheet.find_by_id(params[:sign_up_sheet_id])
    if @sign_up_sheet
      respond_with @sign_up_sheet
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).admin?
      head status: :forbidden and return
    end
    sign_up_sheet = SignUpSheet.new(sign_up_sheet_parameters_create)
    if sign_up_sheet.save
      head status: :created, location: sign_up_sheet_path(sign_up_sheet)
    else
      render json: {error: sign_up_sheet.errors}, status: :bad_request
    end
  end

  def update
    sign_up_sheet = SignUpSheet.find_by_id(params[:id])
    if !sign_up_sheet
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).admin?
      head status: :forbidden and return
    end
    if sign_up_sheet.update(sign_up_sheet_parameters_update)
      head status: :ok
    else
      render json: {error: sign_up_sheet.errors}, status: :bad_request
    end
  end

  def destroy
    sign_up_sheet = SignUpSheet.find_by_id(params[:id])
    if !sign_up_sheet
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).admin?
      head status: :forbidden and return
    end
    sign_up_sheet.destroy
    head status: :ok
  end

  private

  def sign_up_sheet_parameters_create
    params.require(:sign_up_sheet).permit(:name, :date)
  end

  def sign_up_sheet_parameters_update
    params.require(:sign_up_sheet).permit(:name, :date)
  end
end
