//
//  ArticleModel.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.author = [dictionary objectForKey:@"author"];
        self.title = [dictionary objectForKey:@"title"];
        self.articleDescription = [dictionary objectForKey:@"description"];
        self.URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        self.imageURL = [NSURL URLWithString:[dictionary objectForKey:@"urlToImage"]];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd'T'HH:mm:ssZ"];
        self.publishedAt = [dateFormatter dateFromString:[dictionary objectForKey:@"publishedAt"]];
    }
    return self;
}

@end
