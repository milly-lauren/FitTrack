// React
import React from 'react'
import {
    Form,
    FormGroup,
    Label,
    Input,
    Button
} from 'reactstrap'

// Firebase
import {
    withFirebaseAuth,
    providers,
    firebaseAppAuth
} from '../Firebase/Firebase'
import {
    getUserName,
    getProfilePicUrl,
    sendMessage
} from '../Firebase/functions'

// Components

class Dashboard extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            message: ''
        }
        this.onChange = this.onChange.bind(this)
    }

    // Use state as ground truth
    onChange(event) {
        const target = event.target
        this.setState(prevState => ({ ...prevState, [target.name]: target.value }))
    }

    render() {
        const { message } = this.state

        return (
            <div>
                <h1>Dashboard</h1>
                <Form onSubmit={(e) => {
                    e.preventDefault()  // Don't do whatever you were going to do before
                    sendMessage('message', message) // SEND IT, BRUH!
                    this.setState({ message: '' })  // Clear input
                }}>
                    <FormGroup>
                        <Label></Label>
                        <Input
                            name='message'
                            type='textarea'
                            value={message}
                            onChange={this.onChange}
                            required
                        />
                    </FormGroup>
                    <Button>Send</Button>
                </Form>
            </div>
        )
    }
}

export default withFirebaseAuth({
    providers,
    firebaseAppAuth
})(Dashboard)