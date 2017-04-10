//
//  SourcesCollectionViewLayout.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SourcesCollectionViewLayout.h"
#import "SourcesLayoutAttributes.h"

@interface SourcesCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray<SourcesLayoutAttributes *> *cache;

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;

@end

@implementation SourcesCollectionViewLayout

- (void)prepareLayout {
    
    [self setStartValues];
    
    if (self.cache.count < 1) {
        CGFloat columnWidth = self.contentWidth / self.numberOfColumns;
        NSMutableArray *xOffset = [NSMutableArray new];
        for (int column = 0; column < self.numberOfColumns; ++column) {
            [xOffset addObject:[NSNumber numberWithFloat:(column * columnWidth)]];
        }
        
        NSInteger column = 0;
        NSMutableArray *yOffset = [[NSMutableArray alloc] initWithCapacity:self.numberOfColumns];
        for (int i = 0; i < self.numberOfColumns; ++i) {
            [yOffset addObject:[NSNumber numberWithFloat:0]];
        }
        
        for ( int i = 0; i < [self.collectionView numberOfItemsInSection:0]; ++i ) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            CGFloat width = columnWidth - self.cellPadding * 2;
            CGFloat photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath withWidth:width];
            CGFloat annotationHeight = [self.delegate collectionView:self.collectionView heightForDescriptionAtIndexPath:indexPath withWidth:width];
            CGFloat height = self.cellPadding +  photoHeight + annotationHeight + self.cellPadding;
            CGRect frame = CGRectMake([[xOffset objectAtIndex:column] floatValue], [[yOffset objectAtIndex:column] floatValue], columnWidth, height);
            CGRect insetFrame = CGRectInset(frame, self.cellPadding, self.cellPadding);
            
            SourcesLayoutAttributes *attributes = [SourcesLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = insetFrame;
            [self.cache addObject:attributes];
            
            self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
            [yOffset replaceObjectAtIndex:column withObject:[NSNumber numberWithFloat:([[yOffset objectAtIndex:column] floatValue] + height)]];
            if ( column >= self.numberOfColumns -1) {
                column = 0;
            } else {
                column++;
            }
//column = column >= (self.numberOfColumns - 1) ? 0 : ++column;
        }
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray new];
    
    for ( UICollectionViewLayoutAttributes *attributes in self.cache ) {
        if (CGRectIntersectsRect(attributes.frame, rect) ) {
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}

+ (Class)layoutAttributesClass {
   return [SourcesLayoutAttributes class];
}

- (void)cleanCache {
    [self.cache removeAllObjects];
    self.contentHeight = 0.0;
}

#pragma mark - Private
- (void)setStartValues {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.cache = [NSMutableArray new];
        self.numberOfColumns = 2;
        self.cellPadding = 0.6;
        self.contentHeight = 0.0;
        UIEdgeInsets insets = self.collectionView.contentInset;
        self.contentWidth = CGRectGetWidth(self.collectionView.bounds) - (insets.left + insets.right);
    });
}

@end
