//
//  NewsApiHTTPClient.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NewsApiHTTPClient : AFHTTPSessionManager

+ (NewsApiHTTPClient *)sharedNewsApiHTTPClient;
- (NSDictionary *)handleError:(NSError *)error;

@end
