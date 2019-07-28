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
export const getUserId = () => { return firebaseAppAuth.currentUser.uid }

export const createProfile = (firstName, lastName, birthMonth, birthDay, birthYear, gender) => {
    db.collection('users').doc(getUserId()).set({
        name: getUserName(),
        profilePicUrl: getProfilePicUrl(),
        firstName,
        lastName,
        birthMonth,
        birthDay,
        birthYear,
        gender,
        timestamp: timestamp()
    }).then(() => {
        console.log('Successfully created a new profile!')
    }).catch((error) => {
        console.error('Error: ', error)
    })
}

export const createActivity = (distanceValue, distanceUnit, hours, minutes, seconds, date_month, date_day, date_year, date_hour, date_minute, tags, title, description) => {
    db.collection('users').doc(getUserId()).collection('activities').add({
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