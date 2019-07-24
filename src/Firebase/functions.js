import {
    db,
    firebaseAppAuth,
} from './Firebase'

import { knightro } from '../Components/Resources'
import { firestore } from 'firebase';

/*
    Use these whenever you want to get user information
    DO NOT use props to get user information
*/


export const getUserName = () => { return firebaseAppAuth.currentUser.displayName }
export const getEmail = () => { return firebaseAppAuth.currentUser.email }
export const getProfilePicUrl = () => { return firebaseAppAuth.currentUser.photoURL || knightro }
export const getPhoneNumber = () => { return !!firebaseAppAuth.currentUser.phoneNumber }
export const isEmailVerified = () => { return !!firebaseAppAuth.currentUser.emailVerified }

export const sendMessage = (collectionName, message) => {
    db.collection(collectionName).add({
        name: getUserName(),
        message: message,
        profilePicUrl: getProfilePicUrl()
    }).then(() => {
        console.log('Sent message!')
    }).catch((error) => {
        console.error('Error: ', error)
    })
}