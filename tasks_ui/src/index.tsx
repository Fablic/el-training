import React, { useEffect, useState } from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import { store } from './state/store'
import App from './component/App'

const Index: React.FC = () => {
  return (
    <div>
      <Provider store={store}>
        <App />
      </Provider>
    </div>
  )
}

const appRoot = document.getElementById('app')
ReactDOM.render(<Index />, appRoot)
