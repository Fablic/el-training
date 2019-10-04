# frozen_string_literal: true

describe TasksController, type: :request do
  describe 'GET #index' do
    context 'ログインしている' do
      let(:user) { FactoryBot.create :user }
      before do
        create_list(:task, 2, user: user)
        post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
      end

      context '全件表示の場合' do
        it 'リクエストが成功すること、タイトルが表示されていること' do
          get tasks_url
          expect(response).to have_http_status :ok
          expect(response.body).to include 'Task1'
          expect(response.body).to include 'Task2'
        end
      end

      context 'ステータスで絞り込む場合' do
        it 'リクエストが成功すること' do
          get tasks_url, params: { status: 2 }
          expect(response).to have_http_status :ok
        end
      end

      context '不正なステータスの場合' do
        it '件数が0件になる' do
          expect do
            get tasks_url, params: { status: 999_999_999_999 }
          end.to change(Task, :count).by(0)
        end
      end

      context 'ページを指定した場合' do
        it 'リクエストが成功すること' do
          get tasks_url, params: { page: 1 }
          expect(response).to have_http_status :ok
        end
      end

      context '存在しないページを指定した場合' do
        it '件数が0件になる' do
          expect do
            get tasks_url, params: { page: 999_999_999_999 }
          end.to change(Task, :count).by(0)
        end
      end

      context 'ステータスとページを同時に指定した場合' do
        it 'リクエストが成功すること' do
          get tasks_url, params: { status: 2, page: 1 }
          expect(response).to have_http_status :ok
        end
      end
    end

    context 'ログインしていない' do
      it 'ログインページにリダイレクトされること' do
        get tasks_url
        expect(response).to have_http_status :found
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #new' do
    let(:user) { FactoryBot.create :user }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
    end

    it 'リクエストが成功すること' do
      get new_task_url
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryBot.create :user }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
    end

    context '正常なパラメータの場合' do
      it 'TOPへのリダイレクトが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to have_http_status :found
        expect(response).to redirect_to tasks_url
      end

      it 'タスクが登録されること' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        end.to change(Task, :count).by(1)
      end

      it 'ユーザーが作成されていればタスクも登録できる' do
        user = create(:user)
        task = build(:task, user_id: user.id)
        expect(task).to be_valid
      end
    end

    context 'パラメータが不正(titleが空)な場合' do
      it 'ROOTへのリダイレクトが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response).to have_http_status :found
        expect(response).to redirect_to root_url
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        end.to_not change(Task, :count)
      end
    end

    context '例外が発生した場合' do
      it 'Exceptionは500エラーが発生する' do
        allow_any_instance_of(Task).to receive(:save!).and_raise(Exception)
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to have_http_status :internal_server_error
      end

      it '例外が発生した場合はエラーを表示し遷移しない' do
        allow_any_instance_of(Task).to receive(:save!).and_raise(ActiveRecord::RecordNotFound, 'nanikashira error')
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response.body).to include '登録に失敗しました'
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { FactoryBot.create :user }
    let(:task) { FactoryBot.create(:task, user: user) }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功し、タイトルと説明が表示されていること' do
        get edit_task_url task
        expect(response).to have_http_status :ok
        expect(response.body).to include 'Task'
        expect(response.body).to include 'Description'
      end
    end

    context 'パラメータが不正な場合' do
      it '存在しないIDなら404へ遷移すること' do
        undefined_task = FactoryBot.attributes_for(:task, id: 999_999_999)
        get edit_task_url undefined_task
        expect(response).to have_http_status :not_found
      end

      it '不正なIDならROOTへリダイレクトすること' do
        undefined_task = FactoryBot.attributes_for(:task, id: -1)
        get edit_task_url undefined_task
        expect(response).to have_http_status :found
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { FactoryBot.create :user }
    let(:task) { FactoryBot.create(:task, user: user) }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
    end

    context '正常なパラメータの場合' do
      it 'TOPへのリダイレクトが成功すること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:task, title: 'Update Task') }
        expect(response).to have_http_status :found
        expect(response).to redirect_to tasks_url
      end

      it 'タイトルが更新されること' do
        expect do
          put task_url task, params: { task: FactoryBot.attributes_for(:task, title: 'Update Task') }
        end.to change { Task.find(task.id).title }.to('Update Task')
      end
    end

    context 'パラメータが不正な場合' do
      it 'ROOTへのリダイレクトが成功すること' do
        put task_url task, params: { task: FactoryBot.attributes_for(:blank_task) }
        expect(response).to have_http_status :found
        expect(response).to redirect_to root_url
      end

      it 'タイトルが更新しないこと' do
        expect do
          put task_url task, params: { task: FactoryBot.attributes_for(:blank_task) }
        end.to_not change(Task.find(task.id), :title)
      end
    end

    context '例外が発生した場合' do
      it '例外が発生した場合はエラーを表示し遷移しない' do
        allow_any_instance_of(Task).to receive(:update!).and_raise(ActiveRecord::RecordNotFound, 'nanikashira error')
        put task_url task, params: { task: FactoryBot.attributes_for(:task, title: 'Update Task') }
        expect(response.body).to include '更新に失敗しました'
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create :user }
    before do
      post login_path, params: { login_id: user.login_id, password: 'TestPassword' }
    end

    context '正常なパラメータの場合' do
      let!(:task) { FactoryBot.create :task }

      it 'TOPへのリダイレクトが成功すること' do
        delete task_url task
        expect(response).to have_http_status :found
        expect(response).to redirect_to tasks_url
      end

      it 'タスクが削除されること' do
        expect do
          delete task_url task
        end.to change(Task, :count).by(-1)
      end
    end

    context 'パラメータが不正な場合' do
      it '存在しないIDならTOPへリダイレクトすること' do
        undefined_task = FactoryBot.attributes_for(:task, id: 999_999_999)
        delete task_url undefined_task
        expect(response).to have_http_status :found
        expect(response).to redirect_to tasks_url
      end
    end
  end
end
