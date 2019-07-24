// React
import React from 'react'
import {
    DropdownItem,
    DropdownMenu,
    DropdownToggle,
    Form,
    FormGroup,
    Label,
    Input,
    InputGroup,
    InputGroupAddon,
    InputGroupButtonDropdown,
    Button
} from 'reactstrap'

// Firebase
import {
    withFirebaseAuth,
    providers,
    firebaseAppAuth
} from '../Firebase/Firebase'
import {
    sendMessage
} from '../Firebase/functions'

// Components

class AddActivity extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            userInput: {
                distanceValue: '',
                distanceUnit: 'miles',
                hours: 0,
                minutes: 0,
                seconds: 0
            },
            isDistanceOpen: false
        }
        this.onChange = this.onChange.bind(this)
        this.onChangeCustom = this.onChangeCustom.bind(this)
        this.toggleDistance = this.toggleDistance.bind(this)
    }

    toggleDistance() { this.setState({ isDistanceOpen : !this.state.isDistanceOpen })}

    // Use state as ground truth
    onChange(event) {
        const target = event.target
        this.setState(prevState => ({ userInput: { ...prevState, [target.name]: target.value} }))
    }

    onChangeCustom(name, value) {
        this.setState({ userInput: { [name]: value } })
    }

    render() {
        const {
            userInput: {
                distanceValue,
                distanceUnit,
                hours,
                minutes,
                seconds
            },
            isDistanceOpen
        } = this.state

        return (
            <div>
                <h1>Manual Entry</h1>
                <Form>
                    {/* Distance form group */}
                    <FormGroup>
                        <Label for='distance'>Distance</Label>
                        <InputGroup id='distance'>
                            <Input
                                name='distanceValue'
                                value={distanceValue}
                                placeholder='0'
                                onChange={this.onChange}
                                required
                            />
                            <InputGroupButtonDropdown addonType='append' type='select' name='distanceUnit' isOpen={isDistanceOpen} toggle={this.toggleDistance}>
                                <DropdownToggle caret>{distanceUnit}</DropdownToggle>
                                <DropdownMenu>
                                    {['kilometer', 'meters', 'miles', 'yards'].map(value => {
                                        if (value !== distanceUnit) { return <DropdownItem onClick={() => this.onChangeCustom('distanceUnit', value)}>{value}</DropdownItem> }
                                    })}
                                </DropdownMenu>
                            </InputGroupButtonDropdown>
                        </InputGroup>
                    </FormGroup>

                    {/* Duration form group */}
                    <FormGroup>
                        <InputGroup>
                            <Input
                                name='minutes'
                                onChange={this.onChange}
                                required
                            />
                            <InputGroupAddon addonType='append'>hr</InputGroupAddon>
                        </InputGroup>
                        <InputGroup>
                            <Input
                                name='seconds'
                                onChange={this.onChange}
                                required
                            />
                            <InputGroupAddon addonType='append'>min</InputGroupAddon>
                        </InputGroup>
                        <InputGroup>
                            <Input
                                name='seconds'
                                onChange={this.onChange}
                                required
                            />
                            <InputGroupAddon addonType='append'>s</InputGroupAddon>
                        </InputGroup>
                    </FormGroup>
                    <Button>Add activity</Button>
                </Form>
                <Button>Cancel</Button>
            </div>
        )
    }
}

export default withFirebaseAuth({
    providers,
    firebaseAppAuth
})(AddActivity)