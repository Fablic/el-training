require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:lowTaskPriority) { create(:low) }
  let(:notStartedTaskStatus) { create(:notStarted) }
  let(:task) { create(:task) }

  describe '#index' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :index
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :index
      end
    end
  end

  describe '表示されるタスク一覧が、指定した条件に合っているかチェック（検索、絞り込み、ソートの複合処理）' do
    let!(:task_list) do
      [
        create(:task_list_item),
        create(:task_list_item, task_name: 'テスト1', status: create(:started), created_at: Time.current + 1.day, limit_date: Time.current + 5.days),
        create(:task_list_item, task_name: 'タスク1', status: create(:finished), created_at: Time.current + 2.days, limit_date: Time.current + 3.days),
        create(:task_list_item, task_name: 'テスト2', status: create(:notStarted), created_at: Time.current + 3.days, limit_date: Time.current + 6.days),
        create(:task_list_item, task_name: 'タスク2', status: create(:started), created_at: Time.current + 4.days, limit_date: Time.current + 4.days),
        create(:task_list_item, task_name: 'テストタスク1', deleted_at: Time.current, limit_date: Time.current + 2.days)
      ]
    end
    context '何も指定がない場合（初期表示）' do
      let(:task_list_default) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.deleted_at.nil?
        end
        return expect_task_list.sort do |a, b|
          b.created_at <=> a.created_at
        end
      end
      it '論理削除されていない、全てのタスクが、作成日時の降順で取得されること' do
        get :index
        expect(assigns(:tasks)).to match task_list_default
      end
    end
    context '検索欄に「テス」を入力、絞り込みを「未着手」「着手」を選択し、期限の昇順を指定した場合' do
      let(:task_list_search_and_sort) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.deleted_at.nil? && task.task_name.include?('テス') && (task.status_id == 1 || task.status_id == 2)
        end
        return expect_task_list.sort do |a, b|
          if a.limit_date.nil?
            -1
          elsif b.limit_date.nil?
            1
          else
            a.limit_date <=> b.limit_date
          end
        end
      end
      it '論理削除されていない、タスク名に「テス」を含む、ステータスが「未着手」と「着手」の全てのタスクが、期限の昇順で取得されること' do
        get :index, params: { keyword: 'テス', statuses: %w[1 2], direction: 'asc', sort: 'limit_date' }
        expect(assigns(:tasks)).to match task_list_search_and_sort
      end
    end
  end

  describe '#show' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :show, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :show
      end
    end
  end

  describe '#new' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :new
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :new
      end
    end
  end

  describe '#edit' do
    context 'レスポンスが正常の時' do
      it 'HTTPステータスコードが200、テンプレートが表示されること' do
        get :edit, params: { id: task.id }
        expect(response).to be_successful
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
      end
    end
  end

  describe '#create' do
    context '正常な値' do
      let(:newTask) { { task_name: '新規作成テストタスク', priority_id: lowTaskPriority, status_id: notStartedTaskStatus, label: nil, limit_date: nil, detail: nil } }
      it '正常にタスクを作成できること' do
        expect { post :create, params: { task: newTask } }.to change(Task, :count).by(1)
      end
      it '新規作成後、詳細ページにリダイレクトされること' do
        post :create, params: { task: newTask }
        expect(response).to redirect_to "/tasks/#{Task.last.id}"
      end
    end
    context '不正な値' do
      let(:unjustNewTask) { { task_name: '新規作成テストタスク', priority: nil, status_id: notStartedTaskStatus, label: nil, limit_date: nil, detail: nil } }
      it 'タスクが作成されないこと' do
        expect { post :create, params: { task: unjustNewTask } }.to change(Task, :count).by(0)
      end
      it '新規作成ページが表示されること' do
        post :create, params: { task: unjustNewTask }
        expect(response).to render_template :new
      end
    end
  end

  describe '#update' do
    context '正常な値' do
      let(:normalTaskParams) { { task_name: '変更後テストタスク名', status_id: notStartedTaskStatus, priority_id: lowTaskPriority } }
      it '正常にタスクを更新できること' do
        patch :update, params: { id: task.id, task: normalTaskParams }
        expect(task.reload.task_name).to eq '変更後テストタスク名'
      end
      it '更新後、詳細ページにリダイレクトされること' do
        task_params = normalTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to redirect_to "/tasks/#{task.id}"
      end
    end
    context '不正な値' do
      let(:unjustTaskParams) { { task_name: '変更後テストタスク名', status_id: 4, priority_id: lowTaskPriority } }
      it 'タスクを更新できないこと' do
        task_params = unjustTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(task.reload.status).to eq notStartedTaskStatus
      end
      it '更新ページが表示されること' do
        task_params = unjustTaskParams
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to render_template :edit
      end
    end
  end

  describe '#destroy' do
    it '正常にタスクを論理削除できること' do
      patch :destroy, params: { id: task.id }
      expect(task.reload.deleted_at).to_not eq nil
    end
    it '削除後、一覧ページにリダイレクトされること' do
      patch :destroy, params: { id: task.id }
      expect(response).to redirect_to '/tasks'
    end
  end
end
