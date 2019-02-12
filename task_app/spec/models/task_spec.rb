# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'validation' do
    context '正常値のとき' do
      it { expect(FactoryBot.build(:task)).to be_valid }
    end

    describe 'タスク名' do
      let!(:task) { FactoryBot.build(:task, name: name) }
      subject { task }

      context '空のとき' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '1文字のとき' do
        let(:name) { 'a' * 1 }
        it { is_expected.to be_valid }
      end

      context '30文字のとき' do
        let(:name) { 'a' * 30 }
        it { is_expected.to be_valid }
      end

      context '31文字のとき' do
        let(:name) { 'a' * 31 }
        it { is_expected.to be_invalid }
      end
    end

    describe 'ユーザid' do
      let!(:task) { FactoryBot.build(:task, user_id: user_id) }
      subject { task }

      context '空のとき' do
        let(:user_id) { '' }
        it { is_expected.to be_invalid }
      end

      context '存在しないIDのとき' do
        let(:user_id) { 100 }
        it { is_expected.to be_invalid }
      end

      context '文字列のとき' do
        let(:user_id) { 'abc' }
        it { is_expected.to be_invalid }
      end

      context 'シンボルのとき' do
        let(:user_id) { :abc }
        it { is_expected.to be_invalid }
      end
    end

    describe '説明' do
      let!(:task) { FactoryBot.build(:task, description: description) }
      subject { task }

      context '空のとき' do
        let(:description) { '' }
        it { is_expected.to be_invalid }
      end

      context '1文字のとき' do
        let(:description) { 'a' * 1 }
        it { is_expected.to be_valid }
      end

      context '800文字のとき' do
        let(:description) { 'a' * 800 }
        it { is_expected.to be_valid }
      end

      context '801文字のとき' do
        let(:description) { 'a' * 801 }
        it { is_expected.to be_invalid }
      end
    end

    describe '期限' do
      let!(:task) { FactoryBot.build(:task, due_date: due_date) }
      subject { task }

      context '空のとき' do
        let(:due_date) { '' }
        it { is_expected.to be_invalid }
      end

      context '正常値(フォーマット1)のとき' do
        let(:due_date) { '20190212' }
        it { is_expected.to be_valid }
      end

      context '正常値(フォーマット2)のとき' do
        let(:due_date) { '2019-02-12' }
        it { is_expected.to be_valid }
      end

      context '正常値(フォーマット3)のとき' do
        let(:due_date) { '2019/02/12' }
        it { is_expected.to be_valid }
      end

      context '存在しない日付のとき' do
        let(:due_date) { '20190132' }
        it { is_expected.to be_invalid }
      end

      context '日付を表さない数字のとき' do
        let(:due_date) { '123' }
        it { is_expected.to be_invalid }
      end

      context '文字列のとき' do
        let(:due_date) { 'abc' }
        it { is_expected.to be_invalid }
      end
    end

    describe '優先度' do
      let(:task) { FactoryBot.build(:task, priority: priority) }
      subject { task }

      context '空のとき' do
        let(:priority) { '' }
        it { is_expected.to be_invalid }
      end

      context '正常値(整数)のとき' do
        let(:priority) { Task.priorities[:middle] }
        it { is_expected.to be_valid }
      end

      context '正常値(シンボル)のとき' do
        let(:priority) { :middle }
        it { is_expected.to be_valid }
      end

      context '正常値(文字列)のとき' do
        let(:priority) { 'middle' }
        it { is_expected.to be_valid }
      end

      context '不正値(整数)のとき' do
        let(:priority) { 5 }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '不正値(文字列)のとき' do
        let(:priority) { 'abc' }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '不正値(シンボル)のとき' do
        let(:priority) { :abc }
        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:tasks) {
      [
        # userを指定せずにtaskをcreateした場合、createする度に同一のuserを作成する為、emailのunique制約にひっかかる
        FactoryBot.create(:task, user: user, name: 'タスク', status: :to_do),
        FactoryBot.create(:task, user: user, name: 'task', status: :in_progress),
        FactoryBot.create(:task, user: user, name: 'タスク', status: :in_progress),
      ]
    }

    context '「タスク」で名前検索したとき' do
      it '2件のレコードを取得' do
        expect(Task.search({ name: 'タスク' }).count).to eq 2
      end
    end

    context '存在しない名前で検索したとき' do
      it '0件のレコードを取得' do
        expect(Task.search({ name: 'abc' }).count).to eq 0
      end
    end

    context '「着手中」でステータス検索したとき' do
      it '2件のレコードを取得' do
        expect(Task.search({ status: Task.statuses[:in_progress] }).count).to eq 2
      end
    end

    context '名前・ステータスで検索したとき' do
      it '1件のレコードを取得' do
        expect(Task.search({ name: 'タスク', status: Task.statuses[:in_progress] }).count).to eq 1
      end
    end
  end
end
