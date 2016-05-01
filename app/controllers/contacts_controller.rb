class ContactsController < ApplicationController
  before_filter :authentication
  before_filter do
    @html_title = "Contatos em RD Custom Fields"
  end

  def index
    @contacts = current_user.contacts
  end

  def new
    @contact = current_user.contacts.new
  end

  def create
    @contact = current_user.contacts.new
    @contact.email = params[:email]
    current_user.custom_fields.each do |custom_field|
      @contact.send "#{custom_field.slug}=", params[custom_field.slug]
    end
    if @contact.save
      flash[:info] = %{Contato <b>#{@contact.email}</b> cadastrado, <a href="#{edit_contact_path(@contact)}">clique para modificar</a>.}
      redirect_to contacts_path
    else
      render :new
    end
  end

  def edit
    redirect_to contacts_path unless @contact = current_user.contacts.find_by_id(params[:id])
  end

  def update
    if @contact = current_user.contacts.find_by_id(params[:id])
      @contact.email = params[:email]
      current_user.custom_fields.each do |custom_field|
        @contact.send "#{custom_field.slug}=", params[custom_field.slug]
      end
      if @contact.save
        flash[:info] = %{Contato <b>#{@contact.email}</b> alterado, <a href="#{edit_contact_path(@contact)}">clique para modificar</a>.}
        redirect_to contacts_path
      else
        render :edit
      end
    end
  end

  def destroy
    if @contact = current_user.contacts.find_by_id(params[:id])
      if @contact.destroy
        flash[:info] = "Contato <b>#{@contact.email}</b> excluído."
      end
    end
    redirect_to contacts_path
  end
end
