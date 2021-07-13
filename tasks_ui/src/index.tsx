import React, { useEffect, useState } from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import { store } from './state/store'
import AddForm from './component/AddForm'
import Tasks from './component/Tasks'

const App: React.FC = () => {
  return (
    <div>
      <Provider store={store}>
        <AddForm />
        <Tasks />
      </Provider>
    </div>
  )
}

const appRoot = document.getElementById('app')
ReactDOM.render(<App />, appRoot)
