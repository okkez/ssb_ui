module StocksHelper

  def item(stock)
    result = ''
    result << link_to(h(stock.book.title.decode_js), stock.book.uri)
    result << '<br />'
    result << 'Update Status : '
    result << links_to_update_state(stock)
    result
  end

  def links_to_update_state(stock)
    hash ={
      :reading => %w[unread wish read],
      :unread => %w[reading wish read],
      :wish => %w[reading unread read],
      :read => %w[reading unread wish]
    }
    links = hash[stock.state.to_sym].map{|state|
      link_to(state, :action => 'update', :asin => stock.book.isbn10, :old_state => stock.state, :new_state => state)
    }
    links.join(' ')
  end

  def link_to_previous_page
    url = url_for(:action => 'books',
                  :state => @state,
                  :page => @pagination.current_page - 1)
    update_state_page_function('Prev', url)
  end

  def link_to_next_page
    url = url_for(:action => 'books',
                  :state => @state,
                  :page => @pagination.current_page + 1)
    update_state_page_function('Next', url)
  end

  def link_to_page(num)
    if @pagination.current_page == num
      num.to_s
    else
      url = url_for(:action => 'books',
                    :state => @state,
                    :page => num)
      update_state_page_function(num.to_s, url)
    end
  end

  def update_state_page_function(name, url)
    link_to_function(name, <<-JS)
$.post('#{url}',
       { authenticity_token: window._token },
       function(data, status){
         $('##{@state}').hide().html(data).fadeIn(600);
       }, 'html');
    JS
  end
end
