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

const useStyles = makeStyles({})

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
        {!task.edit.name && (
          <Typography
            variant="h5"
            component="h2"
            aria-label="name-display"
            onClick={() => dispatch(tasksSlice.actions.editName(task.id))}
          >
            {task.name}
          </Typography>
        )}
        {task.edit.name && (
          <>
            <TextField
              aria-label="name-edit"
              label="Name"
              defaultValue={task.name}
              inputRef={nameRef}
            />
            <IconButton
              aria-label="name-fix-button"
              onClick={() => {
                fixValues()
                dispatch(tasksSlice.actions.showName(task.id))
              }}
            >
              <Icon>done</Icon>
            </IconButton>
          </>
        )}

        {!task.edit.description && (
          <Typography
            variant="body2"
            component="div"
            aria-label="description-display"
            onClick={() =>
              dispatch(tasksSlice.actions.editDescription(task.id))
            }
          >
            {task.description}
          </Typography>
        )}
        {task.edit.description && (
          <>
            <TextField
              aria-label="description-edit"
              label="Description"
              defaultValue={task.description}
              inputRef={descriptionRef}
              multiline
            />
            <IconButton
              aria-label="description-fix-button"
              onClick={() => {
                fixValues()
                dispatch(tasksSlice.actions.showDescription(task.id))
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
