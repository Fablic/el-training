# frozen_string_literal: true

require 'rails_helper'
require 'features/test_helpers'

describe 'エラー画面', type: :feature do
  before { visit path }

  context '/404へアクセスした場合' do
    let(:path) { '/404' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '4O4')
      expect(page).to have_selector('.text-muted', text: 'お探しのページは見つかりませんでした。')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '存在しないパスへアクセスした場合' do
    let(:path) { '/undefined' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '4O4')
      expect(page).to have_selector('.text-muted', text: 'お探しのページは見つかりませんでした。')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '/422へアクセスした場合' do
    let(:path) { '/422' }

    it '422エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '422')
      expect(page).to have_selector('.text-muted', text: 'このページは表示できません。')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '/500へアクセスした場合' do
    let(:path) { '/500' }

    it '500エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '500')
      expect(page).to have_selector('.text-muted', text: 'ページが表示できません。')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end
end
