import React, { Fragment, useContext } from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import AuthContext from '../../context/auth/authContext';
import ContactContext from '../../context/contact/contactContext';

const Navbar = ({ title, icon }) => {
    const authContext = useContext(AuthContext);
    const contactContext = useContext(ContactContext);

    const { isAuthenticated, logout, user } = authContext;
    const { clearContacts } = contactContext;

    const onLogout = () => {
        logout();
        clearContacts();
    };

    if (isAuthenticated) {
        return (
            // <div className='navbar bg-primary'>
            <div>
                {/* <h1>
                    <i className={icon} /> {title}
                </h1> */}
                <ul>
                    <li>
                        Hello {user && user.name}
                    </li>
                    <li>
                        <a className='btn btn-dark btn-circle btn-sm' onClick={onLogout} href='#!'>
                            {/* <i className='fas fa-sign-out-alt' />{' '} */}
                            <span className=''>Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        );
    } else {
        return null
    }

};

Navbar.propTypes = {
    title: PropTypes.string.isRequired,
    icon: PropTypes.string
};

Navbar.defaultProps = {
    title: 'Contact Keeper',
    icon: 'fas fa-id-card-alt'
};

export default Navbar;
