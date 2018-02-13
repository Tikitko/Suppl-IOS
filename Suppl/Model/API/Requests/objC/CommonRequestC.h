#import <Foundation/Foundation.h>

@interface CommonRequestC : NSObject   {
    
@private
    NSURLSession *defaultSession;
    NSURLSessionDataTask *dataTask;
}
- (instancetype)init;
- (void)request:(NSString*)url query:(NSDictionary*)query inMain:(BOOL)inMain taskCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))taskCallback;

@end
