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
  NSString *method = [command argumentAtIndex:0];
  NSString *urlString = [command argumentAtIndex:1];
  id parameters = [command argumentAtIndex:2];
  NSDictionary *headers = [command argumentAtIndex:3];

  FetchPlugin* __weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [[BaseClient sharedClient] dataTaskWithHTTPMethod:method URLString:urlString parameters:parameters headers:headers[@"map"] success:^(NSURLSessionDataTask *task, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [dictionary setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
      [dictionary setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSURLSessionTask *task, NSError *error, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
      [dictionary setObject:[response allHeaderFields] forKey:@"headers"];
    }
    
    [dictionary setObject:[error localizedDescription] forKey:@"error"];
    
    if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
      [dictionary setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"statusText"];
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
  
  [dataTask resume];
}

@end
