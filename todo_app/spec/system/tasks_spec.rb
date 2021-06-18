require 'rails_helper'

RSpec.describe 'Tasks', type: :sytem do
  let!(:old_task) { create(:task, created_at: Faker::Time.backward, due_date: Faker::Time.backward) }
  let(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
  let(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }
  let(:due_date) { Faker::Time.forward }
  let(:ja_title) { Task.human_attribute_name(:title) }
  let(:ja_desc) { Task.human_attribute_name(:description) }
  let(:ja_due_date) { Task.human_attribute_name(:due_date) }

  describe '#index' do
    let!(:new_task) { create(:task, created_at: Faker::Time.forward, due_date: Faker::Time.forward) }

    it 'vist tasks/index' do
      visit root_path

      expect(current_path).to eq root_path

      expect(page).to have_content(old_task.title)
      expect(page).to have_content(old_task.description)
    end

    context 'not click created_at link' do
      it 'order created_at ASC' do
        visit root_path

        expect(page.body.index(old_task.title)).to be < page.body.index(new_task.title)
      end
    end

    context 'click created_at link' do
      it 'order created_at DESC' do
        visit root_path
        click_link Task.human_attribute_name(:created_at)
  
        expect(page.body.index(old_task.title)).to be > page.body.index(new_task.title)
      end
    end

    context 'send invalid paramter' do
      it 'order created_at ASC' do
        visit root_path(order: 'hoge')

        expect(page.body.index(old_task.title)).to be < page.body.index(new_task.title)
      end
    end

    context 'click due_date link twice' do
      it 'order due_date ASC' do
        visit root_path
        click_link Task.human_attribute_name(:due_date)
        click_link Task.human_attribute_name(:due_date)
      
        expect(page.body.index(I18n.l(old_task.due_date))).to be < page.body.index(I18n.l(new_task.due_date))
      end
    end

    context 'click due_date link once' do
      it 'order due_date DESC' do
        visit root_path
        click_link Task.human_attribute_name(:due_date)

        expect(page.body.index(I18n.l(old_task.due_date))).to be > page.body.index(I18n.l(new_task.due_date))
      end
    end
  end

  describe '#new' do
    let(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let(:due_date) { Faker::Time.forward }

    it 'create task' do
      visit new_task_path

      fill_in ja_title, with: title
      fill_in ja_desc, with: desc
      fill_in ja_due_date, with: due_date

      expect do
        click_button I18n.t('common.action.create')
      end.to change(Task, :count).by(1)

      expect(current_path).to eq root_path

      expect(page).to have_content(I18n.t('tasks.flash.success.create'))
      expect(page).to have_content(title)
      expect(page).to have_content(desc)
      expect(page).to have_content(I18n.l(due_date))
    end
  end

  describe '#edit' do
    it 'update task' do
      visit edit_task_path(old_task)

      expect(current_path).to eq edit_task_path(old_task)

      expect(page).to have_field ja_title, with: old_task.title
      expect(page).to have_field ja_desc, with: old_task.description

      fill_in ja_title, with: title
      fill_in ja_desc, with: desc
      fill_in ja_due_date, with: due_date

      expect do
        click_button I18n.t('common.action.update')
      end.to change(Task, :count).by(0)
  
      expect(current_path).to eq task_path(old_task)

      expect(page).to have_content(I18n.t('tasks.flash.success.update'))
      expect(page).to have_content(title)
      expect(page).to have_content(desc)
    end
  end

  describe '#show' do
    it 'visit show' do
      visit task_path(old_task)

      expect(current_path).to eq task_path(old_task)

      expect(page).to have_content(old_task.title)
      expect(page).to have_content(old_task.description)
      expect(page).to have_content(I18n.l(old_task.due_date))
    end
  end

  describe '#destroy' do
    it 'delete record' do
      visit task_path(old_task)

      expect(current_path).to eq task_path(old_task)

      expect do
        click_link I18n.t('common.action.destroy')
      end.to change(Task, :count).by(-1)

      expect(current_path).to eq root_path

      expect(page).to have_content(I18n.t('tasks.flash.success.destroy'))
      expect(page).to_not have_content(old_task.title)
      expect(page).to_not have_content(old_task.description)
      expect(page).to_not have_content(I18n.l(old_task.due_date))
    end
  end
end
