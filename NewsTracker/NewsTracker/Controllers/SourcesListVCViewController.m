//
//  SourcesListVCViewController.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/6/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SourcesListVCViewController.h"
#import "SourcesCollectionViewCell.h"
#import "SourceModel.h"
#import "NetworkService.h"
#import "SourcesCollectionViewLayout.h"
#import "ArticlesViewController.h"
#import "PopoverPresentationVC.h"

#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface SourcesListVCViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SourcesLayoutDelegate, PopoverPresentationDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (nonatomic, strong) NSMutableArray *sources;
@property (nonatomic, strong) NSMutableArray *sourcesLogo;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *categoriesIDs;

@property (weak, nonatomic) IBOutlet UIButton *germanLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *englishLanguageButton;

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *language;


@end

@implementation SourcesListVCViewController


#pragma mark - IBActions
- (IBAction)engLanguageSelected:(id)sender {
    self.germanLanguageButton.selected = NO;
    if (!self.englishLanguageButton.selected) {
        self.englishLanguageButton.selected = YES;
        self.language = @"en";
    } else {
         self.englishLanguageButton.selected = NO;
        self.language = nil;
    }
    [self getSources];
}

- (IBAction)germanLanguageSelected:(id)sender {
    self.englishLanguageButton.selected = NO;
    if (!self.germanLanguageButton.selected) {
        self.germanLanguageButton.selected = YES;
        self.language = @"de";
    } else {
        self.germanLanguageButton.selected = NO;
         self.language = nil;
    }
    [self getSources];
}

- (IBAction)ChooseCategoryButtonClicked:(id)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SourcesCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([SourcesCollectionViewCell class])];
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[SourcesCollectionViewLayout class]]) {
        ((SourcesCollectionViewLayout*)self.collectionView.collectionViewLayout).delegate = self;
    }
    
    self.sourcesLogo = [NSMutableArray new];
    
    self.categories = @[@"Business", @"Entertainment", @"Gaming", @"General", @"Music", @"Politics", @"Science and Nature", @"Sport", @"Technology"];
    self.categoriesIDs = @[@"business", @"entertainment", @"gaming", @"general", @"music", @"politics", @"science-and-nature", @"sport", @"technology"];
    
    NetworkService *networkService = [NetworkService new];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkService getSourcesInCategory:nil language:nil success:^(id myResults) {
        self.sources = myResults;
        [hud hideAnimated:YES];
        [self.collectionView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)categoryButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showCategoryList" sender:self];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SourcesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SourcesCollectionViewCell class]) forIndexPath:indexPath];

    SourceModel *source  = [self.sources objectAtIndex:indexPath.row];
    [cell.sourceLogoImageView sd_setImageWithURL:source.logoURL
                                placeholderImage:nil
                                       completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (image) {
                                                   [cell.sourceLogoImageView setImage:image];
                                               }
                                           });
                                       }];
    cell.sourceNameLabel.text = source.name;

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showArticlesVC" sender:indexPath];
}

#pragma mark - SourcesLayoutDelegate

- (CGFloat)collectionView:(UICollectionView*)collectionView heightForPhotoAtIndexPath:(NSIndexPath*)indexPath withWidth:(CGFloat)width {
    SourceModel *source  = [self.sources objectAtIndex:indexPath.row];
    CGRect boundingRect =  CGRectMake(0, 0, width, CGFLOAT_MAX);
    CGRect rect  = AVMakeRectWithAspectRatioInsideRect([self sizeOfImageAtURL:source.logoURL], boundingRect);
    return rect.size.height;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView heightForDescriptionAtIndexPath:(NSIndexPath*)indexPath withWidth:(CGFloat)width {
    CGFloat annotationPadding = 4.;
    CGFloat annotationHeaderHeight = 17.;
    SourceModel *source  = [self.sources objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString: source.name attributes:attributesDictionary];
    CGRect commentRect = [attributedDescription boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat height = annotationPadding + annotationHeaderHeight + commentRect.size.height + annotationPadding;
    return height;
}

#pragma  mark - Private 

- (CGSize)sizeOfImageAtURL:(NSURL *)imageURL
{    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
    if (imageSource == NULL) {
        return CGSizeZero;
    }
    
    CGFloat width = 0.0f, height = 0.0f;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    
    CFRelease(imageSource);
    
    if (imageProperties != NULL) {
        
        CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberCGFloatType, &width);
        }
        
        CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberCGFloatType, &height);
        }
        
        CFRelease(imageProperties);
    }    return CGSizeMake(width, height);
}

- (void)getSources {
    NetworkService *networkService = [NetworkService new];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkService getSourcesInCategory:self.category language:self.language success:^(id myResults) {
        self.sources = myResults;
        [hud hideAnimated:YES];
        [((SourcesCollectionViewLayout*)self.collectionView.collectionViewLayout) cleanCache];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ArticlesViewController class]]) {
        NSIndexPath * indexPath = sender;
        ((ArticlesViewController*)segue.destinationViewController).sourceId = ((SourceModel*)[self.sources objectAtIndex:indexPath.item]).ID;
    } else {
        if ([[segue identifier]isEqualToString:@"showCategoryList"]) {
            PopoverPresentationVC *destinationPopoverVC = segue.destinationViewController;
            UIPopoverPresentationController *popoverVC = destinationPopoverVC.popoverPresentationController;
            
                destinationPopoverVC.popoverPresentationDelegate = self;
                destinationPopoverVC.categoryArray = self.categories;
            static CGFloat tableViewCellHeight = 40;
                destinationPopoverVC.preferredContentSize = CGSizeMake(destinationPopoverVC.preferredContentSize.width, (tableViewCellHeight * self.categories.count));
            
            if (popoverVC) {
                popoverVC.delegate = self;
            }
        }

    }
}

#pragma mark - PopoverPresentationDelegate
- (void)categoryPopoverDone:(NSString *)category {
    NSUInteger i = [self.categories indexOfObject:category];
    self.category = [self.categoriesIDs objectAtIndex:i];
    [self.categoryButton setTitle:category forState:UIControlStateNormal];;
    [self getSources];
}

#pragma mark - UIAdaptivePresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


         
@end
