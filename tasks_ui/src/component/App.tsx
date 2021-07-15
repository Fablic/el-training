import React, { useEffect, useState, useRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import Snackbar from '@material-ui/core/Snackbar'

import Tasks from './Tasks'
import AddForm from './AddForm'
import { tasksSlice } from '../state/tasksSlice'

const App: React.FC = (props) => {
  const notice = useSelector((s) => s.tasks.notice)
  const dispatch = useDispatch()

  return (
    <>
      <AddForm />
      <Tasks />
      <Snackbar
        open={notice != null}
        autoHideDuration={30000}
        onClose={() => dispatch(tasksSlice.actions.setNotice(null))}
        message={notice}
      />
    </>
  )
}
export default App
