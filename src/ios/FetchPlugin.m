#import "FetchPlugin.h"
#import "BaseClient.h"
#import "AFNetworkActivityLogger.h"

@interface FetchPlugin()

@end


@implementation FetchPlugin

- (void)pluginInitialize {
  
  [[AFNetworkActivityLogger sharedLogger] startLogging];
}

- (void)fetch:(CDVInvokedUrlCommand *)command {
  NSString *method = [command.arguments objectAtIndex:0];
  NSString *urlString = [command.arguments objectAtIndex:1];
  id body = [command.arguments objectAtIndex:2];
  id headers = [command.arguments objectAtIndex:3];
  
  if (![body isKindOfClass:[NSString class]]) {
    body = nil;
  }
  
  if (headers[@"map"] != nil && [headers[@"map"] isKindOfClass:[NSDictionary class]]) {
    headers = headers[@"map"];
  }
  
  FetchPlugin *__weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [[BaseClient sharedClient] dataTaskWithHTTPMethod:method URLString:urlString parameters:body headers:headers success:^(NSURLSessionDataTask *task, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [result setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    if (response.URL != nil && response.URL.absoluteString != nil) {
      [result setObject:response.URL.absoluteString forKey:@"url"];
    }
    
    if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
      [result setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSURLSessionTask *task, NSError *error, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [result setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    [result setObject:[error localizedDescription] forKey:@"error"];

    if (error != nil && responseObject == nil) {
      CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:result];
      [pluginResult setKeepCallbackAsBool:YES];
      [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    } else {
      if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
        [result setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
      }
      
      CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
      [pluginResult setKeepCallbackAsBool:YES];
      [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
  }];
  
  [dataTask resume];
}

@end
