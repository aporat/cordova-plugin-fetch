#import "CordovaFetchPlugin.h"
#import "CDVFile.h"
#import "BaseClient.h"

@interface CordovaFetchPlugin()

@end


@implementation CordovaFetchPlugin

- (void)pluginInitialize {
}

- (void)fetch:(CDVInvokedUrlCommand *)command {
  NSString *method = [command.arguments objectAtIndex:0];
  NSString *urlString = [command.arguments objectAtIndex:1];
  NSDictionary *parameters = [command.arguments objectAtIndex:2];

  CordovaFetchPlugin* __weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [[BaseClient sharedClient] dataTaskWithHTTPMethod:method URLString:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    
    if (responseObject !=nil && [responseObject isKindOfClass:[NSData class]]) {
      [dictionary setObject:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] forKey:@"data"];
    }

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSURLSessionTask *task, NSError *error, id responseObject) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:@"status"];
    [dictionary setObject:[error localizedDescription] forKey:@"error"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dictionary];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
  
  [dataTask resume];
}

@end
