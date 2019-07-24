import * as firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/firestore'
import config from './firebaseConfig'
import withFirebaseAuth from 'react-with-firebase-auth'

export { firebase, withFirebaseAuth }
export const firebaseApp = firebase.initializeApp(config)
export const db = firebase.firestore()
export const firebaseAppAuth = firebaseApp.auth()
export const providers = {
    googleProvider: new firebase.auth.GoogleAuthProvider(),
    facebookProvider: new firebase.auth.FacebookAuthProvider(),
    emailProvider: new firebase.auth.EmailAuthProvider()
}

// export const users = firebaseApp.firestore().app('users')
// export const usersWishlist = firebaseApp.firestore().app('usersWishlist')
// export const users = firebaseApp.firebase().ref().child('users');
// export const usersWishlist = firebaseApp.firebase().ref().child('usersWishlist');