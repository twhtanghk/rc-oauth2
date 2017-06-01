require './css'
React = require 'react'
E = require 'react-script'
Dialog = require 'rc-dialog'
url = require 'url'
queryString = require 'query-string'

class Auth extends React.Component
  @cb: null

  @defaultProps:
    title: 'Login'
    style:
      height: "80%"
    bodyStyle:
      padding: 0
      position: 'relative'
      flexGrow: 1

  url: ->
    query = url.format query:
      client_id: @props.CLIENT_ID
      scope: @props.SCOPE
      response_type: 'token'
    "#{@props.AUTHURL}#{query}"

  render: =>
    props = Object.assign {}, @props,
      onClose: @props.loginReject
    E Dialog, props,
      E 'iframe', 
        key: Date.now().toString()
        src: @url()
        frameBorder: 0
        style:
          height: '100%'
          width: '100%'
          position: 'absolute'
          borderRadius: '6px'

  componentDidMount: ->
    Auth.cb = (event) =>
      @auth event
    window.addEventListener 'message', Auth.cb

  componentWillUnmount: ->
    window.removeEventListener Auth.cb

  auth: (e) =>
    auth = e.data.auth || {}
    if 'error' of auth
      @props.loginReject auth.error
    else if 'access_token' of auth
      @props.loginResolve auth.access_token

module.exports = Auth
