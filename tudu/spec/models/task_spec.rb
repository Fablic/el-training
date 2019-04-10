require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with task" do
    task = Task.new(name: "name1", content: "content1")
    expect(task).to be_valid
  end

  it "is invalid with task" do

    params = [
      # name なし, content あり 
      {
        name: nil,
        content: 'content',
      },
      # name あり, content なし 
      {
        name: 'name',
        content: nil,
      },
      # name あり (文字数オーバー) , content あり 
      {
        name: 'a' * 51,
        content: 'content',
      },
      # name あり, content あり (文字数オーバー)  
      {
        name: 'name',
        content: 'c' * 501 
      },
    ]

    params.each do |param|
      task = Task.new(name: param[:name], content: param[:content])
      expect(task).not_to be_valid
    end
  end
end
