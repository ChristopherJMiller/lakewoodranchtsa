# Controller for site wide documents
class DocumentsController < ApplicationController
  respond_to :html, :json

  add_breadcrumb 'Documents', :documents_path

  def index
    @documents = Document.all
    respond_with @documents
  end

  def show
    @document = Document.find_by(id: params[:id])
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
    add_breadcrumb 'New Document', new_document_path
    respond_to :html
  end

  def edit
    @document = Document.find_by(id: params[:id])
    if @document
      add_breadcrumb 'Edit ' + @document.title, edit_document_path(@document)
      respond_with @document
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless User.find_by(id: session[:user_id]).admin?
    document = Document.new(document_parameters_create)
    if document.save
      head status: :created, location: document_path(document)
    else
      render json: {error: document.errors}, status: :bad_request
    end
  end

  def update
    document = Document.find_by(id: params[:id])
    return head status: :not_found unless document
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    if document.update(document_parameters_update)
      head status: :ok
    else
      render json: {error: document.errors}, status: :bad_request
    end
  end

  def destroy
    document = Document.find_by(id: params[:id])
    return head status: :not_found unless document
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
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
