import React, { useState, useContext, useEffect } from 'react'
import ContactContext from '../../context/contact/contactContext'
import AuthContext from '../../context/auth/authContext'

const ContactForm = () => {
    const contactContext = useContext(ContactContext)
    const authContext = useContext(AuthContext)

    const { logout } = authContext
    const { addContact, clearCurrent, current, clearContacts } = contactContext

    const onLogout = () => {
        logout()
        clearContacts()
    }

    useEffect(() => {
        if (current !== null) {
            setContact(current)
        } else {
            setContact({
                firstName: '',
                lastName: '',
                email: '',
                phone: ''
            })
        }
    }, [contactContext, current])

    const [contact, setContact] = useState({
        firstName: '',
        lastName: '',
        email: '',
        phone: ''
    })

    const { firstName, lastName, email, phone } = contact


    const onChange = event => {
        setContact({ ...contact, [event.target.name]: event.target.value })
    }

    const onSubmit = e => {
        e.preventDefault()
        addContact(contact)
        clearAll()
    }

    const clearAll = () => {
        clearCurrent()
    }

    return (
        <form onSubmit={onSubmit}>
            <h2 className='text-light'>New Contact</h2>
            <input
                type='text'
                placeholder='First name'
                name='firstName'
                value={firstName}
                onChange={onChange}
            />
            <input
                type='text'
                placeholder='Last name'
                name='lastName'
                value={lastName}
                onChange={onChange}
            />
            <input
                type='email'
                placeholder='Email'
                name='email'
                value={email}
                onChange={onChange}
            />
            <input
                type='text'
                placeholder='Phone'
                name='phone'
                value={phone}
                onChange={onChange}
            />
            <div>
                <input
                    type='submit'
                    value='New Contact'
                    className='btn btn-yellow btn-block'
                />
            </div>
        </form>
    )
}

export default ContactForm
