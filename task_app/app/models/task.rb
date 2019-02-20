# frozen_string_literal: true

class Task < ApplicationRecord
  SORT_COLUMNS = %i[priority due_date created_at].freeze
  SORT_DIRECTION = %i[asc desc].freeze

  belongs_to :user

  enum priority: %i[low middle high].freeze
  enum status: %i[to_do in_progress done].freeze

  validates :name,        presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :priority,    presence: true
  validates :status,      presence: true
  validate :validate_due_date

  # 検索は渡されたレコード、または1から行う
  def self.search(params, initial_records = nil)
    initial_records ||= self
    initial_records   = initial_records.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    initial_records   = initial_records.where(status: params[:status]) if params[:status].present?
    initial_records   = initial_records.order(sort_tasks(params[:sort_column], params[:sort_direction]))
    initial_records
  end

  def self.sort_tasks(column, direction)
    # 以下のunless文はどちらかがfalseの場合条件成立
    return { created_at: :desc } unless SORT_COLUMNS.include?(column&.to_sym) && SORT_DIRECTION.include?(direction&.to_sym)
    output = {}
    output[column] = direction
    output
  end

  private

  def validate_due_date
    errors.add(:due_date, :invalid) unless date_valid?(due_date)
  end

  def date_valid?(date)
    !!Date.parse(date.to_s)
  rescue TypeError, ArgumentError
    false
  end
end
