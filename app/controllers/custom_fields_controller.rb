class CustomFieldsController < ApplicationController
  before_filter :authentication
  before_filter do
    @html_title = "Campos Personalizados em RD Custom Fields"
  end

  def index
    @custom_fields = current_user.custom_fields
  end

  def new
    @custom_field = current_user.custom_fields.new
  end

  def create
    @custom_field = current_user.custom_fields.new
    @custom_field.name = params[:name]
    @custom_field.content_type = params[:content_type]
    @custom_field.combobox_options = params[:combobox_options]
    if @custom_field.save
      flash[:info] = %{Campo <b>#{@custom_field.name}</b> criado, <a href="#{edit_custom_field_path(@custom_field)}">clique para modificar</a>.}
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    redirect_to(action: :index) unless @custom_field = current_user.custom_fields.find_by_id(params[:id])
  end

  def update
    if @custom_field = current_user.custom_fields.find_by_id(params[:id])
      @custom_field.name = params[:name]
      @custom_field.content_type = params[:content_type]
      @custom_field.combobox_options = params[:combobox_options]
      if @custom_field.save
        flash[:info] = %{Campo <b>#{@custom_field.name}</b> alterado, <a href="#{edit_custom_field_path(@custom_field)}">clique para modificar</a>.}
      else
        render :edit
        return
      end
    end
    redirect_to custom_fields_path
  end

  def destroy
    if @custom_field = current_user.custom_fields.find_by_id(params[:id])
      flash[:info] = %{Campo <b>#{@custom_field.name}</b> excluído.} if @custom_field.destroy
    end
    redirect_to custom_fields_path
  end
end
