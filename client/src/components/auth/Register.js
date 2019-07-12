import React, { useState, useContext, useEffect } from 'react'
import { Link } from 'react-router-dom'
import AlertContext from '../../context/alert/alertContext'
import AuthContext from '../../context/auth/authContext'

/*
TODO: also make it nicer lol
*/

const Register = props => {
    const alertContext = useContext(AlertContext)
    const authContext = useContext(AuthContext)

    const { setAlert } = alertContext
    const { register, error, clearErrors, isAuthenticated } = authContext

    useEffect(() => {
        if (isAuthenticated) {
            props.history.push('/home')
        }

        if (error === 'User already exists') {
            setAlert(error, 'danger')
            clearErrors()
        }
        // eslint-disable-next-line
    }, [error, isAuthenticated, props.history])

    const [user, setUser] = useState({
        // name: '',
        email: '',
        password: ''
        // password2: ''
    })

    const {
        // name,
        email, password
        // password2
    } = user

    const onChange = e => setUser({ ...user, [e.target.name]: e.target.value })

    const onSubmit = e => {
        e.preventDefault()
        if (email === '' || password === '') {
            setAlert('Please enter all fields', 'danger')
        // } else if (password !== password2) {
        //     setAlert('Those passwords didn\'t match. Try again.', 'danger')
        } else {
            register({
                // name,
                email,
                password
            })
        }
    }

    return (
        <div className='form-container bg-primary-9'>
            <h2 className='text-light'>
                Create your Knighty Account
            </h2>
            <h4>
                to continue to Knighty
            </h4>
            <form onSubmit={onSubmit}>
                {/* Do name and all other personal info while creating profile*/}
                {/* <div className='form-group'>
                    <input
                        type='text'
                        name='name'
                        placeholder='Your Name'
                        value={name}
                        onChange={onChange}
                        required
                    />
                </div> */}
                <div className='form-group'>
                    <input
                        type='email'
                        name='email'
                        placeholder='Your Email'
                        value={email}
                        onChange={onChange}
                        required
                    />
                </div>
                {/* Todo: password show button */}
                <div className='form-group'>
                    <input
                        type='password'
                        name='password'
                        placeholder='Password'
                        value={password}
                        onChange={onChange}
                        required
                        minLength='7'
                    />
                </div>
                {/* <div className='form-group'>
                    <input
                        type='password'
                        name='password2'
                        placeholder='Confirm'
                        value={password2}
                        onChange={onChange}
                        required
                        minLength='7'
                    />
                </div> */}
                <div className='space-between'>
                    <Link to='/login' className='text-light'>Sign in instead</Link>
                    <input
                        type='submit'
                        value='Next'
                        className='btn btn-yellow btn-block'
                    />
                </div>
            </form>
        </div>
    )
}

export default Register
