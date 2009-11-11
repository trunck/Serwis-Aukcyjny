class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  rescue_from Acl9::AccessDenied, :with => :deny_user_access

  access_control do
    deny :banned
    deny :not_activated
    allow :superuser
    allow :admin, :to => [:destroy], :if => :cant_destroy_admins
    allow :admin
    allow anonymous, :to => [:activate, :new, :create]
    allow :owner, :of => :user, :to => [:show, :edit, :update, :delete]
  end
  
  def cant_destroy_admins
    @u = User.find(params[:id])
    if(@u.id != current_user.id && (@u.has_role?(:admin) || @u.has_role?(:superuser)))
      flash[:notice] = "The user you are trying to delete is an admin or a superuser"
      return false
    end
    return true
  end
  #TODO zrób to jako parametr w pliku
  
  def new
    @user = User.new
    @interests = Interest.find(:all)
  end
  
  def deny_user_access
    @user =current_user 
    if @user == nil
      flash[:notice] = "Musisz się zalogować"
      redirect_to :root
      return
    end
    if @user.has_role?(:banned)
      flash[:notice] = "Twoje konto jest zablokowane"
      redirect_to :root
      return
    end
    if @user.has_role?(:not_activated)
      flash[:notice] = "Musisz zaktywować swoje konto"
      redirect_to :root 
      #TODO Tu ma się pojawić redirect do powiadomienia o tym, że trzeba zaktywować
      return
    end
    flash[:notice] = "Nie masz uprawnień do tej części serisu"
    redirect_to :root 
    #TODO Tu ma się pojawić redirect do powiadomienia o tym, że trzeba zaktywować
    return
  end
  
  def ban 
    u_id = params[:passed_id]
    
    @u = User.find(u_id) if u_id
    @u.ban if @u
    redirect_to "/users/index"
  end
  
  def unban
    user_id = params[:passed_id]
    @u = User.find(user_id) if user_id 
    @u.unban if @u
    redirect_to "/users/index"
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      #flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(:action =>'index')
  end
         
  def show
    id = params[:id] || @current_user.id
    @user = User.find(id) if :id 
  end
 
  def edit
   # allow :admin
   # allow :owner, :of => :user
   if(params[:id])
    @user = User.find(params[:id])
   else
      @user = @current_user
   end
  end
  
  def index
    page = params[:page] || 1
    @users = User.paginate :page => page, :order => 'login ASC'
    #User.find(:all, :order => "id")  
  end
  
  def activate  
    #postac urla wysyłanego użyszkodnikowi powinna być postaci 
    #www.adres.com/users/activate?[id]=<id_użyszkodnika>&[token]=<single_use_token_użytkownika>
    #UWAGA ! nawiasy kwadratowe wokół id i token są KONIECZNE !
      if(!params[:id])
        flash[:notice] = "Podany url aktywacyjny jest nieprawidłowy" 
        redirect_to :root
        
      else
        @user = User.find(params[:id])
          
        if(params[:token] == @user.perishable_token)
          @user.activated = true;
          @user.save
          flash[:notice] = "Konto zostało zaktywowane !"
          redirect_to :root
        else
          flash[:notice] = "Podany token aktywacyjny jest nieprawidłowy" 
          redirect_to :root
        end
      end
      
  end
  
  def generate_activate_url user
    return "http://" + request.env['HTTP_HOST'] + "/users/activate?[id]="+user.id.to_s() +"&[token]=" + user.single_access_token
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    params[:user][:login] = @user.login  # zapewnienie, żeby użyszkodnik nie zmienił sobie loginu
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
