#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface FetchPlugin : CDVPlugin

- (void)fetch:(CDVInvokedUrlCommand *)command;

@end
