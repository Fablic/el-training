require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    before do
      expected = FactoryBot.create_list(:task, 10)
    end

    it 'should return all Tasks' do
      get '/tasks.json'

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret.count).to eq Task.count
      expect(ret.map { |t| t['name'] }).to eq Task.all.map { |t| t.name }
    end
  end

  describe 'GET /task/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should return indicated Task' do
      get "/tasks/#{@task.id}.json"

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret['name']).to eq @task.name
      expect(ret['description']).to eq @task.description
    end

    it 'should return 404 when the Task is inexistent' do
      get '/tasks/0.json'
      expect(response.status).to eq 404
    end
  end

  describe 'POST /tasks.json' do
    before do
      @task = FactoryBot.attributes_for(:task)
    end

    it 'should create new Task' do
      post '/tasks.json',
        params: {
          task: @task
        }

      ret = JSON.parse(response.body)
      expect(response.status).to eq 201
      expect(ret['name']).to eq @task[:name]
    end

    it "shouldn't create new Task without name" do
      post '/tasks.json',
        params: {
          task: @task.update({name: nil})
        }

      expect(response.status).to eq 422
    end

    it "shouldn't create new Task with blank name" do
      post '/tasks.json',
        params: {
          task: @task.update({name: ''})
        }

      expect(response.status).to eq 422
    end
  end

  describe 'PUT /tasks/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should update the Task' do
      new_name = 'new name'

      put "/tasks/#{@task.id}.json",
        params: { task: @task.attributes.update({name: new_name})}

      ret = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(ret['name']).to eq new_name

      @task.reload
      expect(@task.name).to eq new_name
    end

    it "shouldn't update the Task without name" do
      new_name = 'new name'

      put "/tasks/#{@task.id}.json",
        params: { task: @task.attributes.update({name: nil})}

      ret = JSON.parse(response.body)
      expect(response.status).to eq 422
    end

    it "shouldn't update the Task with blank name" do
      new_name = 'new name'

      put "/tasks/#{@task.id}.json",
        params: { task: @task.attributes.update({name: ''})}

      ret = JSON.parse(response.body)
      expect(response.status).to eq 422
    end
  end

  describe 'DELETE /tasks/ID.json' do
    before do
      @task = FactoryBot.create(:task)
    end

    it 'should delete the Task' do
      delete "/tasks/#{@task.id}.json"

      expect(response.status).to eq 204
      expect(Task.where(id: @task.id).count).to eq 0
    end

    it 'shouldnt delete nonexistent Task' do
      delete "/tasks/0.json"

      expect(response.status).to eq 422
    end
  end
end
