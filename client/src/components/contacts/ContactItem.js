import React, { useContext } from 'react';
import PropTypes from 'prop-types';
import ContactContext from '../../context/contact/contactContext';

const ContactItem = ({ contact }) => {
    const contactContext = useContext(ContactContext);
    const { deleteContact, setCurrent, clearCurrent } = contactContext;

    const { _id, firstName, lastName, email, phone } = contact;

    const onDelete = () => {
        deleteContact(_id);
        clearCurrent();
    };

    return (
        <div className='card'>
            {firstName}{'  '}
            {lastName && (lastName)}
            <br />
            {email && (email)}
            <br />
            {phone && (phone)}
            <div className='flex-right'>
                <button
                    className='btn btn-dark btn-circle btn-sm'
                    onClick={() => setCurrent(contact)}
                >Edit</button>
                <button className='btn btn-danger btn-circle btn-sm' onClick={onDelete}>X</button>
            </div>
        </div>
    );


    // return (
    //     <div className='card bg-light'>
    //         <h3 className='text-primary text-left'>
    //             {firstName}{' '}
    //         </h3>
    //         <h3 className='text-primary text-left'>
    //             {lastName}{' '}
    //         </h3>
    //         <ul className='list'>
    //             {email && (
    //                 <li>
    //                     <i className='fas fa-envelope-open' /> {email}
    //                 </li>
    //             )}
    //             {phone && (
    //                 <li>
    //                     <i className='fas fa-phone' /> {phone}
    //                 </li>
    //             )}
    //         </ul>
    //         <p>
    //             <button
    //                 className='btn btn-dark btn-circle btn-sm'
    //                 onClick={() => setCurrent(contact)}
    //             >
    //                 Edit
    //     </button>
    //             <button className='btn btn-danger btn-circle btn-sm' onClick={onDelete}>
    //                 X
    //     </button>
    //         </p>
    //     </div>
    // );
};

ContactItem.propTypes = {
    contact: PropTypes.object.isRequired
};

export default ContactItem;
