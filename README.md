# rc-oauth2

OAuth2 dialog to obtain token for implicit grant OAuth2 authentication.

## Install
[![rc-oauth2](https://nodei.co/npm/rc-oauth2.png)](https://npmjs.org/package/rc-oauth2)

## Usage
```
E = require 'react-script'
Auth = require 'rc-oauth2'

E Auth { AUTHURL: auth_url, CLIENT_ID: client_id, SCOPE: 'User' } 
```

## API
```
props:
  visible: flag to show or hide oauth2 dialog (default: false)
  token: authorization token (default: null)
  error: error message
  login: action creator to trigger action with type: 'login'
  loginReject: action creator to trigger action with type: 'loginReject', error: error_message
  loginResolve: action creator to trigger action with type: 'loginResolve', token: token
  logout: action creator to trigger action with type: 'logout'

{component, state, reducer, actionCreator} = require 'rc-oauth2'
createStore reducer, state
Auth = connect((state) -> state, actionCreator)(component
E Auth,
  AUTHURL: 'authorization url'
  CLIENT_ID: 'client_id'
  SCOPE: 'scope'
```

## Example
[Demo](https://rawgit.com/twhtanghk/rc-oauth2/master/test/index.html)
