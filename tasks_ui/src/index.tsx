import React, { useEffect, useState } from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { ConnectedRouter } from 'connected-react-router'
import { Route, Switch } from 'react-router-dom'

const App: React.FC = () => {
  return <>hogehoge</>
}

const appRoot = document.getElementById('app')
ReactDOM.render(<App />, appRoot)
