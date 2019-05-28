# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  specify 'User operates from creation to editing to deletion' do
    visit root_path

    expect(page).to have_content('Tasks')

    click_on '新規'

    fill_in 'タスク名', with: 'task name'
    fill_in '説明', with: 'hoge'
    select '着手', from: 'ステータス'

    click_on '登録する'

    expect(page).to have_content('タスクの登録が完了しました。')
    expect(page).to have_content('task name')
    expect(page).to have_content('hoge')
    expect(page).to have_content('着手')

    click_on '編集'

    expect(page).to have_content('Editing Task')
    fill_in 'タスク名', with: 'update'
    fill_in '説明', with: 'hoge-update'
    select '完了', from: 'ステータス'

    click_on '更新する'

    expect(page).to have_content('タスクの更新が完了しました。')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('完了')

    click_on '戻る'

    expect(page).to have_content('Tasks')
    expect(page).to have_content('update')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('完了')
  end

  context '一覧表示' do
    before do
      create(:task, { name: 'task1', created_at: Time.zone.now })
      create(:task, { name: 'task2', created_at: 1.day.ago })
    end

    scenario '一覧のソート順が登録日の降順であること' do
      visit root_path

      tds = page.all('td')
      expect(tds[0]).to have_content 'task1'
    end
  end
end
