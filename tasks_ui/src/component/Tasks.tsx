import React, { useEffect, useState, useRef } from 'react'
import { makeStyles } from '@material-ui/core/styles'

import { index, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import Task from './Task'

const useStyles = makeStyles({
  ol: {
    padding: 0,
  },
  li: {
    listStyleType: 'none',
    margin: '10px',
  },
})

const Tasks: React.FC = (props) => {
  const tasks = useSelector((s) => s.tasks.tasks)
  const dispatch = useDispatch()

  const classes = useStyles()

  useEffect(() => dispatch(index()), [])

  return (
    <ol className={classes.ol}>
      {tasks.map((t) => (
        <li key={t.id} className={classes.li}>
          <Task task={t} />
        </li>
      ))}
    </ol>
  )
}
export default Tasks
