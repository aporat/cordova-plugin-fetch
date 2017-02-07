#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
// #import <Cordova/CDVJSON.h>

@interface FetchPlugin : CDVPlugin

- (void)fetch:(CDVInvokedUrlCommand *)command;

@end
