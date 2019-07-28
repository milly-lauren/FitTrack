// React
import React from 'react'
import {
    Card,
    Form,
    Label,
    Input,
    Button,
    Container,
    Row,
    Col,
    Modal,
    Alert
} from 'reactstrap'

// Firebase
import {
    withFirebaseAuth,
    providers,
    firebaseAppAuth,
    db
} from '../Firebase/Firebase'
import {
    getUserName,
    getProfilePicUrl,
    getUserId,
    createProfile
} from '../Firebase/functions'


class Dashboard extends React.Component {
    constructor(props) {
        super(props)

        // Initializing first and last names
        const fullName = getUserName().split(' ')
        let newFirstName = ''
        let newLastName = ''
        if (fullName.length === 1) {
            newFirstName = fullName[0]
        } else {
            newFirstName = fullName[0]
            newLastName = fullName[fullName.length-1]
        }

        this.state = {
            userInput: {
                firstName: newFirstName,
                lastName: newLastName,
                birthMonth: '',
                birthDay: '',
                birthYear: '',
                gender: ''
            },
            posts: [],
            isLoading: true,
            isOpen: false,
            alert: ''
        }
        
        this.onChange = this.onChange.bind(this)
        this.toggle = this.toggle.bind(this)
    }

    // added listener for live updates from db
    componentDidMount() {
        const query = db.collection('users').doc(getUserId())
        let userExists = false
        query.get().then(snapshot => {
            if (snapshot.exists) {
                userExists = true
            } else {
                this.setState({ isLoading: false, isOpen: true })
            }
        }).then(() => {
            userExists && query.collection('activities').orderBy('timestamp', 'desc').onSnapshot(snapshot => {
                let posts = []
                snapshot.forEach(doc => {
                    posts.push(doc.data())
                })
                console.log(posts)
                this.setState(prevState => ({ ...prevState, isLoading: false, posts }))
            })
        })
    }

    // Use state as ground truth
    onChange(event) {
        const target = event.target
        this.setState(prevState => ({ userInput: { ...prevState.userInput, [target.name]: target.value }}))
        console.log(this.state.userInput)
    }

    toggle() {
        this.setState({ isOpen: !this.state.isOpen })
    }

    render() {
        const {
            userInput: {
                firstName,
                lastName,
                birthMonth,
                birthDay,
                birthYear,
                gender
            },
            posts,
            isLoading,
            isOpen,
            alert
        } = this.state

        const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        const shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        const genders = ['Male', 'Female', 'Other']
        const numGenerator = (a,b) => {
            let A = []
            for (let i = a; i < b; i++) {
                A.push(i)
            }
            return A
        }

        const ActivityCard = ({post}) => {
            return (
                <Card body className='border-0 mb-3' style={{boxShadow: '0 0 30px 2px rgb(233,233,233)'}}>
                    <div className='d-flex flex-row'>
                        <div>
                            <img style={{width: '2.1rem', height: '2.1rem', borderRadius: 999}} src={post.profilePicUrl} alt={''} />
                        </div>
                        <div className='ml-3 w-100' style={{marginTop: '-1px'}}>
                            <Row>
                                <Col xs='auto'>
                                    <p className='font-weight-bold m-0' style={{fontSize: '.7rem'}}>{post.name}</p>
                                    <p className='text-secondary m-0' style={{fontSize: '.6rem'}}>
                                        {months[parseInt(post.date_month)] + ' ' + post.date_day + ', ' + post.date_year
                                        + ' at ' + (parseInt(post.date_hour) % 12 === 0 ? '12' : post.date_hour)
                                        + ':' + post.date_minute.toString().padStart(2,'0')
                                        + ' ' + (post.date_hour % 12 > 0 ? 'PM' : 'AM')}</p>
                                </Col>
                            </Row>
                            <Row className='mt-2'>
                                <Col xs='auto'>
                                    <p className='font-weight-bold' style={{fontSize: '1.1rem'}}>{post.title}</p>
                                </Col>
                            </Row>
                            {post.description && <Row className=''>
                                <Col xs='auto'>
                                    <p style={{fontSize: '.6rem'}} className='mt-n3'>{post.description}</p>
                                </Col>
                            </Row>}
                            <Row className='mt-n3 d-flex align-items-center justify-content-start'>
                                <Col xs='auto m-0 p-0'>
                                    <Label for='distance' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Distance</Label>
                                    <div className='m-0 mt-n1' id='distance'>{post.distanceValue + ' ' + post.distanceUnit}</div>
                                </Col>
                                <div style={{margin: '0 .75rem', height: '1.3rem', width: '1px', marginTop: '5px', backgroundColor: 'rgb(211,211,211)'}}></div>
                                <Col xs='auto m-0 p-0'>
                                    <Label for='time' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Time</Label>
                                    <div className='m-0 mt-n1' id='distance'>{
                                        (parseInt(post.hours) !== 0 ?
                                            parseInt(post.hours) + 'h'
                                                    + (parseInt(post.minutes) !== 0 ?
                                                        ' ' + parseInt(post.minutes) + 'm'
                                                    : '')
                                        : (parseInt(post.minutes) !== 0 ?
                                            parseInt(post.minutes) + 'm'
                                                    + (parseInt(post.seconds) !== 0 ?
                                                        ' ' + parseInt(post.seconds) + 's'
                                                    : '')
                                        : parseInt(post.seconds)+'s'))
                                    }</div>
                                </Col>
                                <div style={{margin: '0 .75rem', height: '1.3rem', width: '1px', marginTop: '5px', backgroundColor: 'rgb(211,211,211)'}}></div>
                                <Col xs='auto m-0 p-0'>
                                    <Label for='speed' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Avg. Velocity</Label>
                                    <div className='m-0 mt-n1' id='speed'>{
                                        (parseFloat(post.distanceValue) / (parseFloat(post.hours) + parseFloat(post.minutes)/60 + parseFloat(post.seconds)/3600)).toString().substr(0,5)
                                        + ' ' + post.distanceUnit + '/hr'
                                    }</div>
                                </Col>
                            </Row>
                        </div>
                    </div>
                    {post.image ? <div className='w-100 bg-warning rounded my-2' style={{height: '150px', overflow: 'hidden'}}>
                                    {/* TODO: add image */}
                    </div> : <Row><Col xs='12'><hr /></Col></Row>}
                    <div className='w-100'>
                        <Row>
                            <Col xs='12' className='d-flex justify-content-end'>
                                <Button className='text-secondary border-0' style={{fontSize: '.8rem', backgroundColor: 'rgb(235,235,230)'}}>Like</Button>
                                <Button className='ml-2 text-secondary border-0' style={{fontSize: '.8rem', backgroundColor: 'rgb(235,235,230)'}}>Comment</Button>
                            </Col>
                        </Row>
                    </div>
                </Card>
            )
        }

        const UserCard = () => {
            return (
                <Card body className='border-0 mb-3' style={{boxShadow: '0 0 30px 2px rgb(233,233,233)'}}>
                    <div className='d-flex mx-auto' style={{marginTop: '-2.95rem'}}>
                        <img style={{width: '3.4rem', height: '3.4rem', borderRadius: 999, boxShadow: '0 0 30px 2px rgb(233,233,233)'}} src={getProfilePicUrl()} alt={''} />
                    </div>
                    <Row className='mt-2'>
                        <Col xs='12' className='text-center'>
                            <p className='font-weight-bold' style={{fontSize: '1.1rem'}}>{getUserName()}</p>
                        </Col>
                    </Row>
                    <Row className='d-flex justify-content-around align-items-center flex-row flex-nowrap mt-n3'>
                        <Col xs='auto m-0 p-0'>
                            <Label for='following' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Following</Label>
                            <div className='m-0 mt-n1 text-center' id='following'>{'0'}</div>
                        </Col>
                        <div style={{margin: '0 .75rem', height: '1.3rem', width: '1px', marginTop: '5px', backgroundColor: 'rgb(211,211,211)'}}></div>
                        <Col xs='auto m-0 p-0'>
                            <Label for='followers' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Followers</Label>
                            <div className='m-0 mt-n1 text-center' id='followers'>{'0'}</div>
                        </Col>
                        <div style={{margin: '0 .75rem', height: '1.3rem', width: '1px', marginTop: '5px', backgroundColor: 'rgb(211,211,211)'}}></div>
                        <Col xs='auto m-0 p-0'>
                            <Label for='activities' className='text-secondary m-0' style={{fontSize: '.65rem'}}>Activities</Label>
                            <div className='m-0 mt-n1 text-center' id='activities'>{posts.length}</div>
                        </Col>
                    </Row>
                    <div className='' style={{width: '100%'}}><hr /></div>
                    {posts[0] && <Row className='mt-n3'>
                        <Col xs='12'>
                            <Label for='latestActivity' className='m-0' style={{fontSize: '.65rem'}}>Latest Activity</Label>
                            <div className='m-0 mt-n1 font-weight-bold' style={{fontSize: '.65rem'}} id='latestActivity'>{posts[0].title + ' '}&bull;{' '}</div>
                        </Col>
                    </Row>}
                </Card>
            )
        }

        const InfoCard = ({initial, header, body, footer}) => {
            return (
                <Card body className='border-0 mb-3' style={{boxShadow: '0 0 30px 2px rgb(233,233,233)'}}>
                        <div style={{width: '2.1rem', height: '2.1rem', borderRadius: 999, border: '1px solid rgb(225,193,71)', color: 'rgb(225,193,71)'}}
                                className='d-flex align-items-center justify-content-center'>
                            {initial}
                        </div>
                    
                    <Row>
                        <Col xs='auto'>
                        </Col>
                    </Row>
                </Card>
            )
        }

        return (
            <div style={{marginTop: '3.2rem', marginBottom: '1rem'}}>
                <Modal centered isOpen={isOpen}>
                    <Form className='m-3' onSubmit={e => {
                        e.preventDefault()

                        if (firstName && lastName && birthMonth && birthDay && birthYear && gender) {
                            createProfile(firstName, lastName, birthMonth, birthDay, birthYear, gender)
                            this.toggle()
                        } else {
                            // TODO: check if age is 13 or older
                            this.setState({ alert: 'Please fill out all fields.' })
                            setTimeout(() => this.setState({ alert: '' }), 5000)
                        }
                    }}>
                        <Row>
                            <Col xs='12'>
                                <p className='font-weight-bold' style={{fontSize: '1.1rem'}}>Create your profile</p>
                                <p className='mt-n3' style={{fontSize: '.9rem'}}>This will store your activities and help us personalize your experience.</p>
                            </Col>
                        </Row>
                        <Row>
                            <Col xs='12' md='6'>
                                <Label for='firstName' style={{fontSize: '.7rem'}}>First Name</Label>
                                <Input
                                    id='firstName'
                                    name='firstName'
                                    value={firstName}
                                    onChange={this.onChange}
                                    style={{border: '1px solid black'}}
                                    required
                                />
                            </Col>
                            <Col xs='12' md='6'>
                            <Label for='firstName' style={{fontSize: '.7rem'}}>Last Name</Label>
                                <Input
                                    id='lastName'
                                    name='lastName'
                                    value={lastName}
                                    onChange={this.onChange}
                                    style={{border: '1px solid black'}}
                                    required
                                />
                            </Col>
                        </Row>
                        <Row>
                            <Col xs='12' md='6'>
                                <Label for='birthday' style={{fontSize: '.7rem'}}>Birthday</Label>
                                <div className='d-flex flex-row flex-nowrap' id='birthday'>
                                    <select required onChange={this.onChange} name='birthMonth' className='custom-select' style={{border: '1px solid black', borderRight: 'none', borderRadius: '4px 0 0 4px', minWidth: '70px'}}>
                                        {!birthMonth && <option selected>MM</option>}
                                        {shortMonths.map((month, index) => {return <option value={index+1}>{month}</option>})}
                                    </select>  
                                    <select required onChange={this.onChange} name='birthDay' className='custom-select rounded-0' style={{border: '1px solid black'}}>
                                        {!birthDay && <option selected>DD</option>}
                                        {numGenerator(1,32).map((day) => {return <option value={day}>{day}</option>})}
                                    </select>  
                                    <select required onChange={this.onChange} name='birthYear' className='custom-select' style={{border: '1px solid black', borderLeft: 'none', borderRadius: '0 4px 4px 0', minWidth: '80px'}}>
                                        {!birthYear && <option selected>YYYY</option>}
                                        {numGenerator(1940, parseInt((new Date()).getFullYear())-12).reverse().map((year) => {return <option value={year}>{year}</option>})}
                                    </select>  
                                </div>
                            </Col>
                            <Col xs='12' md='6'>
                                <Label for='selectGender' style={{fontSize: '.7rem'}}>Gender</Label>
                                <select required onChange={this.onChange} name='gender' className='custom-select' style={{border: '1px solid black'}} id='selectGender'>
                                    {!gender && <option selected></option>}
                                    {genders.map((gen, index) => {return <option value={index}>{gen}</option>})}
                                </select> 
                            </Col>
                        </Row>
                        <Row className='mt-3 d-flex align-items-center'>
                            <Col xs='12' sm='9'>
                                {alert && <Alert style={{fontSize: '.9rem', paddingTop: '5px', paddingBottom: '5px'}} className='m-0' color='warning'>{alert}</Alert>}
                            </Col>
                            <Col xs='12' sm='3' className='d-flex justify-content-center justify-content-sm-end mt-3 mt-sm-0'>
                                <Button className='border-0 font-weight-bold w-100' style={{color: 'white', backgroundColor: 'rgb(225,193,71)', fontSize: '.9rem'}} type='submit'>Continue</Button>
                            </Col>
                        </Row>
                    </Form>
                </Modal>
                <Container className='cmw'>
                    <Row>
                        <Col id='usercard' xs='0' md='3'>
                            <UserCard />
                        </Col>
                        <Col xs='12' md='6'>
                            { !isLoading && ( posts && posts.map(post => {return <ActivityCard post={post} />}) )}
                            { !isLoading && ( posts.length === 0 && <div className='text-center' style={{color: 'rgb(155,155,150)', position: 'relative'}}>:( Make some friends or go for run!</div> )}
                        </Col>
                        <Col xs='0' md='3'>
                            <InfoCard initial='C' />
                        </Col>
                    </Row>
                </Container>
            </div>
        )
    }
}

export default withFirebaseAuth({
    providers,
    firebaseAppAuth
})(Dashboard)