require 'rails_helper'
require 'capybara/rspec'

describe "Task", type: :feature do

let!(:tasks) {create_list(:task, 5)}
 
  describe "#index" do
    context 'when opning index' do
      it 'The screen is displayed collectly' do
        visit tasks_path
    
        expect(page).to have_content 'Task一覧'
        expect(page).to have_content 'Title'
        expect(page).to have_content 'Memo'
        expect(page).to have_content 'Deadline'
      end
    end

    context 'when created_at is sorted' do
      it 'tasks are sorted in descending order' do
        visit '/tasks?sort=created_at+desc'
        task_array = all('.task')
          expect(task_array[0]).to have_content tasks[4].title
          expect(task_array[1]).to have_content tasks[3].title
          expect(task_array[2]).to have_content tasks[2].title
          expect(task_array[3]).to have_content tasks[1].title
          expect(task_array[4]).to have_content tasks[0].title
      end
    end
  end

  describe "#new" do
    context 'when creating task' do
      it 'task are saved' do
        visit new_task_path

        fill_in 'Title', with: 'huga'
        fill_in 'Memo', with: 'hogehoge'
        select_date( "2020,10,10" , from: 'Deadline')

        click_button '登録する'
        expect(page).to have_content 'Taskは正常に作成されました'
      end
    end
  end

  describe "#edit" do
    context 'when editing task' do
      it 'task are updated' do
        visit edit_task_path(tasks[0])

        fill_in 'Title', with: 'test'
        fill_in 'Memo', with: 'testtest'
        select_date( "2020,10,10" , from: 'Deadline')

        click_button '更新する'
        expect(page).to have_content 'Taskは正常に更新されました'
      end
    end
  end
  
  describe "#show" do
    context 'when opning task' do
      it 'returns task' do
        visit task_path(tasks[0])

        expect(page).to have_content 'Task詳細'
        expect(page).to have_content tasks[0].title
        expect(page).to have_content tasks[0].memo
        expect(page).to have_content tasks[0].deadline.strftime('%Y/%m/%d')

      end
    end
  end

  describe "#delete" do
    context 'when task is deleted' do
      it 'redirect_to index' do
        visit task_path(tasks[0])

        click_on 'Delete'
        expect(page).to have_content 'Taskは正常に削除されました'
      end
    end
  end
end
