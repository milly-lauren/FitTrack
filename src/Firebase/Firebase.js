import * as firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/firestore'
// import config from './firebaseConfig'
import withFirebaseAuth from 'react-with-firebase-auth'


const config = {
    apiKey: "AIzaSyAlebn1Evo-1HVbLm2-lmLlhuDRVv50guo",
    authDomain: "fitnessapp-f577d.firebaseapp.com",
    databaseURL: "https://fitnessapp-f577d.firebaseio.com",
    projectId: "fitnessapp-f577d",
    storageBucket: "fitnessapp-f577d.appspot.com",
    messagingSenderId: "264673815869",
    appId: "1:264673815869:web:4d099c9f29674a0f"
}

firebase.initializeApp(config)
const db = firebase.firestore()
const timestamp = firebase.firestore.FieldValue.serverTimestamp

const firebaseAppAuth = firebase.auth()
const providers = {
    googleProvider: new firebase.auth.GoogleAuthProvider(),
    facebookProvider: new firebase.auth.FacebookAuthProvider(),
    emailProvider: new firebase.auth.EmailAuthProvider()
}

export {
    db,
    firebaseAppAuth,
    withFirebaseAuth,
    providers,
    timestamp
}


// export const users = firebaseApp.firestore().app('users')
// export const usersWishlist = firebaseApp.firestore().app('usersWishlist')
// export const users = firebaseApp.firebase().ref().child('users');
// export const usersWishlist = firebaseApp.firebase().ref().child('usersWishlist');