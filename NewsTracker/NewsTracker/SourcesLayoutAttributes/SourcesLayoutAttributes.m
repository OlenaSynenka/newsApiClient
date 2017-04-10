//
//  SourcesLayoutAttributes.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SourcesLayoutAttributes.h"

@interface SourcesLayoutAttributes()
@end

@implementation SourcesLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    SourcesLayoutAttributes *copy = [super copyWithZone:zone];
    copy.logoHeight = self.logoHeight;
    return copy;
}

- (BOOL)isEqual:(id)object {
    SourcesLayoutAttributes * attr = object;
    if (object) {
        if (attr.logoHeight == self.logoHeight) {
            return [super isEqual:object];
        }
    }
    return NO;
}

@end
