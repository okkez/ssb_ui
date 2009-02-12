class StocksController < ApplicationController
  layout 'application', :except => [:books]

  def index
    redirect_to :action => 'list'
  end

  def list
    respond_to do |format|
      format.html
    end
  end

  def books
    @state = params[:state]
    @book = Book.find_stocks_by_user_and_state({ :user_id_type => 'name',
                                                 :user_id => SsbConfig.user,
                                                 :state => @state },
                                               { :include_books => true })
    @stocks = @book.stocks
    respond_to do |format|
      format.html
    end
  end

  def update
    old_state = params[:old_state]
    new_state = params[:new_state]
    asin = params[:asin]
    response = Book.update_a(:asin   => asin,
                             :date   => Date.today.strftime('%Y-%m-%d'),
                             :state  => new_state,
                             :public => true)
    logger.debug response.inspect.decode_js
    if response.success
      flash[:notice] = response.message.decode_js
    else
      flash[:error] = response.message.decode_js
    end
    redirect_to :action => 'list'
  end
end
