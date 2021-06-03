# frozen_string_literal: true

require 'rails_helper'

describe 'Tasks', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:another_user) { FactoryBot.create(:user) }
  let!(:work_label) { FactoryBot.create(:label, name: 'work', user: user) }
  let!(:private_label) { FactoryBot.create(:label, name: 'private', user: user) }
  let!(:first_task) {
    FactoryBot.create(:task,
                      title: 'First task',
                      description: 'Submit documents',
                      priority: 2,
                      aasm_state: :doing,
                      user: user,
                      labels: [work_label, private_label])
  }
  let!(:second_task) {
    FactoryBot.create(:task,
                      title: 'Second task',
                      description: 'Take e-learning',
                      priority: 1,
                      aasm_state: :done,
                      user: user,
                      labels: [work_label])
  }

  shared_examples_for 'ページ名がタスク一覧になっている' do
    it { expect(page).to have_selector 'h1', text: 'タスク一覧' }
  end

  shared_examples_for 'ページ名がタスク詳細になっている' do
    it { expect(page).to have_selector 'h1', text: 'タスク詳細' }
  end

  shared_examples_for 'ログイン中のユーザ名が表示される' do
    it { expect(page).to have_content "#{user.name} でログイン中" }
  end

  describe '一覧表示' do
    context 'タスクを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
      end

      it '全てのタスクが表示される' do
        expect(page).to have_content 'First task'
        expect(page).to have_content 'Second task'
      end

      it 'ラベルが表示される' do
        trs = page.all('tbody tr')
        expect(trs[0]).to have_content 'work'
        expect(trs[1]).to have_content 'work'
        expect(trs[1]).to have_content 'private'
      end

      it '優先順位順に表示される' do
        expect(page.body.index(second_task.title)).to be < page.body.index(first_task.title)
      end

      it 'リンクが表示される' do
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '新規作成'
        expect(page).to have_link 'ログアウト'
        expect(page).to have_link 'ラベル'
      end

      it 'ボタンが表示される' do
        expect(page).to have_button '絞り込む'
      end

      it_behaves_like 'ページ名がタスク一覧になっている'
      it_behaves_like 'ログイン中のユーザ名が表示される'
    end

    context 'タスクを登録していないユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: another_user.email
        fill_in 'パスワード', with: another_user.password
        click_button 'ログイン'
      end

      it '他のユーザーのタスクは表示されない' do
        expect(page).to have_no_content 'First task'
        expect(page).to have_no_content 'Second task'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit tasks_path
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '詳細表示' do
    context 'タスクを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit task_path(first_task)
      end

      it 'タスクの属性を表示する' do
        expect(page).to have_content 'First task'
        expect(page).to have_content 'Submit documents'
        expect(page).to have_content 'work'
        expect(page).to have_content 'private'
      end

      it 'リンクが表示される' do
        expect(page).to have_link '編集'
        expect(page).to have_link '戻る'
      end

      it_behaves_like 'ページ名がタスク詳細になっている'
      it_behaves_like 'ログイン中のユーザ名が表示される'
    end

    context 'タスクを登録していないユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: another_user.email
        fill_in 'パスワード', with: another_user.password
        click_button 'ログイン'
        visit task_path(first_task)
      end

      it 'エラーが表示される' do
        expect(page).to have_current_path tasks_path
        expect(page).to have_selector '.alert', text: 'データがありません'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit task_path(first_task)
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '新規作成' do
    context 'タスクを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit new_task_path
        fill_in '優先順位', with: 3
        fill_in 'タスク名', with: 'Third task'
        fill_in 'タスク詳細', with: 'Introduce myself'
        check "task_label_ids_#{work_label.id}"
        click_button '作成する'
      end

      it '作成したタスクの属性を表示する' do
        expect(page).to have_content 'Third task'
        expect(page).to have_content 'Introduce myself'
        expect(page).to have_content 'work'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'タスクの作成が完了しました'
      end

      it_behaves_like 'ページ名がタスク詳細になっている'
    end

    context 'ログインしていないとき' do
      before do
        visit new_task_path
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '編集' do
    context 'タスクを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit edit_task_path(first_task)
        fill_in 'タスク名', with: '1st Task'
        fill_in 'タスク詳細', with: 'Submit papers'
        click_button '更新する'
      end

      it '更新後のタスクの属性を表示する' do
        expect(page).to have_content '1st Task'
        expect(page).to have_content 'Submit papers'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'タスクの更新が完了しました'
      end

      it_behaves_like 'ページ名がタスク詳細になっている'
    end

    context 'タスクを登録していないユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: another_user.email
        fill_in 'パスワード', with: another_user.password
        click_button 'ログイン'
        visit edit_task_path(first_task)
      end

      it 'エラーが表示される' do
        expect(page).to have_current_path tasks_path
        expect(page).to have_selector '.alert', text: 'データがありません'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit edit_task_path(first_task)
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe 'ラベルの編集' do
    before do
      first_task.destroy # 対象のタスクを１つにしておく
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit edit_task_path(second_task)
    end

    context '追加するとき' do
      before do
        check "task_label_ids_#{private_label.id}"
        click_button '更新する'
      end

      it '追加したラベルと既存のラベルが表示される' do
        expect(page).to have_content 'work'
        expect(page).to have_content 'private'
      end
    end

    context '削除するとき' do
      before do
        uncheck "task_label_ids_#{work_label.id}"
        click_button '更新する'
      end

      it 'ラベルは表示されない' do
        expect(page).to have_no_content 'work'
        expect(page).to have_no_content 'private'
      end
    end
  end

  describe '削除' do
    before do
      second_task.destroy # '削除'のリンクを1つにしたいので、対象のタスクを１つにしておく
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      click_link '削除'
    end

    context '確認ダイアログでOKを選択する場合' do
      before do
        page.accept_confirm
      end

      it 'タスクが削除され属性が表示されなくなる' do
        expect(page).to have_no_content 'First task'
        expect(page).to have_no_content 'Submit documents'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'タスクの削除が完了しました'
      end

      it_behaves_like 'ページ名がタスク一覧になっている'
    end

    context '確認ダイアログでキャンセルを選択する場合' do
      before do
        page.dismiss_confirm
      end

      it 'タスクが削除されていない' do
        expect(page).to have_content 'First task'
        expect(page).to have_content 'Submit documents'
      end

      it_behaves_like 'ページ名がタスク一覧になっている'
    end
  end

  describe '検索' do
    before do
      FactoryBot.create(:task,
                        title: 'Third task',
                        description: 'Create account',
                        priority: 3,
                        aasm_state: :ready,
                        user: user)
      FactoryBot.create(:task,
                        title: 'First job',
                        description: 'Setup environment',
                        priority: 4,
                        aasm_state: :ready,
                        user: user)
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    context 'ステータスで検索する場合' do
      before do
        select '未着手', from: 'q[aasm_state_eq]'
        click_button '絞り込む'
      end

      it '未着手のタスクのみが表示される' do
        expect(page).to have_content 'Third task'
        expect(page).to have_content 'First job'
        expect(page).to have_no_content 'Second task'
        expect(page).to have_no_content 'First task'
      end
    end

    context 'タスク名で検索する場合' do
      before do
        fill_in 'q[title_cont]', with: 'First'
        click_button '絞り込む'
      end

      it '指定したタスク名のタスクのみが表示される' do
        expect(page).to have_content 'First job'
        expect(page).to have_content 'First task'
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'Second task'
      end
    end

    context 'ラベルで検索する場合' do
      before do
        select 'private', from: 'q[labels_id_eq]'
        click_button '絞り込む'
      end

      it '指定したラベルがついたタスクのみが表示される' do
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'First job'
        expect(page).to have_no_content 'Second task'
        expect(page).to have_content 'First task'
      end
    end

    context 'タスク名とステータスで検索する場合' do
      before do
        fill_in 'q[title_cont]', with: 'First'
        select '未着手', from: 'q[aasm_state_eq]'
        click_button '絞り込む'
      end

      it '指定した条件のタスクのみが表示される' do
        expect(page).to have_content 'First job'
        expect(page).to have_no_content 'First task'
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'Second task'
      end
    end

    context 'タスク名とステータスとラベルで検索する場合' do
      before do
        fill_in 'q[title_cont]', with: 'First'
        select '着手', from: 'q[aasm_state_eq]'
        select 'work', from: 'q[labels_id_eq]'
        click_button '絞り込む'
      end

      it '指定した条件のタスクのみが表示される' do
        expect(page).to have_no_content 'First job'
        expect(page).to have_content 'First task'
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'Second task'
      end
    end
  end

  describe 'ステータス変更' do
    before do
      FactoryBot.create(:task,
                        title: 'Third task',
                        description: 'Create account',
                        priority: 3,
                        aasm_state: :ready,
                        user: user)
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    it 'ボタンが表示される' do
      trs = page.all('tbody tr')
      expect(trs[1]).to have_button '完了する'
      expect(trs[2]).to have_button '着手する'
    end

    context '「完了する」ボタンを押す場合' do
      before do
        click_button '完了する'
        page.accept_confirm
      end

      it '「完了する」ボタンがなくなりステータスが完了になる' do
        trs = page.all('tbody tr')
        expect(trs[1]).to have_no_button '完了する'
        expect(trs[1]).to have_no_content '着手'
        expect(trs[1]).to have_content '完了'
      end
    end

    context '「着手する」ボタンを押す場合' do
      before do
        click_button '着手する'
        page.accept_confirm
      end

      it '「着手する」ボタンが「完了する」ボタンになり、ステータスが着手になる' do
        trs = page.all('tbody tr')
        expect(trs[2]).to have_no_button '着手する'
        expect(trs[2]).to have_button '完了する'
        expect(trs[2]).to have_no_content '未着手'
        expect(trs[2]).to have_content '着手'
      end
    end
  end

  describe 'メンテナンス中' do
    before do
      FileUtils.touch(Rails.root.join(MAINTENANCE_FILE_NAME))
      visit root_path
    end

    after do
      FileUtils.remove(Rails.root.join(MAINTENANCE_FILE_NAME))
    end

    it 'メンテナンス中の画面が表示される' do
      expect(page).to have_content("We're sorry, our service is under maintenance")
    end
  end
end
