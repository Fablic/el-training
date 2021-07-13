import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'

import { store, history } from '../state/store'
import AddForm from './AddForm'
import { tasksSlice } from '../state/tasksSlice'
import * as TasksSlice from '../state/tasksSlice'
import * as ReactRedux from 'react-redux'

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())

const renderIt = () => {
  render(
    <Provider store={store}>
      <AddForm />
    </Provider>
  )
}

const mockTask = {
  id: 1,
  name: 'task name',
  description: 'task description',
  edit: { name: false, description: false },
}

describe('AddForm', () => {
  afterEach(() => jest.clearAllMocks())

  describe('behaviors', () => {
    beforeEach(() => renderIt())

    const createThunk = jest.spyOn(TasksSlice, 'create')

    it('should create a task with input content', () => {
      const input = screen
        .getByLabelText('add-name-input')
        .querySelector('input')
      userEvent.type(input, mockTask.name)
      const button = screen.getByLabelText('add-button')
      userEvent.click(button)

      expect(createThunk).toHaveBeenCalledWith({ name: mockTask.name })
      expect(input.value).toEqual('')
    })

    it('shouldnt create a task with blank content', () => {
      const button = screen.getByLabelText('add-button')
      userEvent.click(button)

      expect(createThunk).not.toHaveBeenCalledWith({ name: mockTask.name })
    })
  })
})
