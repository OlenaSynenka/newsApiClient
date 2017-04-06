//
//  NetworkService.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkService : NSObject

- (void) getSourcesInCategory:(NSString*)category
                   language:(NSString*)language
                      success:(void (^)(id  myResults))success;

- (void) getArticlesForSource:(NSString*)source
                      success:(void (^)(id  myResults))success;

@end
