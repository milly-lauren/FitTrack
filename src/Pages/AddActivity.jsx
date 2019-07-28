// React
import React from 'react'
import {
    DropdownItem,
    DropdownMenu,
    DropdownToggle,
    Form,
    Label,
    Input,
    InputGroup,
    InputGroupAddon,
    InputGroupButtonDropdown,
    Button,
    Container,
    Row,
    Col,
    InputGroupText
} from 'reactstrap'
import DatePicker from 'react-datepicker'
import { Link, Redirect } from 'react-router-dom'

// Firebase
import {
    withFirebaseAuth,
    providers,
    firebaseAppAuth
} from '../Firebase/Firebase'
import {
    createActivity
} from '../Firebase/functions'

// Components
import {
    CustomDatePickerButton,
    CustomTag
} from '../Components/Resources'

// Style
import 'react-datepicker/dist/react-datepicker.css'

class AddActivity extends React.Component {
    constructor(props) {
        super(props)

        // Round down to 30 min interval and 1 hour before current time
        const newDate = new Date()
        newDate.setMinutes(newDate.getMinutes() - newDate.getMinutes()%30)
        newDate.setHours(newDate.getHours()-1)
        const newTime = (newDate.getHours() === 0 ? '12' : (newDate.getHours() > 12 ? newDate.getHours()-12 : newDate.getHours()))
            + ':' + newDate.getMinutes().toString().padStart(2,'0') + (newDate.getHours() >= 12 ? ' PM' : ' AM')

        this.state = {
            userInput: {
                distanceValue: '',
                distanceUnit: 'miles',
                hours: '01',
                minutes: '00',
                seconds: '00',
                date: newDate,
                time: newTime,
                tags: [],
                title: '',
                description: ''

            },
            isDistanceOpen: false,
            isRedirect: false
        }

        this.onChange = this.onChange.bind(this)
        this.onChangeDate = this.onChangeDate.bind(this)
        this.onChangeUnits = this.onChangeUnits.bind(this)
        this.onChangeTags = this.onChangeTags.bind(this)
        this.toggleDistance = this.toggleDistance.bind(this)
        this.redirect = this.redirect.bind(this)
    }

    toggleDistance() { this.setState({ isDistanceOpen : !this.state.isDistanceOpen })}

    // Use state as ground truth
    onChange(event) {
        const target = event.target
        this.setState(prevState => ({ userInput: { ...prevState.userInput, [target.name]: target.value }}))
    }
    onChangeDate(newDate) {
        this.setState(prevState => ({ userInput: { ...prevState.userInput, date: newDate }}))
    }
    
    onChangeUnits(value) {
        this.setState(prevState => ({ userInput: { ...prevState.userInput, distanceUnit: value }}))
    }

    onChangeTags(event) {
        const target = event.target
        let newTags = this.state.userInput.tags
        if (newTags && newTags.includes(target.name)) {
            newTags = newTags.filter(item => { return item !== target.name})
        } else {
            newTags.push(target.name)
        }
        this.setState(prevState => ({ userInput: { ...prevState.userInput, tags: newTags }}))
    }

    redirect() {
        this.setState({isRedirect: true})
    }

    render() {
        const {
            userInput: {
                distanceValue,
                distanceUnit,
                hours,
                minutes,
                seconds,
                date,
                time,
                tags,
                title,
                description
            },
            isDistanceOpen,
            isRedirect
        } = this.state

        if (isRedirect) {
            return <Redirect to='/dashboard' />
        }

        const timeGenerator = () => {
            let A = {}
            for (let hh = 0; hh <= 23; hh++) {
                for (let mm = 0; mm <= 30; mm+=30) {
                    const timeString = (hh === 0 ? '12' : (hh > 12 ? hh-12 : hh))
                    + ':' + mm.toString().padStart(2,'0') + (hh >= 12 ? ' PM' : ' AM')
                    A[timeString] = [hh,mm]
                }
            }
            return A
        }

        const times = timeGenerator()
        return (
            <Container className='mb-4 cmw'>
                <h1 style={{color: 'black'}}>Manual Entry</h1>
                <Form onSubmit={e => {
                    e.preventDefault()  // Don't do whatever you were going to do before
                    
                    let newDistanceValue = distanceValue
                    if (newDistanceValue.indexOf('.') !== -1) {
                        const arr = newDistanceValue.split('.')
                        newDistanceValue = arr[0] + '.' + arr[1].padEnd(2,'0')
                    } else {
                        newDistanceValue = newDistanceValue + '.00'
                    }
                    const unitsShorthand = {'kilometer': 'km', 'meters': 'm', 'miles': 'mi', 'yards': 'yd'}

                    createActivity(
                        newDistanceValue,
                        unitsShorthand[distanceUnit],
                        hours,
                        minutes,
                        seconds,
                        date.getMonth(),
                        date.getDate(),
                        date.getFullYear(),
                        // date.getHours(),
                        // date.getMinutes(),
                        times[time][0],
                        times[time][1],
                        tags,
                        title ? title : 'Afternoon Run',
                        description
                    ) // send it
                    this.redirect() 
                }}>
                    <Row>
                        <Col xs='12' md='6' lg='4' className='mt-4'>
                            <Label for='distance'>Distance</Label>
                            <InputGroup id='distance'>
                                <Input
                                    name='distanceValue'
                                    value={distanceValue}
                                    className='text-center'
                                    style={{border: '1px solid black'}}
                                    onChange={this.onChange}
                                    required
                                />
                                <InputGroupButtonDropdown addonType='append' type='select' name='distanceUnit' isOpen={isDistanceOpen} toggle={this.toggleDistance}>
                                    <DropdownToggle style={{backgroundColor: 'black', border: '1px solid black'}} caret>{distanceUnit}</DropdownToggle>
                                    <DropdownMenu>
                                        {['kilometer', 'meters', 'miles', 'yards'].map(unit => {
                                            if (unit !== distanceUnit) { return <DropdownItem onClick={() => this.onChangeUnits(unit)}>{unit}</DropdownItem> }
                                        })}
                                    </DropdownMenu>
                                </InputGroupButtonDropdown>
                            </InputGroup>
                        </Col>
                        <Col xs='12' md='6' lg='4' className='mt-4'>
                            <Label for='dateandtime'>Date &amp; Time</Label>
                            <InputGroup id='dateandtime'>
                                <DatePicker
                                    customInput={<CustomDatePickerButton />}
                                    selected={date}
                                    onChange={this.onChangeDate}
                                />
                                {/* <DatePicker
                                    customInput={<CustomDatePickerButton />}
                                    selected={date}
                                    onChange={this.onChangeDate}
                                    showTimeSelect
                                    showTimeSelectOnly
                                    timeIntervals={30}
                                    dateFormat='h:mm aa'
                                />   */}
                                <select required onChange={this.onChange} name='time' className='custom-select rounded text-white' style={{ maxWidth: '110px', backgroundColor: 'black', border: '1px solid black'}}>
                                    {Object.keys(times).map((t) => {                                        
                                        if (t === time) {
                                            return <option selected value={t}>{t}</option>
                                        } else {
                                            return <option value={t}>{t}</option>
                                        }
                                    })}
                                </select>
                            </InputGroup>
                        </Col>
                        <Col xs='12' md='12' lg='4' className='mt-4'>
                            <Label for='duration'>Duration</Label>
                            <InputGroup className='d-flex flex-row flex-wrap flex-sm-nowrap' id='duration'>
                                <InputGroup style={{maxWidth: '100px'}}>
                                    <Input
                                        name='hours'
                                        value={hours}
                                        className='text-right'
                                        onChange={this.onChange}
                                        style={{border: '1px solid black'}}
                                    />
                                    <InputGroupAddon addonType='append'>
                                        <InputGroupText style={{padding: '0 .75rem', color: 'white', backgroundColor: 'black', border: '1px solid black'}}>hr</InputGroupText>
                                    </InputGroupAddon>
                                </InputGroup>
                                <InputGroup style={{maxWidth: '100px'}}>
                                    <Input
                                        name='minutes'
                                        value={minutes}
                                        className='text-right'
                                        onChange={this.onChange}
                                        style={{border: '1px solid black'}}
                                    />
                                    <InputGroupAddon addonType='append'>
                                        <InputGroupText className='px-2' style={{color: 'white', backgroundColor: 'black', border: '1px solid black'}}>min</InputGroupText>
                                    </InputGroupAddon>
                                </InputGroup>
                                <InputGroup style={{maxWidth: '100px'}}>
                                    <Input
                                        name='seconds'
                                        value={seconds}
                                        className='text-right'
                                        onChange={this.onChange}
                                        style={{border: '1px solid black'}}
                                    />
                                    <InputGroupAddon addonType='append'>
                                        <InputGroupText className='px-3 text-center' style={{color: 'white', backgroundColor: 'black', border: '1px solid black'}}>s</InputGroupText>
                                    </InputGroupAddon>
                                </InputGroup>
                            </InputGroup>
                        </Col>
                    </Row>

                    <hr className='mt-4' />

                    <Row>
                        <Col xs='12' md='6' lg='8' className='mt-4'>
                            <Label for='title'>Name your Activity</Label>
                            <Input
                                id='title'
                                name='title'
                                value={title}
                                placeholder='Afternoon Run'
                                onChange={this.onChange}
                                style={{border: '1px solid black'}}
                            />
                        </Col>
                        <Col xs='12' md='6' lg='4' className='mt-4'>
                            <Label for='tags'>Tags</Label>
                            <InputGroup id='tags' className='d-flex flex-row flex-wrap'>
                                { ['Solo run', 'Group run', 'Event'].map(tag => {
                                    return <CustomTag checked={tags && tags.includes(tag)} tag={tag} onChange={this.onChangeTags} />
                                }) }
                            </InputGroup>
                        </Col>
                    </Row>

                    <Row className='mt-4'>
                        <Col xs='12' lg='8'>
                            <Label for='description'>Description</Label>
                            <Input
                                id='description'
                                name='description'
                                type='textarea'
                                rows='4'
                                value={description}
                                placeholder='Mood level? Tired? Any happenings during your run?'
                                onChange={this.onChange}
                                style={{border: '1px solid black'}}
                            />
                        </Col>
                    </Row>
                    
                    <hr className='mt-4' />

                    <Row className='mt-4'>
                        <Col xs='12' md={{size:'4', offset:8}} lg={{size:'4', offset:0}} className='d-flex justify-content-center justify-content-sm-end justify-content-lg-start'>
                            <Button className='' type='submit' style={{backgroundColor: 'black', color: 'white', border: '1px solid black'}}>Create</Button>
                            <Button className='ml-4' style={{backgroundColor: 'black', border: '1px solid black'}}><Link to='/dashboard' style={{textDecoration: 'none', color: 'white'}}>Cancel</Link></Button>
                        </Col>
                    </Row>
                </Form>
            </Container>
        )
    }
}

export default withFirebaseAuth({
    providers,
    firebaseAppAuth
})(AddActivity)