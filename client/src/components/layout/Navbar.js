import React, { Fragment, useContext } from 'react'
import { Collapse, Navbar, NavbarToggler, NavbarBrand, Nav, NavItem, NavLink } from 'reactstrap'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import AuthContext from '../../context/auth/authContext'
import ContactContext from '../../context/contact/contactContext'
import logo_border from '../../images/knighty_fit_logo.png'
import logo_no_border from '../../images/knighty_fit_logo_no_border.png'

const MyNavbar = ({ title, logo, isOpen }) => {
    const authContext = useContext(AuthContext)
    const contactContext = useContext(ContactContext)

    const { isAuthenticated, logout, user } = authContext
    const { clearContacts } = contactContext

    const toggle = () => {
        isOpen = !isOpen
    }

    const onLogout = () => {
        logout()
        clearContacts()
    }

    const authLinks = (
        <Fragment>
            <a onClick={onLogout} href='#!'>
                <i className='fas fa-sign-out-alt' />{' '}
                <span className='hide-sm'>Logout</span>
            </a>
        </Fragment>
    )

    const guestLinks = (
        <Fragment>
            <li>
            <Link to='/register'>Register</Link>
            </li>
            <li>
            <Link to='/login'>Login</Link>
            </li>
        </Fragment>
    )

    const headerStyle = {
        width: '4.5em',
        height: 'auto'
    }

    return (
        <div className='navbar bg-primary'>
            <h1><img style={headerStyle} src={logo_no_border} alt={title} /></h1>
            <ul>{isAuthenticated ? authLinks : guestLinks}</ul>
        </div>
    )
}

MyNavbar.propTypes = {
    title: PropTypes.string.isRequired,
    logo: PropTypes.string,
    isOpen: PropTypes.bool
}

MyNavbar.defaultProps = {
    title: 'Knightro Fit'
}

export default MyNavbar
