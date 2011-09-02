require './application'
Snoop::Application.initialize!

# Development middlewares
if Snoop::Application.env == 'development'
  use AsyncRack::CommonLogger

  # Enable code reloading on every request
  use Rack::Reloader, 0

  # Serve assets from /public
  use Rack::Static, :urls => ["/javascripts"], :root => Snoop::Application.root(:public)
end

# bundle exec rainbows -c rainbows.conf -E deployment config.ru
run Snoop::Application.routes
