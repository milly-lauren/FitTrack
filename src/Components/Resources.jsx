// React
import React from 'react'
import {
    Button
} from 'reactstrap'
import facebookLogo from '../media/facebookLogo.png'
import knightyFit from '../media/knighty_fit_logo_no_border.png'
import knightyFitBorder from '../media/knighty_fit_logo.png'
import knightro from '../media/knightro.png'
const googleLogo = 'https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png'

// Media
export {
    googleLogo,
    facebookLogo,
    knightyFit,
    knightyFitBorder,
    knightro
}

// Style components
export const StyledButton = ({color='dark', signIn, logo, text}) => {
    return <Button className='d-flex align-items-center'
        color={color} onClick={signIn}>
        <img width='25rem' src={logo} alt='' />
        <span className='w-100'>{text}</span>
    </Button>
}
