import React, { useContext, useEffect } from 'react'
import AuthContext from '../../context/auth/authContext'

const Friends = () => {
    const authContext = useContext(AuthContext)

    // shutup
    // eslint-disable-next-line
    useEffect(() => {
        authContext.loadUser()
    }, [])

    return (
        <h1 className='text-light'>Friends</h1>
    )
}

export default Friends
