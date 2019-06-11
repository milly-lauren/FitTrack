import React, { useContext } from 'react';
import PropTypes from 'prop-types';
import ContactContext from '../../context/contact/contactContext';

const ContactItem = ({ contact }) => {
    const contactContext = useContext(ContactContext);
    const { deleteContact, clearCurrent } = contactContext;

    const { _id, firstName, lastName, email, phone } = contact;

    const onDelete = () => {
        deleteContact(_id);
        clearCurrent();
    };

    const formatPhoneNumber = (phoneNumberString) => {
        const cleaned = ('' + phoneNumberString).replace(/\D/g, '')
        const match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/)
        if (match) {
          return '(' + match[1] + ') ' + match[2] + '-' + match[3]
        }
        return phoneNumberString
      }

    return (
        <div className='card'>
            <span>{firstName}{'  '}
            {lastName && (lastName)}</span>
            <br />
            {email && (email)}
            <br />
            {phone && (formatPhoneNumber(phone))}
            <div className='flex-right'>
                <button
                    className='btn btn-danger btn-circle btn-sm'
                    onClick={onDelete}
                >X</button>
            </div>
        </div>
    );
};

ContactItem.propTypes = {
    contact: PropTypes.object.isRequired
};

export default ContactItem;
