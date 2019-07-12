import React, { Fragment } from 'react'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import Navbar from './components/layout/Navbar'
import Home from './components/pages/Home'
import Friends from './components/pages/Friends'
import Workouts from './components/pages/Workouts'
import Landing from './components/pages/Landing'
import Register from './components/auth/Register'
import Login from './components/auth/Login'
import Alerts from './components/layout/Alerts'
import PrivateRoute from './components/routing/PrivateRoute'

import ContactState from './context/contact/ContactState'
import AuthState from './context/auth/AuthState'
import AlertState from './context/alert/AlertState'
import setAuthToken from './utils/setAuthToken'
import './App.css'

if (localStorage.token) {
  setAuthToken(localStorage.token)
}

const App = () => {
    return (
        <AuthState>
            <ContactState>
            <AlertState>
                <Router>
                <Fragment>
                    <Navbar />
                    <div className='container'>
                        <Alerts />
                        <Switch>
                            <PrivateRoute exact path='/home' component={Home} />
                            <PrivateRoute exact path='/friends' component={Friends} />
                            <PrivateRoute exact path='/workouts' component={Workouts} />
                            <Route exact path='/' component={Landing} />
                            <Route exact path='/register' component={Register} />
                            <Route exact path='/login' component={Login} />
                        </Switch>
                    </div>
                </Fragment>
                </Router>
            </AlertState>
            </ContactState>
        </AuthState>
    )
}

export default App
