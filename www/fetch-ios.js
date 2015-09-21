/*
 * An HTTP Plugin for Cordova.
 */

var exec = require('cordova/exec');

var http = {
    fetch: function(method, url, params, headers, success, failure) {
      exec(success, failure, "CordovaFetchPlugin", "fetch", [method, url, params, headers]);
    }
};

module.exports = http;