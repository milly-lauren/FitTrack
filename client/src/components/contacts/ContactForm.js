import React, { useState, useContext, useEffect } from 'react';
import ContactContext from '../../context/contact/contactContext';
import AuthContext from '../../context/auth/authContext';

const ContactForm = () => {
    const contactContext = useContext(ContactContext);
    const authContext = useContext(AuthContext);

    const { logout } = authContext;
    const { addContact, updateContact, clearCurrent, current, clearContacts } = contactContext;

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

    const onChange = e =>
        setContact({ ...contact, [e.target.name]: e.target.value });

    const onSubmit = e => {
        e.preventDefault();
        if (current === null) {
            addContact(contact);
        } else {
            updateContact(contact);
        }
        clearAll();
    };

    const clearAll = () => {
        clearCurrent();
    };

    return (
        <form onSubmit={onSubmit}>
            <div className='space-between'>
                <h2 className='text-primary'>
                    {current ? 'Edit Contact' : 'New Contact'}
                </h2>
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
                    value={current ? 'Update Contact' : 'New Contact'}
                    className='btn btn-primary btn-block'
                />
            </div>
            {current && (
                <div>
                    <button className='btn btn-light btn-block' onClick={clearAll}>
                        Cancel
          </button>
                </div>
            )}
        </form>
    );
};

export default ContactForm;
