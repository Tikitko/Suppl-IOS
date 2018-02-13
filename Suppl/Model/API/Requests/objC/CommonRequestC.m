#import "CommonRequestC.h"

@implementation CommonRequestC

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

- (void)request:(NSString*)url query:(NSDictionary*)query inMain:(BOOL)inMain taskCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))taskCallback;
{
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    if (components == NULL) {
        return;
    }
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in query) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:query[key]]];
    }
    components.queryItems = queryItems;
    dataTask = [defaultSession dataTaskWithURL:components.URL completionHandler:^(NSData* data, NSURLResponse *response, NSError *error)
                {
                    if (inMain == NO) {
                        taskCallback(data, response, error);
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            taskCallback(data, response, error);
                        });
                    }
                    dataTask = NULL;
                }
                ];
    [dataTask resume];
}
@end
