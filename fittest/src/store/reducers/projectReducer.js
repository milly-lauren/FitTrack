const initState = {
  projects: [
    {id: '1', title: 'test12345', content: 'blah '},
    {id: '2', title: 'test1', content: 'ncenckoe blah blah'},
    {id: '3', title: 'test23', content: 'njri blah'}
  ]
}

const projectReducer = (state = initState, action) => {
  return state;
};

export default projectReducer;