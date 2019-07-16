import React, { useState, useContext, useEffect } from 'react'
import { Link } from 'react-router-dom'





const Calender = props => {

    const onSubmit = e => {
      props.history.push('/monthly')
    }

    return (
        <div className='calender-container bg-primary-9'>

          <h1 class='text-center text-light'>Select a Month</h1>
          <div className='rowA'>
            <input type='submit' value='JAN' className='month-btn'/>
            <input type='submit' value='FEB' className='month-btn'/>
            <input type='submit' value='MAR' className='month-btn'/>
            <input type='submit' value='APR' className='month-btn'/>
            <input type='submit' value='MAY' className='month-btn'/>
            <input type='submit' value='JUN' className='month-btn'/>
          </div>
          <div class='rowB'>
            <input type='submit' value='JUL' className='month-btn'/>
            <input type='submit' value='AUG' className='month-btn'/>
            <input type='submit' value='SEP' className='month-btn'/>
            <input type='submit' value='OCT' className='month-btn'/>
            <input type='submit' value='NOV' className='month-btn'/>
            <input type='submit' value='DEC' className='month-btn'/>
          </div>

        </div>
    )
}

export default Calender
