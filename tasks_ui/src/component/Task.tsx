import React, { useEffect, useState, useRef } from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'
import CardActions from '@material-ui/core/CardActions'
import CardContent from '@material-ui/core/CardContent'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'

import { update, destroy, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

const useStyles = makeStyles({
  input: {
    width: '100%',
  },
})

const Task: React.FC = (props) => {
  const { task } = props
  const classes = useStyles()

  const nameRef = useRef()
  const descriptionRef = useRef()

  const dispatch = useDispatch()

  const onDestroyClick = () => {
    dispatch(destroy({ id: task.id }))
  }

  const fixValues = () => {
    dispatch(
      update({
        ...task,
        name: nameRef.current.value,
        description: descriptionRef.current.value,
      })
    )
  }

  return (
    <Card className={classes.root}>
      <CardContent>
        {!task.edit && (
          <>
            <Typography
              variant="h5"
              component="h2"
              aria-label="name-display"
              onClick={() => dispatch(tasksSlice.actions.edit(task.id))}
            >
              {task.name}
            </Typography>
            <Typography
              variant="body2"
              component="div"
              aria-label="description-display"
              onClick={() => dispatch(tasksSlice.actions.edit(task.id))}
            >
              {task.description}
            </Typography>
          </>
        )}
        {task.edit && (
          <>
            <div>
              <TextField
                aria-label="name-edit"
                label="Name"
                className={classes.input}
                defaultValue={task.name}
                inputRef={nameRef}
              />
            </div>
            <div>
              <TextField
                aria-label="description-edit"
                label="Description"
                className={classes.input}
                defaultValue={task.description}
                inputRef={descriptionRef}
                multiline
              />
            </div>
            <IconButton
              aria-label="fix-button"
              onClick={() => {
                fixValues()
                dispatch(tasksSlice.actions.show(task.id))
              }}
            >
              <Icon>done</Icon>
            </IconButton>
          </>
        )}
      </CardContent>

      <CardActions>
        <IconButton onClick={onDestroyClick} aria-label="destroy-button">
          <Icon>delete</Icon>
        </IconButton>
      </CardActions>
    </Card>
  )
}

export default Task
