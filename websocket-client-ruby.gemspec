Gem::Specification.new do |s|
  s.name = "websocket-client-ruby"
  s.version = "0.0.1"
  s.summary = "websocket client using celluloid-io"
  s.authors = [ "Jeremy Deininger" ]
  s.email = [ "jeremydeininger@gmail.com" ]
  s.executables = []
  s.bindir = "bin"
  s.files = Dir.glob("lib/**/*.rb") + \
    Dir.glob("test/**/*.rb")
  s.add_runtime_dependency("websocket-protocol")
  s.add_runtime_dependency("celluloid-io")
  s.add_development_dependency("pry")
end
