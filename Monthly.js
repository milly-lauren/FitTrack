import React, { Component } from 'react';
import Calendar from 'react-calendar';
import WorkoutCard from '../workoutCard/workoutCard'
import AuthContext from '../../context/auth/authContext'


export default class Sample extends Component {
  state = {
    value: new Date(),
  }

  onChange = value => this.setState({ value })

  render() {
    const { value } = this.state;

    return (
      <div className='full-workout-page'>
        <div className='calender-container bg-primary-9'>
          <header>
            <h1 class='text-center text-light'>Select a Date to View a Workout</h1>
          </header>
          <div className='sub-container'>
            <Calendar
                onChange={this.onChange}
                calendarType={"US"}
                value={value}
            />
            <div className='workout-card'>
              <WorkoutCard
                />
            </div>
          </div>

        </div>
        <div className='graph-container bg-primary-9'>
          <div className='sub-graph-container'> Graph Will Go Here
          </div>

        </div>

      </div>
    );
  }
}
