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
  id parameters = [command.arguments objectAtIndex:2];
  id headers = [command.arguments objectAtIndex:3];
  
  if (![parameters isKindOfClass:[NSString class]]) {
    parameters = nil;
  }
  
  if (headers[@"map"] != nil && [headers[@"map"] isKindOfClass:[NSDictionary class]]) {
    headers = headers[@"map"];
  }
  
  FetchPlugin *__weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [[BaseClient sharedClient] dataTaskWithHTTPMethod:method URLString:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask *task, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [dictionary setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    if (response.URL != nil && response.URL.absoluteString != nil) {
      [dictionary setObject:response.URL.absoluteString forKey:@"url"];
    }
    
    if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
      [dictionary setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    [pluginResult setKeepCallbackAsBool:YES];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSURLSessionTask *task, NSError *error, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [dictionary setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    [dictionary setObject:[error localizedDescription] forKey:@"error"];

    if (error != nil && responseObject != nil) {
      CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictionary];
      [pluginResult setKeepCallbackAsBool:YES];
      [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    } else {
      if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
        [dictionary setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
      }
      
      CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
      [pluginResult setKeepCallbackAsBool:YES];
      [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
  }];
  
  [dataTask resume];
}

@end
