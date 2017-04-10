//
//  SourcesCollectionViewCell.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SourcesCollectionViewCell.h"
#import "SourcesLayoutAttributes.h"

@implementation SourcesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    SourcesLayoutAttributes *attr = layoutAttributes;
    if (attr) {
        self.imageViewHeightLayoutConstraint.constant = attr.logoHeight;
    }
}

@end
