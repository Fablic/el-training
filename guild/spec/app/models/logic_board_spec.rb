require 'rails_helper'
require 'task'
require 'value_objects/state'
require 'value_objects/priority'
require 'value_objects/label'

describe LogicBoard , type: :model do
  let!(:user_id) {1}
  let!(:task_a) { create(:task1) }
  let!(:expected) {
    {
      state:    ValueObjects::State.get_list,
      priority: ValueObjects::Priority.get_list,
      label:    ValueObjects::Label.get_list,
    }
  }

  describe '#index' do
    context 'Valid user' do
      it 'task is found' do
        result = LogicBoard.index(user_id)
        result['task_list'].each do | task |
          expect(task).to be_an_instance_of(Task)
          expect(task.user_id).to eq user_id
        end
        expect(result['state_list']).to eq expected[:state]
        expect(result['priority_list']).to eq expected[:priority]
        expect(result['label_list']).to eq expected[:label]
      end
    end
    context 'Invalid user' do
      it 'Task is not found' do
        ng_user_id = 999999
        result = LogicBoard.index(ng_user_id)
        expect(result['task_list'].empty?).to eq true
      end
    end
  end

  describe '#get_task_all' do
    context 'Valid user' do
      it 'task is found' do
        result = LogicBoard.get_task_all(user_id)
        result['task_list'].each do | task |
          expect(task).to be_an_instance_of(Task)
          expect(task.user_id).to eq user_id
        end
      end
    end
    context 'Invalid user' do
      it 'Task is not found' do
        ng_user_id = 999999
        result = LogicBoard.get_task_all(ng_user_id)
        expect(result['task_list'].empty?).to eq true
      end
    end
  end

  describe '#get_task_by_id' do
    context 'Valid user' do
      it 'task is found' do
        result = LogicBoard.get_task_by_id(user_id, task_a.id)
        expect(result['task']).to be_an_instance_of(Task)
        expect(result['task'].id).to eq task_a.id
        expect(result['task'].user_id).to eq task_a.user_id
      end
    end
    context 'Invalid user' do
      it 'Target task is not found' do
        ng_user_id = 999999
        ng_task_id = 999999
        result = LogicBoard.get_task_by_id(user_id, ng_task_id)
        expect(result['task']).to be_nil
      end
    end
  end

  describe '#get_state_list' do
    it 'Respond correctly' do
      expect(LogicBoard.get_state_list).to eq expected[:state]
    end
  end

  describe '#get_priority_list' do
    it 'Respond correctly' do
      expect(LogicBoard.get_priority_list).to eq expected[:priority]
    end
  end

  describe '#get_label_list' do
    it 'Respond correctly' do
      expect(LogicBoard.get_label_list).to eq expected[:label]
    end
  end

  describe '#create' do
    it 'Create correctly' do
      params = {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 2,
        'priority'    => 2,
      }

      result = LogicBoard.create(user_id, params)
      expect(result.nil?).to be false
      created_task_id = result

      result = LogicBoard.get_task_by_id(user_id, created_task_id)
      expect(result['task'].nil?).to be false
      expect(result['task']).to be_an_instance_of(Task)
      expect(result['task'].user_id).to eq user_id
      expect(result['task'].subject).to eq params['subject']
      expect(result['task'].description).to eq params['description']
      expect(result['task'].label).to eq params['label']
      expect(result['task'].priority).to eq params['priority']
    end
  end

  describe '#update' do
    it 'Update correctly' do
      params_for_create = {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 2,
        'priority'    => 2,
      }

      created_task_id = LogicBoard.create(user_id, params_for_create)

      params_for_update = {
        'id' => created_task_id,
        'subject'     => 'subject update by rspec',
        'description' => 'description update by rspec',
        'state'       => 2,
        'label'       => 3,
        'priority'    => 3,
      }

      result = LogicBoard.update(user_id, params_for_update)
      expect(result).to be true

      result = LogicBoard.get_task_by_id(user_id, created_task_id)
      expect(result['task'].nil?).to be false
      expect(result['task']).to be_an_instance_of(Task)
      expect(result['task'].user_id).to eq user_id
      expect(result['task'].subject).to eq params_for_update['subject']
      expect(result['task'].description).to eq params_for_update['description']
      expect(result['task'].label).to eq params_for_update['label']
      expect(result['task'].priority).to eq params_for_update['priority']
    end

    it 'Target task is not found' do
      params_for_update = {
        'id'          => 9999999,
        'subject'     => 'subject update by rspec',
        'description' => 'description update by rspec',
        'state'       => 2,
        'label'       => 3,
        'priority'    => 3,
      }

      result = LogicBoard.update(user_id, params_for_update)
      expect(result).to be false
    end
  end

  describe '#delete' do
    it 'Delete correctly' do
      params = {
        'subject'     => 'subject by rspec',
        'description' => 'description by rspec',
        'label'       => 4,
        'priority'    => 4,
      }

      created_task_id = LogicBoard.create(user_id, params)

      LogicBoard.delete(user_id, created_task_id)
      result = LogicBoard.get_task_by_id(user_id, created_task_id)
      expect(result['task']).to be_nil
    end

    it 'Target task is not found' do
      not_exsits_task_id = 9999999
      result = LogicBoard.delete(user_id, not_exsits_task_id)
      expect(result).to be false
    end
  end
end
