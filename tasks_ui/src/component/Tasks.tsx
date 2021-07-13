import React, { useEffect, useState, useRef } from 'react'
import { makeStyles } from '@material-ui/core/styles'

import { index, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import Task from './Task'

const useStyles = makeStyles({})

const Tasks: React.FC = (props) => {
  const tasks = useSelector((s) => s.tasks.tasks)
  const dispatch = useDispatch()

  useEffect(() => dispatch(index()), [])

  return (
    <ol>
      {tasks.map((t) => (
        <li key={t.id}>
          <Task task={t} />
        </li>
      ))}
    </ol>
  )
}
export default Tasks
