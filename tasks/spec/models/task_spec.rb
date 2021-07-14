require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '正常系' do
    context 'タスク名、ステータス、優先度がある場合' do
      let(:task) { build(:task) }
      it '有効である' do
        expect(task).to be_valid
      end
    end
  end

  describe 'タスク名バリデーション' do
    let(:task) { build(:task, task_name: task_name) }
    context 'タスク名がない場合' do
      let(:task_name) { '' }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:task_name]).to include('を入力してください')
      end
    end
    context 'タスク名の文字数が上限未満の場合' do
      let(:task_name) { 'a' * 59 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context 'タスク名の文字数が上限と同じ場合' do
      let(:task_name) { 'a' * 60 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context 'タスク名の文字数が上限を超える場合' do
      let(:task_name) { 'a' * 61 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:task_name]).to include('は60文字以内で入力してください')
      end
    end
  end

  describe 'ステータスのバリデーション' do
    let(:task) { build(:task, status_id: status) }
    context 'ステータスがない場合' do
      let(:status) { nil }
      it 'エラーになる' do
        task.status_id = status
        expect(task).to be_invalid
        expect(task.errors[:status]).to include('を入力してください')
      end
    end
  end

  describe '優先度のバリデーション' do
    let(:task) { build(:task, priority_id: priority) }
    context '優先度がない場合' do
      let(:priority) { nil }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:priority]).to include('を入力してください')
      end
    end
  end

  describe 'ラベルのバリデーション' do
    let(:task) { build(:task, label: label) }
    context '空文字の場合' do
      let(:label) { '' }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限未満の場合' do
      let(:label) { 'a' * 19 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限と同じ場合' do
      let(:label) { 'a' * 20 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限を超える場合' do
      let(:label) { 'a' * 21 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:label]).to include('は20文字以内で入力してください')
      end
    end
  end

  describe '詳細説明のバリデーション' do
    let(:task) { build(:task, detail: detail) }
    context '空文字の場合' do
      let(:detail) { '' }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限未満の場合' do
      let(:detail) { 'a' * 249 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '文字数が上限と同じ場合' do
      let(:detail) { 'a' * 250 }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '詳細説明の文字数が上限を超える場合' do
      let(:detail) { 'a' * 251 }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:detail]).to include('は250文字以内で入力してください')
      end
    end
  end

  describe '期限のバリデーション' do
    let(:task) { build(:task, limit_date: limit_date) }
    context '期限を設定していない場合' do
      let(:limit_date) { nil }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '期限が現在時刻より後に設定する場合' do
      let(:limit_date) { Time.current + 1.minute }
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '現在時刻と同じに設定する場合' do
      let(:limit_date) { Time.current }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
    context '現在時刻より前に設定する場合' do
      let(:limit_date) { Time.current - 1.minute }
      it 'エラーになる' do
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
  end

  describe 'すでに設定されている期限が現在時刻より前の日時のバリデーション' do
    let(:task) { travel(-1.day) { create(:exist_limit_date_task) } }
    context '期限が変更されていない場合' do
      it '有効である' do
        expect(task).to be_valid
      end
    end
    context '現在時刻より前の日時に期限が変更される場合' do
      it 'エラーになる' do
        task.limit_date = Time.current - 1.minute
        expect(task).to be_invalid
        expect(task.errors[:limit_date]).to include('現在時刻より前の日時は設定できません')
      end
    end
    context '現在時刻より後の日時に期限が変更される場合' do
      it '有効である' do
        task.limit_date = Time.current + 1.minute
        expect(task).to be_valid
      end
    end
  end

  describe 'scope' do
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
    context '論理削除されたタスクが存在する場合' do
      let(:task_list_deleted_at_null) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.deleted_at.nil?
        end
        return expect_task_list
      end
      it '論理削除されていないタスクを全て取得する' do
        expect(Task.without_deleted).to match_array task_list_deleted_at_null
      end
    end
    context '検索欄に「タス」を入力した場合' do
      let(:task_list_search_task_name) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.task_name.include?('タス')
        end
        return expect_task_list
      end
      it 'タスク名に「タス」を含むタスクを全て取得する' do
        expect(Task.search_task_name('タス')).to match_array task_list_search_task_name
      end
    end
    context 'ステータスの絞り込みが「着手」を指定した場合' do
      let(:task_list_search_status) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.status_id == 2
        end
        return expect_task_list
      end
      it 'ステータスが「着手」のタスクを全て取得する' do
        expect(Task.search_status(['2'])).to match_array task_list_search_status
      end
    end
    context 'ステータスの絞り込みが「着手」と「完了」を指定した場合' do
      let(:task_list_search_statuses) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.status_id == 2 || task.status_id == 3
        end
        return expect_task_list
      end
      it 'ステータスが「着手」と「完了」のタスクを全て取得する' do
        expect(Task.search_status(%w[2 3])).to match_array task_list_search_statuses
      end
    end
    context 'ステータス絞り込みが「未着手」と「着手」と「完了」の全てを指定した場合' do
      let(:task_list_search_statuses_all) do
        expect_task_list = []
        task_list.each do |task|
          expect_task_list.push(task) if task.status_id == 1 || task.status_id == 2 || task.status_id == 3
        end
        return expect_task_list
      end
      it 'タスクを全て取得する' do
        expect(Task.search_status(%w[1 2 3])).to match_array task_list_search_statuses_all
      end
    end
    context '期限を昇順になるようにした場合' do
      let(:task_list_sort_asc_limit_date) do
        return task_list.sort do |a, b|
          if a.limit_date.nil?
            -1
          elsif b.limit_date.nil?
            1
          else
            a.limit_date <=> b.limit_date
          end
        end
      end
      it 'タスクを全て、期限の昇順で取得する' do
        expect(Task.sort_task('limit_date asc')).to match task_list_sort_asc_limit_date
      end
    end
    context '期限を降順になるようにした場合' do
      let(:task_list_sort_desc_limit_date) do
        return task_list.sort do |a, b|
          if a.limit_date.nil?
            1
          elsif b.limit_date.nil?
            -1
          else
            b.limit_date <=> a.limit_date
          end
        end
      end
      it 'タスクを全て、期限の降順で取得する' do
        expect(Task.sort_task('limit_date desc')).to match task_list_sort_desc_limit_date
      end
    end
  end
end
