env = require './config.json'
Auth = require '../index.coffee'
React = require 'react'
ReactDOM = require 'react-dom'

ReactDOM.render React.createElement(Auth, env), document.getElementById('root')
