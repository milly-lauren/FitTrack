// React
import React from 'react'
import {
    Button,
    Label,
    Input,
    InputGroup,
    InputGroupAddon,
    InputGroupText
} from 'reactstrap'
import facebookLogo from '../media/facebookLogo.png'
import knightyFit from '../media/knighty_fit_logo_no_border.png'
import knightyFitBorder from '../media/knighty_fit_logo.png'
import knightro from '../media/knightro.png'
import sword from '../media/sword.svg'
const googleLogo = 'https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png'

// Media
export {
    googleLogo,
    facebookLogo,
    knightyFit,
    knightyFitBorder,
    knightro,
    sword
}

// Style components
export const StyledButton = ({color='dark', signIn, logo, text}) => {
    return <Button className='d-flex align-items-center'
        color={color} onClick={signIn}>
        <img width='25rem' src={logo} alt='' />
        <span className='w-100'>{text}</span>
    </Button>
}


export class CustomDatePickerButton extends React.Component {
    render() {
        return (
            <Button secondary color='secondary' style={{backgroundColor: 'black', border: '1px solid black'}} onClick={(e) => {
                e.preventDefault()
                this.props.onClick()
            }}>
                {this.props.value}
            </Button>
        )
    }
}

export const CustomTag = ({checked, tag, onChange:onChangeTags}) => {
    return (
        <InputGroupText style={{border: '1px solid black', backgroundColor: 'black', color: 'white'}}>
            <Input addon type='checkbox' checked={checked} name={tag} onChange={onChangeTags} />
            <div className='ml-2'>{tag}</div>
        </InputGroupText>
    )
}