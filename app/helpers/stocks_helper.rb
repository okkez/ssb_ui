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

end
