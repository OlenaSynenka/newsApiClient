//
//  SourceModel.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SourceModel.h"

@implementation SourceModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.sourceDescription = [dictionary objectForKey:@"description"];
        self.category = [dictionary objectForKey:@"category"];
        self.language = [dictionary objectForKey:@"language"];
        self.logoURL = [NSURL URLWithString:[[dictionary objectForKey:@"urlsToLogos"] objectForKey:@"large"]];
    }
    return self;
}

@end
