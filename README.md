# cordova-plugin-fetch

HTTP networking plugin that brings the [whatwg fetch spec](https://fetch.spec.whatwg.org/) standard to Cordova

# Features

- Consistent with the `window.fetch` API based on the [whatwg fetch spec](https://fetch.spec.whatwg.org/)
- Supports iOS and Android
- Allows cross origin requests and ignores content security policy
- Allows all type of headers (including access to ```Set-Cookie``` and ```User-Agent```)

# License

MIT

## Installation

The plugin conforms to the Cordova plugin specification, it can be installed
using the Cordova / Phonegap command line interface.

    phonegap plugin add https://github.com/aporat/cordova-plugin-fetch.git

    cordova plugin add https://github.com/aporat/cordova-plugin-fetch.git

## Usage

The cordovaFetch function supports any HTTP method. We'll focus on GET and POST example requests.

### HTML

```javascript
cordovaFetch('/users.html')
  .then(function(response) {
    return response.text()
  }).then(function(body) {
    document.body.innerHTML = body
  })
```

### JSON

```javascript
cordovaFetch('/users.json')
  .then(function(response) {
    return response.json()
  }).then(function(json) {
    console.log('parsed json', json)
  }).catch(function(ex) {
    console.log('parsing failed', ex)
  })
```

### Setting Custom User Agent

```javascript
cordovaFetch('/users.json', {
  method : 'GET',
  headers: {
    'User-Agent': 'CordovaFetch 1.0.0'
  },
})
```

### Accessing Response Headers / Cookies

```javascript
cordovaFetch('/users.json')
.then(function(response) {
  console.log(res.headers['Set-Cookie']);
})
```

### Post form

```javascript
var form = document.querySelector('form')

cordovaFetch('/users', {
  method: 'POST',
  body: new FormData(form)
})
```

### Post JSON

```javascript
cordovaFetch('/users.json', {
  method: 'POST',
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: 'Hubot',
    login: 'hubot',
  })
})
```
