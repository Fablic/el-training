require 'rails_helper'
require 'rake'
require './lib/middlewares/maintenance'

# テスト用アプリケーション
class TestApp
  def call(_env)
    [200, { 'Content-Type' => 'text/html' }, ['Hello World!']]
  end
end

RSpec.describe Maintenance do
  include Rack::Test::Methods

  let(:test_app) { TestApp.new }
  let(:app) { Maintenance.new(test_app) }

  context 'maintenance.ymlがない場合' do
    describe 'GET /' do
      it 'リクエストが成功すること' do
        get '/'
        expect(last_response.status).to eq 200
      end
      it 'TestAppの内容を返すこと' do
        get '/'
        expect(last_response.body).to eq 'Hello World!'
      end
    end
  end

  context 'maintenance.ymlがある場合' do
    before(:all) do
      @rake = Rake::Application.new
      Rake.application = @rake
      Rake.application.rake_require 'tasks/maintenance_mode'
      Rake::Task.define_task(:environment)
      @rake['maintenance_mode:start'].invoke
    end

    after(:all) do
      @rake['maintenance_mode:end'].invoke
    end

    it 'リクエストが成功すること' do
      get '/'
      expect(last_response.status).to eq 503
    end

    it 'Maintenanceの内容を返すこと' do
      get '/'
      expect(last_response.body).to include 'Sorry, this service is temporarily unavailable.'
    end
  end
end
