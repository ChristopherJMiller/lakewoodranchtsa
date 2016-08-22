class DocumentsController < ApplicationController
  respond_to :html, :json

  def index
    @documents = Document.all
    respond_with @documents
  end

  def show
    @document = Document.find_by_id(params[:id])
    if @document
      redirect_to @document.link
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @document = Document.new
    respond_to :html
  end

  def edit
    @document = Document.find_by_id(params[:id])
    if @document
      respond_with @document
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
    if !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    document = Document.new(document_parameters_create)
    if document.save
      head status: :created, location: document_path(document)
    else
      render json: {error: document.errors}, status: :bad_request
    end
  end

  def update
    document = Document.find_by_id(params[:id])
    if !document
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    if document.update(document_parameters_update)
      head status: :ok
    else
      render json: {error: document.errors}, status: :bad_request
    end
  end

  def destroy
    document = Document.find_by_id(params[:id])
    if !document
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    Document.destroy(document.id)
    head status: :ok
  end

  private

  def document_parameters_create
    params.require(:document).permit(:title, :link)
  end

  def document_parameters_update
    params.require(:document).permit(:title, :link)
  end
end
