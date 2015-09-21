#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVJSON.h>

@interface CordovaFetchPlugin : CDVPlugin

- (void)fetch:(CDVInvokedUrlCommand *)command;

@end