class HomeAction < Cramp::Action
  @@template = ERB.new(File.read(Snoop::Application.root('app/views/index.erb')))

  def start
    render @@template.result(binding)
    finish
  end
end
