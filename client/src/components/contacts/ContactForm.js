import React, { useState, useContext, useEffect } from 'react';
import ContactContext from '../../context/contact/contactContext';
import AuthContext from '../../context/auth/authContext';

const ContactForm = () => {
    const contactContext = useContext(ContactContext);
    const authContext = useContext(AuthContext);

    const { logout } = authContext;
    const { addContact, clearCurrent, current, clearContacts } = contactContext;

    const onLogout = () => {
        logout();
        clearContacts();
    };

    useEffect(() => {
        if (current !== null) {
            setContact(current);
        } else {
            setContact({
                firstName: '',
                lastName: '',
                email: '',
                phone: ''
            });
        }
    }, [contactContext, current]);

    const [contact, setContact] = useState({
        firstName: '',
        lastName: '',
        email: '',
        phone: ''
    });

    const { firstName, lastName, email, phone } = contact;

    const onChange = event => {
        console.log(event.target.name)
        setContact({ ...contact, [event.target.name]: event.target.value });
    }

    const onSubmit = e => {
        e.preventDefault();
        console.log(contact)
        addContact(contact);
        clearAll();
    };

    const clearAll = () => {
        clearCurrent();
    };

    return (
        <form onSubmit={onSubmit}>
            <div className='space-between'>
                <h2 className='text-primary'>New Contact</h2>
                <a className='btn btn-dark btn-circle btn-sm' onClick={onLogout} href='#!'>
                    <span className=''>Logout</span>
                </a>
            </div>
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
                    className='btn btn-primary btn-block'
                />
            </div>
        </form>
    );
};

export default ContactForm;
