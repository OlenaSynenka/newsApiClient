//
//  NetworkService.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "NetworkService.h"
#import "NewsApiHTTPClient.h"

@implementation NetworkService

- (void) getSourcesInCategory:(NSString*)category
                     language:(NSString*)language
                      success:(void (^)(id  myResults))success {
    NSString *tenantURL = [NSString stringWithFormat:@"/sources"];
    NSMutableDictionary *params;
    if (category) {
        params = [@{ @"category" : category } mutableCopy];
    }
    if (language) {
        if (params) {
            [params setObject:language forKey:@"language"];
        } else {
            params = @{ @"language" : language };
        }
    }
    [[NewsApiHTTPClient sharedNewsApiHTTPClient] GET:tenantURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *sources = [responseObject objectForKey:@"sources"];
        success(sources);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NewsApiHTTPClient sharedNewsApiHTTPClient] handleError:error];
    }];
}

- (void) getArticlesForSource:(NSString*)source
                      success:(void (^)(id  myResults))success {
    NSString *tenantURL = [NSString stringWithFormat:@"/articles"];
    [[NewsApiHTTPClient sharedNewsApiHTTPClient] GET:tenantURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *articles = [responseObject objectForKey:@"articles"];
        success(articles);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NewsApiHTTPClient sharedNewsApiHTTPClient] handleError:error];
    }];

}

@end
