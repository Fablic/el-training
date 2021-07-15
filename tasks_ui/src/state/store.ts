import { combineReducers, configureStore } from '@reduxjs/toolkit'
import { tasksSlice } from './tasksSlice'

const reducer = combineReducers({
  tasks: tasksSlice.reducer,
})

export const store = configureStore({
  reducer,
})
