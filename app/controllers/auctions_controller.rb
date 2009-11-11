require "auctions_helper.rb"
class AuctionsController < ApplicationController
  include AuctionsHelper
  layout "application"
  access_control do
    #allow logged_in
    deny :banned
    deny :not_activated
    allow logged_in, :to => [:new, :create, :index]
    allow :admin
    allow anonymous, :to => [:show]
    allow :owner, :of => :auction, :to => [:show, :edit, :update]
  end
  
  def new
    @auction = Auction.new
    @auction.user = current_user
  #  @auction.auction_token = AuctionsHelper.random_string(20)
    auction_type = params[:auction_type] || "buy_now"
    if(auction_type == "buy_now")
      @auction.auctionable = BuyNowAuction.new
    else
      #TODO podstaw inne typy auctionable  
    end
    
    #TODO logika dodawania produktu !
  end

  def edit
    if(params[:id])
      @auction = Auction.find(params[:id])
    else
      flash[:notice] = "Error while passing auction ID"
      redirect_to :root
    end
  end

  def destroy
  end

  def index
  end

  def index_mine
  end

  def create
    @auction = Auction.new(params[:auction])
   # @auction.auction_token = params[:auction][:auction_token]
    @auction.user = current_user
    #puts current_user.id
    if @auction.save
      #flash[:notice] = "Account registered!"
      redirect_to :action=>"show", :id => @auction.id
      #redirect_back_or_default auctions_url
    else
      #flash[:notice] = "Nie udało się uworzyć aukcji"
      render :action => :new
      @auction.errors.clear
      #redirect_to :root
    end
    #TODO logika dodawania produktu !
  end

  def show
    @auction = Auction.find(params[:id])
  end

end