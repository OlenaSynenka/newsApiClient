//
//  SourceModel.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    business = 1,
    entertainment,
    gaming,
    general,
    music,
    politics,
    science_and_nature,
    sport,
    technology
} Category;

@interface SourceModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *sourceDescription;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSURL *logoURL;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
