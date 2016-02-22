//
//  SYDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDetailController.h"
#import "SYStory.h"
#import "YSHttpTool.h"
#import "SYTopView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"


@interface SYDetailController () <UIWebViewDelegate>

@property (nonatomic, strong) SYStory *story;

@property (nonatomic, weak) SYTopView   *topView;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) UINavigationController *navController;

@end

@implementation SYDetailController

- (instancetype)initWithStory:(SYStory *)story
{
    self = [super init];
    if (self) {
        self.story = story;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lld", self.story.id];
    
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
   
        NSMutableString *htmlStr = [@"<html><head>" mutableCopy];
        
        NSArray *cssArray = dict[@"css"];
        NSArray *jsArray = dict[@"js"];
        
        if (jsArray.count >= 1) {
            for (NSString *url in jsArray) {
                [htmlStr appendFormat:@"<script src=\"%@\"></script>", url];
            }
        }
        
        if (cssArray.count >= 1) {
            for (NSString *url in cssArray) {
                [htmlStr appendFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">", url];
            }
        }
        
        [htmlStr appendFormat:@"</head><body>%@</body></html>", dict[@"body"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmlStr baseURL:nil];
            self.topView.title.text = dict[@"title"];
            [self.topView.image sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]]];
            self.topView.author.text = dict[@"image_source"];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"加载出错....");
    }];

    UIView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"SYBottomView" owner:self options:nil] firstObject];
    bottomView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [self.view addSubview:bottomView];
}


- (SYTopView *)topView {
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"SYTopView" owner:self options:nil] firstObject];
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        _topView.image.contentMode = UIViewContentModeScaleAspectFill;
        [self.webView.scrollView addSubview:_topView];
    }
    return _topView;
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-40);
        [self.view addSubview:webView];
        _webView = webView;
        _webView.delegate = self;
        [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString hasPrefix:@"http"]) {
        UIViewController *vc = [[UIViewController alloc] init];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [vc.view addSubview:webView];
        
        [webView loadRequest:request];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
        
        self.navController = nav;
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
        return NO;
    }
    
    return YES;
}

- (void)dismis {
    [self.navController dismissViewControllerAnimated:YES completion:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yoffset = [change[@"new"] CGPointValue].y;
        if (yoffset < 0) {
            self.topView.frame = CGRectMake(0, yoffset, kScreenWidth, 200-yoffset);
        }
        
    }
}



@end
