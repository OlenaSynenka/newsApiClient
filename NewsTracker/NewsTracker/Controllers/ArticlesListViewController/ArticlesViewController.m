//
//  ArticlesViewController.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "ArticlesViewController.h"
#import "ArticleModel.h"
#import "NetworkService.h"
#import "ArticleTableViewCell.h"

#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <WebKit/WebKit.h>


@interface ArticlesViewController () <UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic, strong) NSMutableArray *articles;

@end

@implementation ArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.articlesTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArticleTableViewCell class])bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ArticleTableViewCell class])];
    
    self.articlesTableView.rowHeight = UITableViewAutomaticDimension;
    self.articlesTableView.estimatedRowHeight = 100;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkService *networkService = [NetworkService new];
    [networkService getArticlesForSource:self.sourceId
                                 success:^(id myResults) {
                                     self.articles = myResults;
                                     [self.articlesTableView reloadData];
                                     [hud hideAnimated:YES];
                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.articles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArticleTableViewCell class])];
    ArticleModel *article = [self.articles objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = article.title;
    cell.descriptionLabel.text = article.articleDescription;
    [cell.openLinkButton setTitle:[article.URL absoluteString] forState:UIControlStateNormal];
    
//    [cell.imageView sd_setImageWithURL:article.imageURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image) {
//            [cell.imageView setImage:image];
//        }
//    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    
    ArticleModel *article = [self.articles objectAtIndex:indexPath.section];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:article.URL];
    [webView loadRequest:urlRequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    for (UIView *view in [webView subviews]) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = view;
            [hud hideAnimated:YES];
            break;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
