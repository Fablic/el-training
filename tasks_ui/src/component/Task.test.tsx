import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'

import { store, history } from '../state/store'
import Task from './Task'
import { tasksSlice } from '../state/tasksSlice'
import * as TasksSlice from '../state/tasksSlice'
import * as ReactRedux from 'react-redux'

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())

const renderIt = (task) => {
  render(
    <Provider store={store}>
      <Task task={task} />
    </Provider>
  )
}

const mockTask = {
  id: 1,
  name: 'task name',
  description: 'task description',
  edit: false,
}

describe('Task', () => {
  describe('render', () => {
    it('should show name and description', () => {
      renderIt(mockTask)

      const name = screen.getByLabelText('name-display')
      expect(name.innerHTML).toEqual(mockTask.name)
      const description = screen.getByLabelText('description-display')
      expect(description.innerHTML).toEqual(mockTask.description)
    })

    it('should show textfield for name when edit mode', () => {
      renderIt({ ...mockTask, edit: true })

      const nameDisplay = screen.queryAllByLabelText('name-display')
      expect(nameDisplay.length).toBe(0)
      const nameEdit = screen.getByLabelText('name-edit')
      expect(nameEdit.querySelector('input').value).toEqual(mockTask.name)
    })

    it('should show textfield for description when edit mode', () => {
      renderIt({ ...mockTask, edit: true })

      const descriptionDisplay = screen.queryAllByLabelText(
        'description-display'
      )
      expect(descriptionDisplay.length).toBe(0)
      const descriptionEdit = screen.getByLabelText('description-edit')
      expect(descriptionEdit.querySelector('textarea').value).toEqual(
        mockTask.description
      )
    })
  })

  describe('behaviors', () => {
    describe('edit operations', () => {
      const editAction = jest.spyOn(tasksSlice.actions, 'edit')

      beforeEach(() => renderIt(mockTask))

      it('should set edit.name = true when name has clicked', () => {
        const target = screen.getByLabelText('name-display')
        userEvent.click(target)

        expect(editAction).toHaveBeenCalledWith(mockTask.id)
      })

      it('should set edit.description = true when description has clicked', () => {
        const target = screen.getByLabelText('description-display')
        userEvent.click(target)

        expect(editAction).toHaveBeenCalledWith(mockTask.id)
      })
    })

    describe('update operations', () => {
      const task = { ...mockTask, edit: true }
      const updateThunk = jest.spyOn(TasksSlice, 'update')
      const showAction = jest.spyOn(tasksSlice.actions, 'show')

      it('should update the task when name has fixed', () => {
        renderIt({ ...mockTask, edit: true })
        const field = screen.getByLabelText('name-edit').querySelector('input')
        userEvent.type(field, ' updated')

        const btn = screen.getByLabelText('fix-button')
        userEvent.click(btn)

        expect(updateThunk).toHaveBeenCalledWith({
          ...task,
          name: `${task.name} updated`,
          edit: true,
        })
        expect(showAction).toHaveBeenCalledWith(task.id)
      })

      it('should update the task when description has fixed', () => {
        renderIt({ ...mockTask, edit: true })
        const field = screen
          .getByLabelText('description-edit')
          .querySelector('textarea')
        userEvent.type(field, ' updated')

        const btn = screen.getByLabelText('fix-button')
        userEvent.click(btn)

        expect(updateThunk).toHaveBeenCalledWith({
          ...task,
          description: `${task.description} updated`,
          edit: true,
        })
        expect(showAction).toHaveBeenCalledWith(task.id)
      })
    })

    describe('destroy operation', () => {
      const destroyThunk = jest.spyOn(TasksSlice, 'destroy')

      it('should destroy the Task when destroy button has clicked', () => {
        renderIt(mockTask)
        const btn = screen.getByLabelText('destroy-button')
        userEvent.click(btn)

        expect(destroyThunk).toHaveBeenCalledWith({ id: mockTask.id })
      })
    })
  })
})
