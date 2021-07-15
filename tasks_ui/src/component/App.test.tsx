import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'

import { store, history } from '../state/store'
import App from './App'
import { tasksSlice } from '../state/tasksSlice'
import * as TasksSlice from '../state/tasksSlice'
import * as ReactRedux from 'react-redux'

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())

const renderIt = () => {
  render(
    <Provider store={store}>
      <App />
    </Provider>
  )
}

const setMockState = (notice) => {
  const mockState = {
    tasks: {
      tasks: [],
      notice,
    },
  }

  jest
    .spyOn(ReactRedux, 'useSelector')
    .mockImplementation((selector) => selector(mockState))
}

describe('App', () => {
  it('should show notice when it exists', () => {
    const notice = 'hoge message'
    setMockState(notice)
    renderIt()

    screen.getByText(notice)
  })
})
