env = require './config.json'
Auth = require '../index.coffee'
React = require 'react'
E = require 'react-script'
update = require 'react-addons-update'
ReactDOM = require 'react-dom'
redux = require 'redux'
thunk = require('redux-thunk').default
{Provider, connect} = require 'react-redux'

class Login extends React.Component
  @defaultProps:
    title: 'Login'
    style:
      margin: '.3em'

  render: ->
    props =
      onClick: @props.login
      title: @props.title
      style: @props.style
    E 'button', props, props.title

class Logout extends React.Component
  @defaultProps:
    title: 'Logout'
    style:
      margin: '.3em'

  render: ->
    props =
      onClick: @props.logout
      title: @props.title
      style: @props.style
    E 'button', props, props.title

class AuthUI extends React.Component
  render: ->
    E 'div', {},
      E Login
      E Logout
      E Auth, env
      E 'span', style: margin: '.3em',  "token: #{@props.token}"
      E 'span', style: margin: '.3em', "visible: #{@props.visible}"

createStore = redux.applyMiddleware(thunk)(redux.createStore)
reducers = redux.combineReducers
  visible: (state, action) ->
    switch action.type
      when 'login'
        true
      when 'loginReject'
        false
      when 'loginResolve'
        false
      when 'logout'
        false
      else
        state || false
  token: (state, action) ->
    switch action.type
      when 'login'
        null
      when 'loginReject'
        null
      when 'loginResolve'
        action.token
      when 'logout'
        null
      else
        state || null
mapStateToProps = (state) ->
  state
mapDispatchToProps = (dispatch) ->
  login: ->
    dispatch type: 'login'
  loginReject: (err) ->
    dispatch type: 'loginReject', error: err
  loginResolve: (token) ->
    dispatch type: 'loginResolve', token: token
  logout: ->
    dispatch type: 'logout'    
initState =
  visible: false
  token: null
store = createStore reducers, initState, window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__() 

Login = connect(mapStateToProps, mapDispatchToProps)(Login)
Logout = connect(mapStateToProps, mapDispatchToProps)(Logout)
AuthUI = connect(mapStateToProps, mapDispatchToProps)(AuthUI)
Auth = connect(mapStateToProps, mapDispatchToProps)(Auth)

elem = 
  E Provider, store: store,
    E AuthUI
  
ReactDOM.render elem, document.getElementById('root')
