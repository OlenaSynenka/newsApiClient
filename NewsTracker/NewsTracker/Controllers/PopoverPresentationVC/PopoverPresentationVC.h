//
//  PopoverPresentationVC.h
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverPresentationDelegate <NSObject>

- (void)categoryPopoverDone:(NSString *)category;

@end

@interface PopoverPresentationVC : UIViewController

@property (strong, nonatomic) NSArray *categoryArray;

@property (weak, nonatomic) id <PopoverPresentationDelegate> popoverPresentationDelegate;

@end

