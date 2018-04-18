require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe TasksController, type: :controller do

  # Common Request Headers
  before(:each) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = "ja,en-US;q=0.9,en;q=0.8"
  end

  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {{
    title:'Test title',
    description:'Test description',
    status:1,
    priority:2,
    due_date:Date.today + 2.days,
    start_date:Date.today - 1.day,
    finished_date:Date.today
  }}

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:tasklist) {
    [
      valid_attributes.clone.merge!(title: '1111', created_at: Date.today - 1.day),
      valid_attributes.clone.merge!(title: '2222', created_at: Date.today - 5.days),
      valid_attributes.clone.merge!(title: '3333', created_at: Date.today - 2.days)
    ]
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TasksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    render_views

    before do
      for task in tasklist do
        Task.create! task
      end

      get :index, params: {}, session: valid_session
    end

    it "returns a success response" do
      expect(response).to be_success
    end

    it "should have 3 tasks" do
      expect(assigns(:tasks).length).to eq tasklist.length
    end

    it "tasks sould be ordered by created_at" do
      newest = nil
      for task in assigns(:tasks) do
        if newest then
          expect(task.created_at).to be <= newest.created_at
          newest = task
        end
      end
    end

    it "should have all tasks" do
      for task in tasklist do
        expect(response.body).to include(task[:title])
      end
    end

  end

  describe "GET #show" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get :show, params: {id: task.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get :edit, params: {id: task.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: {task: valid_attributes}, session: valid_session
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: {task: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Task.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {task: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{
        title:'New title',
        description:'New description',
        status:0,
        priority:1,
        due_date:Date.today,
        start_date:Date.today,
        finished_date:Date.today
      }}

      it "updates the requested task" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: new_attributes}, session: valid_session
        task.reload
        # skip("Add assertions for updated state")
      end

      it "redirects to the task" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: valid_attributes}, session: valid_session
        expect(response).to redirect_to(task)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete :destroy, params: {id: task.to_param}, session: valid_session
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = Task.create! valid_attributes
      delete :destroy, params: {id: task.to_param}, session: valid_session
      expect(response).to redirect_to(tasks_url)
    end
  end

end
