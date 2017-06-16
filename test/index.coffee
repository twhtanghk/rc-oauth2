_ = require 'lodash'
Auth = require '../index.coffee'
React = require 'react'
E = require 'react-script'
ReactDOM = require 'react-dom'
{ applyMiddleware, combineReducers, compose, createStore } = require 'redux'
{ Provider, connect } = require 'react-redux'

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
      disabled: @props.token?
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
      disabled: not (@props.token?)
    E 'button', props, props.title

class AuthUI extends React.Component
  render: ->
    E 'div', {},
      E Login, _.pick(@props, 'token', 'login')
      E Logout, _.pick(@props, 'token', 'logout')
      E Auth,
        AUTHURL: process.env.AUTHURL
        CLIENT_ID: process.env.CLIENT_ID
        SCOPE: process.env.SCOPE
      E 'span', style: margin: '.3em', "visible: #{@props.visible}"
      E 'span', style: margin: '.3em', "token: #{@props.token}"
      E 'span', style: margin: '.3em', "error: #{@props.error}"

composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
store = createStore Auth.reducer, Auth.state, composeEnhancers()

mapStateToProps = (state) ->
  state
AuthUI = connect(mapStateToProps, Auth.actionCreator)(AuthUI)
Auth = connect(mapStateToProps, Auth.actionCreator)(Auth.component)

elem = 
  E Provider, store: store,
    E AuthUI
  
ReactDOM.render elem, document.getElementById('root')
