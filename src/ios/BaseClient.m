#import "BaseClient.h"

@implementation BaseClient

+ (instancetype)sharedClient {
  static BaseClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[BaseClient alloc] init];
  });
  
  return _sharedClient;
}

- (id)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  return self;
}


#pragma mark -

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                         headers:(NSDictionary *)headers
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *, id))failure
{
  
  NSError *serializationError = nil;
  NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
  if (serializationError) {
    if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
      dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
        failure(nil, serializationError, nil);
      });
#pragma clang diagnostic pop
    }
    
    for (NSString *key in headers) {
      NSString *value = headers[key];
      [request setValue:value forHTTPHeaderField:key];
    }
    
    
    return nil;
  }
  
  __block NSURLSessionDataTask *dataTask = nil;
  dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
    if (error) {
      if (failure) {
        failure(dataTask, error, responseObject);
      }
    } else {
      if (success) {
        success(dataTask, responseObject);
      }
    }
  }];
  
  return dataTask;
}

@end