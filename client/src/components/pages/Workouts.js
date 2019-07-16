import React, { useContext, useEffect } from 'react'
import AuthContext from '../../context/auth/authContext'
import Calender from '../workouts/Calender'
import Test1 from '../workouts/Monthly'
const Workouts = () => {
    const authContext = useContext(AuthContext)

    // shutup
    // eslint-disable-next-line
    useEffect(() => {
        authContext.loadUser()
    }, [])

    return (
        <div>
        <Test1/>
        </div>
    )
}

export default Workouts
