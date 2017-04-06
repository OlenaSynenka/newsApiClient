//
//  ArticleModel.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *articleDescription;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSDate *publishedAt;

@end
