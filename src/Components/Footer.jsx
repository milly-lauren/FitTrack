// React
import React from 'react'
import { Container, Row, Col } from 'reactstrap'
import { getUserId } from '../Firebase/functions'

class Footer extends React.Component {
    render() {
        return (
            <div style={{backgroundColor: 'black', height: '100%'}} className='pt-4'>
            //     <Container className='text-secondary'>
            //         <p>{' User id: ' + getUserId()}</p>
            //     </Container>
            </div>
        )
    }
}

export default Footer