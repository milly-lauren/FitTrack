import {
    timestamp,
    db,
    firebaseAppAuth
} from './Firebase'

import { knightro } from '../Components/Resources'
import withFirebaseAuth from 'react-with-firebase-auth';

/*
    Use these whenever you want to get user information
    DO NOT use props to get user information
*/


export const getUserName = () => { return firebaseAppAuth.currentUser.displayName }
export const getEmail = () => { return firebaseAppAuth.currentUser.email }
export const getProfilePicUrl = () => { return firebaseAppAuth.currentUser.photoURL || knightro }
export const getPhoneNumber = () => { return !!firebaseAppAuth.currentUser.phoneNumber }
export const isEmailVerified = () => { return !!firebaseAppAuth.currentUser.emailVerified }

// saves messages to db under collectionName name
export const sendMessage = (collectionName, message) => {
    db.collection(collectionName).add({
        name: getUserName(),
        message: message,
        profilePicUrl: getProfilePicUrl(),
        timestamp: timestamp()
    }).then(() => {
        console.log('Sent message!')
    }).catch((error) => {
        console.error('Error: ', error)
    })
}

export const createActivity = (distanceValue, distanceUnit, hours, minutes, seconds, date_month, date_day, date_year, date_hour, date_minute, tags, title, description) => {
    db.collection('activities').add({
        name: getUserName(),
        profilePicUrl: getProfilePicUrl(),
        distanceValue,
        distanceUnit,
        hours,
        minutes,
        seconds,
        date_month,
        date_day,
        date_year,
        date_hour,
        date_minute,
        tags,
        title,
        description,
        timestamp: timestamp()
    }).then(() => {
        console.log('Activity successfully uploaded!')
    }).catch((error) => {
        console.error('Error: ', error)
    })
}

const deleteMessage = (id) => {
    const div = document.getElementById(id)
    if (div) {
        div.parentNode.removeChild(div)
    }
}