def require_all(path)
  Dir.glob(path) { |f| require f }
end

if __FILE__ == $0
  $LOAD_PATH.unshift('lib', 'test')

  require_all('./lib/**/*.rb')
  require_all('./test/**/*_test.rb')
end
