import React, { useEffect, useState, useRef } from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Paper from '@material-ui/core/Paper'
import TextField from '@material-ui/core/TextField'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import { useForm, Controller } from 'react-hook-form'

import { create, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

const useStyles = makeStyles({
  container: {
    margin: '10px',
    padding: '10px',
  },
  input: {
    width: 'calc(100% - 48px)',
  },
})

const AddForm: React.FC = (props) => {
  const nameRef = useRef()
  const { control, setValue } = useForm()

  const dispatch = useDispatch()

  const classes = useStyles()

  const onAddClick = () => {
    const name = nameRef.current.value
    dispatch(create({ name }))
    setValue('name', '')
  }

  return (
    <Paper className={classes.container}>
      <Controller
        name="name"
        control={control}
        defaultValue={''}
        render={({ field }) => (
          <TextField
            {...field}
            aria-label="add-name-input"
            className={classes.input}
            label="Name"
            inputRef={nameRef}
          />
        )}
      />

      <IconButton aria-label="add-button" onClick={onAddClick}>
        <Icon>add</Icon>
      </IconButton>
    </Paper>
  )
}
export default AddForm
