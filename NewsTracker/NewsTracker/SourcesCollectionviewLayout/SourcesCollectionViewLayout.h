//
//  SourcesCollectionViewLayout.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SourcesLayoutDelegate

- (CGFloat)collectionView:(UICollectionView*)collectionView heightForPhotoAtIndexPath:(NSIndexPath*)indexPath withWidth:(CGFloat)width;
- (CGFloat)collectionView:(UICollectionView*)collectionView heightForDescriptionAtIndexPath:(NSIndexPath*)indexPath withWidth:(CGFloat)width;

@end

@interface SourcesCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SourcesLayoutDelegate> delegate;

@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat cellPadding;

- (void)cleanCache;

@end
