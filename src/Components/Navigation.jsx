// React
import React from 'react'
import { Link, Redirect } from 'react-router-dom'
import {
    Collapse,
    Button,
    Navbar,
    NavbarToggler,
    NavbarBrand,
    Nav,
    NavItem,
    NavLink,
    Dropdown,
    DropdownToggle,
    DropdownMenu,
    DropdownItem,
    Container
} from 'reactstrap'

// Firebase
import {
    withFirebaseAuth,
    providers,
    firebaseAppAuth
} from '../Firebase/Firebase'
import {
    getProfilePicUrl,
    getUserName
} from '../Firebase/functions'

// Media
import {
    knightyFit,
    knightyFitBorder,
    knightro
} from './Resources'

class Navigation extends React.Component {
    constructor(props) {
        super(props)

        this.state = {
            isNavOpen: false,
            isPicOpen: false,
            isPicHover: false,
            isAddOpen: false,
            isAddHover: false
        }

        this.onClick = this.onClick.bind(this)
        this.togglePic = this.togglePic.bind(this)
        this.toggleNav = this.toggleNav.bind(this)
        this.onPicMouseLeave = this.onPicMouseLeave.bind(this)
        this.onPicMouseOver = this.onPicMouseOver.bind(this)
        this.toggleAdd = this.toggleAdd.bind(this)
        this.onAddMouseLeave = this.onAddMouseLeave.bind(this)
        this.onAddMouseOver = this.onAddMouseOver.bind(this)
    }

    toggleNav() { this.setState({isNavOpen: !this.state.isNavOpen }) }
    togglePic() { this.setState({ isPicOpen: (this.state.isPicHover ? this.state.isPicOpen : !this.state.isPicOpen) }) }
    onPicMouseOver() { this.setState({ isPicHover: true, isPicOpen: true }) }
    onPicMouseLeave() { this.setState({ isPicHover: false, isPicOpen: false }) }
    toggleAdd() { this.setState({ isAddOpen: (this.state.isAddHover ? this.state.isAddOpen : !this.state.isAddOpen) }) }
    onAddMouseOver() { this.setState({ isAddHover: true, isAddOpen: true }) }
    onAddMouseLeave() { this.setState({ isAddHover: false, isAddOpen: false }) }

    onClick() {
        // dirty work around to trigger re-render
        this.setState({})
    }

    render() {
        const {
            user,
            signOut
        } = this.props
        const {
            isNavOpen,
            isPicOpen,
            isPicHover,
            isAddOpen,
            isAddHover
        } = this.state

        const guest = (
            <Nav className='ml-auto'>
                <NavItem>
                    <NavLink>{ window.location.pathname === '/' ?
                        <Link to='/login'><Button light color='light' onClick={this.onClick}>Sign In</Button></Link>
                        : <Link to='/'><Button light color='light' onClick={this.onClick}>Sign Up</Button></Link>
                    }</NavLink>
                </NavItem>
            </Nav>
        )

        const authed = (
                <Collapse isOpen={isNavOpen} navbar>
                        { isNavOpen ?
                            <Nav navbar>
                                {/* University upgrade button */}
                                <NavItem>
                                    <Button light color='light' className='px-4 font-weight-bold' style={{padding: '2px'}}>University</Button>
                                </NavItem>
                                <hr/>
                                <DropdownToggle className='d-flex align-items-center' nav>
                                    { user ? <img style={{width: '1.9rem', height: '1.9rem', borderRadius: 999}} src={getProfilePicUrl()} alt={knightro} /> : null }
                                    <div style={{marginLeft: '1rem'}}>{getUserName()}</div>
                                </DropdownToggle>
                                {['Find Friends', 'My Profile', 'Settings'].map(value => {
                                    return <NavItem className='py-2 hover-mobile-menu-link' style={{paddingLeft: '2.9rem'}}><Link>{value}</Link></NavItem>
                                })}
                                <NavItem onClick={signOut}>Log out</NavItem>
                                <hr style={{}}/>
                                <NavItem><Link to='/newActivity'>&#10010; Manual Entry</Link></NavItem>
                            </Nav>
                            :
                            <Nav className={'ml-auto d-flex align-items-center'} style={{padding: '0 0'}} navbar>
                                {/* University upgrade button */}
                                <NavItem>
                                    <Button className='px-4 border-0 font-weight-bold' style={{padding: '2px', color: 'white', backgroundColor: 'rgb(225,193,71)'}}>University</Button>
                                </NavItem>
                                <Dropdown onMouseOver={this.onPicMouseOver} onMouseLeave={this.onPicMouseLeave} isOpen={isPicHover || isPicOpen} toggle={this.togglePic} className={'ml-4'} nav inNavbar>
                                    { isPicOpen ? 
                                        <DropdownToggle className='d-flex justify-content-center align-items-center bg-white' style={{paddingLeft: '.75rem', borderLeft: '1px solid rgb(108,117,125)', borderRight: '1px solid rgb(108,117,125)'}} nav>
                                            { user ? <img style={{width: '1.9rem', height: '1.9rem', borderRadius: 999}} src={getProfilePicUrl()} alt={knightro} /> : null }
                                            <div style={{fontSize: '1.4rem', color: 'black'}}>&#8638;</div>
                                        </DropdownToggle>
                                        :
                                        <DropdownToggle className='d-flex justify-content-center align-items-center' style={{paddingLeft: '.75rem', backgroundColor: 'black', borderLeft: '1px solid black', borderRight: '1px solid black'}} nav>
                                            { user ? <img style={{width: '1.9rem', height: '1.9rem', borderRadius: 999}} src={getProfilePicUrl()} alt={knightro} /> : null }
                                            <div className='text-white' style={{fontSize: '1.4rem'}}>&#8642;</div>
                                        </DropdownToggle>
                                    }
                                    <DropdownMenu right style={{marginTop: '0', borderRadius: '0 0 6px 6px', borderTop: 'none'}}>
                                        <DropdownItem style={{color: 'black'}}>My Profile</DropdownItem>
                                        <DropdownItem style={{color: 'black'}}>Settings</DropdownItem>
                                        <DropdownItem divider />
                                        <DropdownItem onClick={signOut} style={{color: 'black'}}>Log Out</DropdownItem>
                                    </DropdownMenu>
                                </Dropdown>
                                
                                <Dropdown onMouseOver={this.onAddMouseOver} onMouseLeave={this.onAddMouseLeave} isOpen={isAddHover || isAddOpen} toggle={this.toggleAdd} className='ml-0 rounded-0 border-0' nav inNavbar>
                                    { isAddOpen ? 
                                        <DropdownToggle className='bg-white' style={{borderRadius: 0, border: 'none', padding: '12px .75rem 12px .75rem', borderLeft: '1px solid rgb(108,117,125)', borderRight: '1px solid rgb(108,117,125)'}}>
                                            <div style={{padding: '0 5px', borderRadius: 999, backgroundColor: 'black', borderColor: 'black'}} className='text-white border'>&#10010;</div>
                                        </DropdownToggle>
                                        :
                                        <DropdownToggle style={{borderRadius: 0, border: 'none', padding: '12px .75rem 12px .75rem', backgroundColor: 'black', borderLeft: '1px solid black', borderRight: '1px solid black'}}>
                                            <div style={{padding: '0 5px', borderRadius: 999}} className='text-white border border-light'>&#10010;</div>
                                        </DropdownToggle>
                                    }
                                    <DropdownMenu right style={{marginTop: '0', borderRadius: '0 0 6px 6px', borderTop: 'none'}}>
                                        <DropdownItem><Link to='/create-activity' style={{textDecoration: 'none', color: 'black'}}>&#10010; Manual Entry</Link></DropdownItem>
                                    </DropdownMenu>
                                </Dropdown>
                            </Nav>
                        }
                </Collapse>
        )

        {/* fix padding on mobile */}
        return (
            <Navbar className='m-0 p-0 sticky-top' style={{backgroundColor: 'black'}} expand='md'>
                <Container className='d-flex align-items-center justify-content-between w-100 py-2 px-3 py-md-0'>
                    <NavbarBrand onClick={() => (<Redirect to='/' />)}>
                        <Link to='/'>
                            <img style={{width: '7rem'}} src={knightyFit} alt='KnightyFit' />
                        </Link>
                        {' '}Development
                    </NavbarBrand>
                    <NavbarToggler onClick={this.toggleNav} />
                    { user ? authed : guest }
                </Container>
            </Navbar>
        )
    }
}

export default withFirebaseAuth({
    providers,
    firebaseAppAuth
})(Navigation)