class ChatAction < Cramp::Websocket
  on_finish :handle_leave
  on_data :received_data

  def received_data(data)
    message = parse_json(data)
    case message[:action]
    when 'join'
      handle_join(message)
    when 'message'
      handle_message(message)
    end
  end

  def handle_join(message)
    @user = message[:user]

    config = { 
      :server => "irc.freenode.net",
      :port => 6667,
      :nickname => @user,
      :realname => @user,
      :username => @user,
      :channels => ["#cramp"]
    }

    message_handler = Proc.new {|event| render encode_json(:message => event.message, :user => event.from, :action => 'message') }
    config[:handlers] = {'privmsg' => message_handler}

    Thread.new { @irc = EM.connect(config[:server], config[:port], IRC::Connection, :config => config) }.join
  end

  def handle_leave
    return unless @irc

    @irc.quit('Goodbye!')
    @irc.close_connection
  end

  def handle_message(message)
    return unless @irc

    @irc.send_message(@irc.channels[0], message[:message])
    render encode_json(:message => message[:message], :user => @user, :action => 'message')
  end

  protected

  def encode_json(payload)
    Yajl::Encoder.encode(payload)
  end

  def parse_json(payload)
    Yajl::Parser.parse(payload, :symbolize_keys => true)
  end

end
