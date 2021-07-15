class Maintenance
  def initialize(app)
    @app = app
  end

  def call(env)
    if File.exist?('./tmp/maintenance.yml')
      [503, { 'Content-Type' => 'text/html' }, ['<p>Sorry, this service is temporarily unavailable.</p>']]
    else
      @app.call(env)
    end
  end
end
