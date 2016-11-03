'use strict'

const React = require('react')
const ReactDOM = require('react-dom')
const request = require('superagent')


class PetCreator extends React.Component {
  constructor () {
    super()
    this.state = this.getOriginalState()
  }

  getOriginalState () {
    return {
      petName: '',
      petAge: 0,
      petType: ''
    }
  }

  resetState () {
    this.setState(this.getOriginalState())
  }

  submitNewPet () {
    if (this.state.petName && this.state.petType) {
      request
        .post('/pet')
        .send({
          name: this.state.petName,
          age: this.state.petAge,
          type: this.state.petType
        })
        .then((res) => {
          console.log('/pet responsed')
          this.resetState()
        })
    }
  }

  onNameChange (e) {
    let petName = e.target.value

    this.setState({ petName })
  }

  onAgeChange (e) {
    let petAge = parseInt(e.target.value)

    if (isNaN(petAge) || petAge < 0) {
      petAge = 0
    }
    this.setState({ petAge })
  }

  onTypeChange (e) {
    let petType = e.target.value

    this.setState({ petType })
  }

  render() {
    return (
      <div>
        <h3>Make a Pet:</h3>
        <div>
          {'Name: '}
          <input value={this.state.petName} onChange={this.onNameChange.bind(this)} />
        </div>
        <div>
          {'Age: '}
          <input value={this.state.petAge} onChange={this.onAgeChange.bind(this)} />
        </div>
        <div>
          {'Type: '}
          <input value={this.state.petType} onChange={this.onTypeChange.bind(this)} />
        </div>
        <button onClick={this.submitNewPet.bind(this)}>New Pet</button>
      </div>
    )
  }
}

class PetGetter extends React.Component {
  constructor() {
    super()
    this.state = { pet: null, petName: '' }
  }

  onClick() {
    console.log('onClick: this.state:', this.state)
    if (this.state.petName) {
      request.get('/pet/' + this.state.petName).then(res => {
        console.log('/pet/:name response: res.text:', res.text)
        console.log('/pet/:name response: res.body:', res.body)
        // this.setState({ name: res.text, value: '' })
        this.setState({ pet: res.body })
      })
    }
  }

  onChange(e) {
    console.log('onChange:', e.target.value)
    this.setState({ petName: e.target.value })
  }

  petDisplay() {
    return this.state.pet ?
      <div>
        <p>Name: {this.state.pet.name}</p>
        <p>Type: {this.state.pet.type}</p>
        <p>Age: {this.state.pet.age}</p>
      </div> :
      ''
  }

  render() {
    return (
      <div>
        <h3>Get a Pet:</h3>
        <input value={this.state.petName} onChange={(e) => this.onChange(e)}></input>
        <button onClick={() => this.onClick()}>Get Pet</button>
        {this.petDisplay()}
      </div>
    )
  }
}

class PetDisplay extends React.Component {
  render() {
    return (
      <div>
        <PetCreator />
        <PetGetter />
      </div>
    )
  }
}

class HelloButton extends React.Component {
  constructor() {
    super()
    this.state = { value: 'Click the button' }
  }

  onClick() {
    request.get('/hello').then(res => {
      console.log('/hello response: res.text:', res.text)
      this.setState({ value: res.text })
    })
  }

  render() {
    return (
      <div>
        <button onClick={() => this.onClick()}>Click Me</button>
        <h3>{this.state.value}</h3>
      </div>
    )
  }
}

class App extends React.Component {
  render() {
    return (
      <div>
        <HelloButton />
        <hr />
        <PetDisplay />
      </div>
    )
    return React.createElement(
      'div',
      null,
      React.createElement(HelloButton, null),
      React.createElement('hr', null),
      React.createElement(PetDisplay, null)
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('app')
)
