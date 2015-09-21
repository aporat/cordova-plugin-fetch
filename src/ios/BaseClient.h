#import "AFHTTPSessionManager.h"

@interface BaseClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *__nullable)dataTaskWithHTTPMethod:(NSString *__nullable)method
                                       URLString:(NSString *__nullable)URLString
                                      parameters:(id __nullable)parameters
                                         success:(void (^ __nullable)(NSURLSessionDataTask * __nullable, id __nullable))success
                                         failure:(void (^ __nullable)(NSURLSessionDataTask * __nullable, NSError * __nullable error, id __nullable))failure;

@end
