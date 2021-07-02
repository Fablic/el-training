require 'rails_helper'

RSpec.describe Task, type: :system do
  describe 'Task CRUD' do
    describe 'create task' do
      context 'valid form input' do
        it 'create success' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq root_path
          expect(page).to have_content '作成しました！'
        end
      end

      context 'invalid form input' do
        it 'create failed (name is missing)' do
          visit new_task_path
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '名前を入力してください'
        end

        it 'create failed (end_date is invalid)' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: 'abc'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '締切は不正な値です'
        end

        it 'create failed (priority is invalid)' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'read task' do
      let!(:task1) { create(:task, name: 'task1', created_at: (Time.zone.today - 2.days).to_s) }
      let!(:task2) { create(:task, name: 'task2', created_at: (Time.zone.today - 1.day).to_s) }
      let!(:task3) { create(:task, name: 'task3', created_at: Time.zone.today.to_s) }
      context 'read all tasks' do
        it 'read all tasks success' do
          visit root_path
          tasks = page.all('.task-container')
          # 作成日の降順に表示されていることを確認
          expect(tasks[0].text).to have_content 'task3'
          expect(tasks[1].text).to have_content 'task2'
          expect(tasks[2].text).to have_content 'task1'
        end
      end

      context 'read task detail' do
        it 'read task detail success' do
          visit task_path(task1)
          expect(page.text).to have_content 'task1'
        end
      end
    end

    describe 'update task' do
      let(:task) { create(:task) }
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: 'my task'
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq root_path
          expect(page).to have_content '更新しました！'
        end
      end

      context 'invalid form input' do
        it 'edit failed (name is missing)' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '名前を入力してください'
        end

        it 'edit failed (end_date is invalid)' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: 'abc'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '締切は不正な値です'
        end

        it 'edit failed (priority is invalid)' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button '更新'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'delete task' do
      let(:task) { create(:task) }
      context 'click delete button' do
        it 'delete success' do
          visit task_path(task)
          click_link '削除'
          expect(current_path).to eq root_path
          expect(page).to have_content '削除しました！'
        end
      end
    end

    describe 'search task' do

      # ステータスの異なるprivate_taskの作成
      # 優先度: 1, 締切日: 10日後
      let!(:private_task_todo) { create(:private_task, name: 'private_task_todo', status: 'todo') }
      let!(:private_task_in_progress) { create(:private_task, name: 'private_task_in_progress', status: 'in_progress') }
      let!(:private_task_done) { create(:private_task, name: 'private_task_done', status: 'done') }

      # ステータスの異なるwork_taskの作成
      # 優先度: 5, 締切日: 5日後
      let!(:work_task_todo) { create(:work_task, name: 'work_task_todo', status: 'todo') }
      let!(:work_task_in_progress) { create(:work_task, name: 'work_task_in_progress', status: 'in_progress') }
      let!(:work_task_done) { create(:work_task, name: 'work_task_done', status: 'done') }

      # ステータスの異なるemergency_taskの作成
      # 優先度: 10, 締切日: 今日
      let!(:emergency_task_todo) { create(:emergency_task, name: 'emergency_task_todo', status: 'todo') }
      let!(:emergency_task_in_progress) { create(:emergency_task, name: 'emergency_task_in_progress', status: 'in_progress') }
      let!(:emergency_task_done) { create(:emergency_task, name: 'emergency_task_done', status: 'done') }

      context 'check search name function' do
        it 'search name=private_task sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'private_task'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'private_task_in_progress'
          expect(tasks[2].text).to have_content 'private_task_done'
        end

        it 'search name=task sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'task'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'private_task_in_progress'
          expect(tasks[2].text).to have_content 'private_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'emergency_task_todo'
          expect(tasks[7].text).to have_content 'emergency_task_in_progress'
          expect(tasks[8].text).to have_content 'emergency_task_done'
        end
      end

      context 'check status filter function' do
        it 'status=未着手 sort_by ID ASC' do
          visit root_path
          select '未着手', from: 'status'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'work_task_todo'
          expect(tasks[2].text).to have_content 'emergency_task_todo'
        end

        it 'status=着手中 sort_by ID ASC' do
          visit root_path
          select '着手中', from: 'status'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_in_progress'
          expect(tasks[1].text).to have_content 'work_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_in_progress'
        end

        it 'status=完了 sort_by ID ASC' do
          visit root_path
          select '完了', from: 'status'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_done'
          expect(tasks[1].text).to have_content 'work_task_done'
          expect(tasks[2].text).to have_content 'emergency_task_done'
        end
      end

      context 'check search name function and status filter function' do
        it 'name=work_task status=着手中 sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'work_task'
          select '着手中', from: 'status'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'work_task_in_progress'
        end

        it 'name=task status=完了 sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'task'
          select '完了', from: 'status'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_done'
          expect(tasks[1].text).to have_content 'work_task_done'
          expect(tasks[2].text).to have_content 'emergency_task_done'
        end
      end

      context 'check sort function' do
        it 'sort_by end_date ASC' do
          visit root_path
          select '締切', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'emergency_task_todo'
          expect(tasks[1].text).to have_content 'emergency_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'private_task_todo'
          expect(tasks[7].text).to have_content 'private_task_in_progress'
          expect(tasks[8].text).to have_content 'private_task_done'
        end

        it 'sort_by priority DESC' do
          visit root_path
          select '優先度', from: 'sort'
          select '降順', from: 'direction'
          click_button 'search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'emergency_task_todo'
          expect(tasks[1].text).to have_content 'emergency_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'private_task_todo'
          expect(tasks[7].text).to have_content 'private_task_in_progress'
          expect(tasks[8].text).to have_content 'private_task_done'
        end
      end
    end
  end
end
