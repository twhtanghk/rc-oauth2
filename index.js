var Auth, Dialog, E, React, actionCreator, initState, reducer, url,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

require('./css');

React = require('react');

E = require('react-script');

Dialog = require('rc-dialog');

url = require('url');

Auth = (function(superClass) {
  extend(Auth, superClass);

  function Auth() {
    this.auth = bind(this.auth, this);
    this.render = bind(this.render, this);
    return Auth.__super__.constructor.apply(this, arguments);
  }

  Auth.cb = null;

  Auth.defaultProps = {
    title: 'Login',
    style: {
      height: "80%"
    },
    bodyStyle: {
      padding: 0,
      position: 'relative',
      flexGrow: 1
    }
  };

  Auth.prototype.url = function() {
    var query;
    query = url.format({
      query: {
        client_id: this.props.CLIENT_ID,
        scope: this.props.SCOPE,
        response_type: 'token'
      }
    });
    return "" + this.props.AUTHURL + query;
  };

  Auth.prototype.render = function() {
    var props;
    props = Object.assign({}, this.props, {
      onClose: (function(_this) {
        return function() {
          return _this.props.loginReject('access_denied');
        };
      })(this)
    });
    return E(Dialog, props, E('iframe', {
      key: Date.now().toString(),
      src: this.url(),
      frameBorder: 0,
      style: {
        height: '100%',
        width: '100%',
        position: 'absolute',
        borderRadius: '6px'
      }
    }));
  };

  Auth.prototype.componentDidMount = function() {
    Auth.cb = (function(_this) {
      return function(event) {
        return _this.auth(event);
      };
    })(this);
    return window.addEventListener('message', Auth.cb);
  };

  Auth.prototype.componentWillUnmount = function() {
    return window.removeEventListener(Auth.cb);
  };

  Auth.prototype.auth = function(e) {
    var auth;
    auth = e.data.auth || {};
    if ('error' in auth) {
      return this.props.loginReject(auth.error);
    } else if ('access_token' in auth) {
      return this.props.loginResolve(auth.access_token);
    }
  };

  return Auth;

})(React.Component);

initState = {
  visible: false,
  token: null,
  error: null
};

reducer = function(state, action) {
  switch (action.type) {
    case 'login':
      return {
        visible: true,
        token: null,
        error: null
      };
    case 'loginReject':
      return {
        visible: false,
        token: null,
        error: action.error
      };
    case 'loginResolve':
      return {
        visible: false,
        token: action.token,
        error: null
      };
    case 'logout':
      return {
        visible: false,
        token: null,
        error: null
      };
    default:
      return state || initState;
  }
};

actionCreator = function(dispatch) {
  return {
    login: function() {
      return dispatch({
        type: 'login'
      });
    },
    loginReject: function(err) {
      return dispatch({
        type: 'loginReject',
        error: err
      });
    },
    loginResolve: function(token) {
      return dispatch({
        type: 'loginResolve',
        token: token
      });
    },
    logout: function() {
      return dispatch({
        type: 'logout'
      });
    }
  };
};

module.exports = {
  component: Auth,
  state: initState,
  reducer: reducer,
  actionCreator: actionCreator
};
