require 'rails_helper'

RSpec.describe 'Task management', type: :system, js: true do
  before do
    Task.create!(title: 'rspec Test', description: 'rspec Description')
  end

  scenario 'When user visit the tasks_path it shows the task list.' do
    visit tasks_path
    expect(page).to have_content 'rspec Description'
  end

  scenario 'When user click New Task link it creates new task.' do
    visit tasks_path
    click_link 'New Task'
    fill_in 'Title', :with => 'My Task'
    fill_in 'Description', :with => 'My Task Description'
    click_button 'Create Task'
    expect(page).to have_content 'Task was successfully created.'
  end

  scenario 'When user click Edit link it updates the selected task.' do
    visit tasks_path
    click_link 'Edit'
    fill_in 'Title', :with => 'My Edited Task'
    fill_in 'Description', :with => 'Edit My Task Description'
    click_button 'Update Task'
    expect(page).to have_content 'Task was successfully updated.'
  end

  scenario 'When user click Destroy link it deletes the selected task.' do
    visit tasks_path
    accept_alert do
      click_link 'Destroy'
    end
    expect(page).to have_content 'Task was successfully destroyed.'
  end

end
