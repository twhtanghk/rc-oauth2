require './css'
React = require 'react'
E = require 'react-script'
Dialog = require 'rc-dialog'
url = require 'url'

class Auth extends React.Component
  @defaultProps:
    title: 'Login'
    visible: true
    style:
      height: "80%"
    bodyStyle:
      padding: 0
      position: 'relative'
      flexGrow: 1
    onClose: ->
      console.log 'close'

  url: ->
    query = url.format query:
      client_id: @props.CLIENT_ID
      scope: @props.SCOPE
      response_type: 'token'
    "#{@props.AUTHURL}#{query}"

  render: ->
    React.createElement Dialog, @props,
      E 'iframe', 
        src: @url()
        frameBorder: 0
        style:
          height: '100%'
          width: '100%'
          position: 'absolute'
          borderRadius: '6px'

module.exports = Auth
