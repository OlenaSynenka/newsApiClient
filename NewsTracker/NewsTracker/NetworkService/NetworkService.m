//
//  NetworkService.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "NetworkService.h"
#import "NewsApiHTTPClient.h"
#import "SourceModel.h"
#import "ArticleModel.h"

#define API_Key             @"5b5a855fd1bc47508bdcdf3e1c16d3ee"

@implementation NetworkService

- (void) getSourcesInCategory:(NSString*)category
                     language:(NSString*)language
                      success:(void (^)(id  myResults))success {
    NSString *tenantURL = [NSString stringWithFormat:@"/v1/sources"];
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
        NSArray *sourcesDictionaries = [responseObject objectForKey:@"sources"];
        NSMutableArray *sourcesObjects = [NSMutableArray new];
        for (NSDictionary *sourceDictionary in sourcesDictionaries) {
            SourceModel *source = [[SourceModel alloc] initWithDictionary:sourceDictionary];
            [sourcesObjects addObject:source];
        }
        success(sourcesObjects);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NewsApiHTTPClient sharedNewsApiHTTPClient] handleError:error];
    }];
}

- (void) getArticlesForSource:(NSString*)source
                      success:(void (^)(id  myResults))success {
    NSString *tenantURL = [NSString stringWithFormat:@"/v1/articles"];
    NSDictionary *params = @{@"apiKey" : API_Key, @"source" : source};
    [[NewsApiHTTPClient sharedNewsApiHTTPClient] GET:tenantURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *articlesDictionaries = [responseObject objectForKey:@"articles"];
        NSMutableArray *articlesObjects = [NSMutableArray new];
        for (NSDictionary *articleDictionary in articlesDictionaries) {
            ArticleModel *article = [[ArticleModel alloc] initWithDictionary:articleDictionary];
            [articlesObjects addObject:article];
        }

        success(articlesObjects);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NewsApiHTTPClient sharedNewsApiHTTPClient] handleError:error];
    }];

}

@end
