import React, { useState, useContext, useEffect } from 'react'
import { Link } from 'react-router-dom'
import AuthContext from '../../context/auth/authContext'
import AlertContext from '../../context/alert/alertContext'

/*
TODO: make it nicer lol
*/


const Login = props => {
    const alertContext = useContext(AlertContext)
    const authContext = useContext(AuthContext)

    const { setAlert } = alertContext
    const { login, error, clearErrors, isAuthenticated } = authContext

    useEffect(() => {
        if (isAuthenticated) {
            props.history.push('/')
        }

        if (error === 'Invalid Credentials') {
            setAlert(error, 'danger')
            clearErrors()
        }
        // eslint-disable-next-line
    }, [error, isAuthenticated, props.history])

    const [user, setUser] = useState({
        email: '',
        password: ''
    })

    const { email, password } = user

    const onChange = e => setUser({ ...user, [e.target.name]: e.target.value })

    const onSubmit = e => {
        e.preventDefault()
        if (email === '' || password === '') {
            setAlert('Please fill in all fields', 'danger')
        } else {
            clearErrors()
            login({
                email,
                password
            })
        }
    }

    return (
        <div className='form-container bg-primary-9'>
            <h2 className='text-center text-light'>
                Sign in
            </h2>
            <h4 className='text-center'>
                to continue to Knighty
            </h4>
            <form onSubmit={onSubmit}>
                <div className='form-group'>
                    {/* <label htmlFor='email'>Email Address</label> */}
                    <input
                        type='email'
                        name='email'
                        value={email}
                        placeholder='Your email'
                        onChange={onChange}
                        required
                    />
                </div>
                <div className='form-group'>
                    {/* <label htmlFor='password'>Password</label> */}
                    <input
                        type='password'
                        name='password'
                        value={password}
                        placeholder='Password'
                        onChange={onChange}
                        required
                    />
                </div>
                <div className='space-between'>
                    <Link to='/register' className='text-light'>Create account</Link>
                    <input
                        type='submit'
                        value='Next'
                        className='btn btn-yellow btn-block'
                    />
                </div>
                {/* <input
                    type='submit'
                    value='Login'
                    className='btn btn-primary btn-block'
                /> */}
            </form>
        </div>
    )
}

export default Login
