import React from 'react'
import DayPicker from 'react-day-picker'
import 'react-day-picker/lib/style.css'
import Graph from '../workoutCard/graph'
import WorkoutCard from '../workoutCard/workoutCard'

const workoutStyle =
    `.DayPicker-Day--highlighted {
        background-color: rgb(226, 194, 57);
        color: white;
    }`

const modifiers = {
    highlighted: new Date(2019, 6, 19),
}


export default class Sample extends React.Component {
    constructor(props) {
        super(props)
        this.handleDayClick = this.handleDayClick.bind(this)
        this.state = {
            selectedDay: undefined,
        }
    }

    handleDayClick(day) {
        this.setState({ selectedDay: day })
    }

    render() {
        return (
            <div className='full-workout-page'>
                <div className='calender-container bg-primary-9'>
                    <header>
                        <h1 class='text-center text-light'>Select a Date to View a Workout</h1>
                    </header>
                    <div className='sub-container'>
                        <style>{workoutStyle}</style>
                        <DayPicker className='white-contianer' onDayClick={this.handleDayClick} modifiers={modifiers} />
                        <div className='workout-card'><WorkoutCard /></div>
                    </div>
                </div>
                <div className='graph-container bg-primary-9'>
                    <div className='sub-graph-container'><Graph /></div>
                </div>
            </div>
        )
    }
}
