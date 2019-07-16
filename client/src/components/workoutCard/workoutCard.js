import React, { useState, useContext, useEffect } from 'react'
import workoutContext from '../../context/contact/contactContext'
import { Link, DirectLink, Element, Events, animateScroll as scroll, scrollSpy, scroller } from 'react-scroll'

const WorkoutCard = () => {

//  const workoutContext = useContext(workoutContext)
//  const { contacts, filtered, getContacts, loading } = contactContext

  const miles = 3.2
  const pace = '8:42.0'
  const duration = '23:46.8'
  const steps = '12,924'

  return (
        <div className='workout-container bg-primary-7'>
          <header class='text-center text-light'>Date:</header>
          <div className='sub-container'>
            <div className='stats-container'>
              <h1>Distance:</h1>
                  <pre>   {miles} miles</pre>
              <h2>Avg Pace:</h2>
                  <pre>   {pace} mile/min</pre>
              <h3>Duration:</h3>
                  <pre>   {duration} min</pre>
              <h4>Steps:</h4>
                  <pre>   {steps}</pre>
            </div>
            <div className='map-container'>Map container
            </div>
          </div>
          <a class='text-center text-light' onClick={ ()=>scroll.scrollTo(650)}>
            View Workout Statistics >
          </a>
        </div>
  );
}


export default WorkoutCard
