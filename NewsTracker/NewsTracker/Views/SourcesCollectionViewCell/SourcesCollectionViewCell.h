//
//  SourcesCollectionViewCell.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourcesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sourceLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceNameLabel;

@end
