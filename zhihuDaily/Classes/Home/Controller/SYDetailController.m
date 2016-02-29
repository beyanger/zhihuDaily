//
//  SYDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDetailController.h"
#import "SYStory.h"
#import "SYTopView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "SYWebViewController.h"
#import "SYZhihuTool.h"
#import "SYDetailStory.h"
#import "SYImageView.h"
#import "SYStoryNavigationView.h"
#import "SYShareView.h"
#import "SYCommentsController.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "SYTableHeader.h"


@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SYTopView   *topView;
@property (nonatomic, strong) SYTableHeader *headerView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *footer;
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, weak) UIImageView *upArrow;
@property (nonatomic, weak) UIImageView *downArrow;

@property (nonatomic, strong) SYStoryNavigationView *storyNav;

@property (nonatomic, strong) NSArray<SYEditor *> *recommenders;

@end

@implementation SYDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.header];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footer];
    [self.view bringSubviewToFront:self.storyNav];
    
    WEAKSELF;
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view);
        make.centerY.mas_equalTo(ws.view.mas_top).offset(-20);
    }];
    
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view);
        make.centerY.mas_equalTo(ws.view.mas_bottom);
    }];
}

#pragma mark bottom navigation delegate
- (void)storyNavigationView:(SYStoryNavigationView *)navView didClicked:(NSInteger)index {
    switch (index) {
        case 0: // pop
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1: // next
            self.story = [self.delegate nextStoryForDetailController:self story:self.story];
            
            break;
        case 2: // like
            
            break;
        case 3: { // share {
            SYShareView *shareView = [[NSBundle mainBundle] loadNibNamed:@"SYShareView" owner:nil options:nil].firstObject;
            [shareView show];
        }
            break;
        
        case 4: {// comment
            SYCommentsController *ctc = [[SYCommentsController alloc] init];
            ctc.story = self.story;
            [self.navigationController pushViewController:ctc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *absoString = request.URL.absoluteString;
    if ([absoString hasPrefix:@"http"]) {

        SYWebViewController *nav = [[SYWebViewController alloc] init];
        nav.request = request;
        [self.navigationController pushViewController:nav animated:YES];
        return NO;
        
    } else if ([absoString hasPrefix:@"detailimage:"]) {
        NSString *url = [absoString stringByReplacingOccurrencesOfString:@"detailimage:"
                                       withString:@""];
        [SYImageView showImageWithURLString:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    SYStoryPositionType position = [self.delegate detailController:self story:self.story];
    if (position == SYStoryPositionTypeFirst) {
        self.header.text = @"已经是第一篇";
        self.downArrow.hidden = YES;
        self.footer.text = @"载入下一篇";
        self.upArrow.hidden = NO;
    } else if (position == SYStoryPositionTypeOther) {
        self.header.text = @"载入上一篇";
        self.downArrow.hidden = NO;
        self.footer.text = @"载入下一篇";
        self.upArrow.hidden = NO;
    } else {
        self.header.text = @"载入上一篇";
        self.downArrow.hidden = NO;
        self.header.text = @"已经是最后一篇了";
        self.upArrow.hidden = YES;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整字号
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL font = [ud boolForKey:@"大号字"];
    NSString *str = [@"document.body.style.webkitTextSizeAdjust=" stringByAppendingString:font?@"'120%'":@"'100%'"];
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    
    
    NSString *string = @"var d = document.createElement(\"div\");"
                    "d.style.height=\"200px\";"
    "document.body.appendChild(d);";
    
    
    //[webView stringByEvaluatingJavaScriptFromString:string];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages = @"function setImages(){"\
    "var images = document.getElementsByTagName(\"img\");"\
    "for(var i=0;i<images.length;i++){"\
    "images[i].onclick=function(){"\
    "document.location=\"detailimage:\"+this.src;"\
    "};};return images.length;};";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    [webView stringByEvaluatingJavaScriptFromString:@"setImages()"];
    
    // 获取网页上的所有图片
    NSString *jsImage = @"var images= document.getElementsByTagName('img');"
                        "var imageUrls = \"\";"
                        "for(var i = 0; i < images.length; i++)"
                            "{var image = images[i];"
                            "imageUrls += image.src+\"...beyanger....\";"
                        "}"
                        "imageUrls.toString();";
    
    NSString *imageUrls = [webView stringByEvaluatingJavaScriptFromString:jsImage];
    
    NSArray *imageArray = [imageUrls componentsSeparatedByString:@"...beyanger...."];
#pragma todo 设置图片浏览界面的上一张和下一张功能
}

#pragma mark webView.scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat yoffset = scrollView.contentOffset.y;
    CGAffineTransform transform = CGAffineTransformIdentity;
    SYStory *story = nil;
    if (yoffset < -60) {
        story = [self.delegate prevStoryForDetailController:self story:self.story];
        transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } else if ((kScreenHeight -60 - scrollView.contentSize.height + yoffset) > 60) {
        story = [self.delegate nextStoryForDetailController:self story:self.story];
        transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    }
    if (!story) return;

    // 切换过程动画
    UIView *v = [self.view snapshotViewAfterScreenUpdates:NO];
    self.story = story;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, 3*kScreenHeight)];
    backView.backgroundColor = kWhiteColor;
    v.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    [backView addSubview:v];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [UIView animateWithDuration:0.25 animations:^{
        backView.transform = transform;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
        self.footer.transform = CGAffineTransformIdentity;
        self.header.transform = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yoffset = scrollView.contentOffset.y;
    
    if (yoffset > [self currentTopView].height-40) Black_StatusBar;
    else White_StatusBar;
    if (yoffset < 0) {
        if (self.topView == self.currentTopView) {
            self.topView.frame = CGRectMake(0, -40, kScreenWidth, 260-yoffset);
        }
        
        
        self.header.transform = CGAffineTransformMakeTranslation(0, -yoffset);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (yoffset < -60.) transform = CGAffineTransformMakeRotation(M_PI);
        
        if (!CGAffineTransformEqualToTransform(self.downArrow.transform, transform)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.downArrow.transform = transform;
            }];
        }
    } else {
    
        self.currentTopView.frame = CGRectMake(0, -40-yoffset, kScreenWidth, self.currentTopView.height);
        
        CGFloat boffset = kScreenHeight-60-scrollView.contentSize.height + yoffset;
        
        if (boffset > 0) {
            self.footer.transform = CGAffineTransformMakeTranslation(0, -boffset);
            CGAffineTransform transform = CGAffineTransformIdentity;
            if (boffset > 60.) transform = CGAffineTransformMakeRotation(M_PI);
            
            if (!CGAffineTransformEqualToTransform(self.upArrow.transform, transform)) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.upArrow.transform = transform;
                }];
            }
        }
    }
}

#pragma setter & getter
- (void)setStory:(SYStory *)story {
    if (!story) return;
    _story = story;
    
    [SYZhihuTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = (SYDetailStory *)obj;
            
            if (!ds.image) {
                NSMutableString *str = [ds.htmlStr mutableCopy];
                // 当有图片时，网页会自己添加一个高度200px的holder
                // 但网页没有图片时，需要给网页添加一个高度44px的 holder，用来添加推荐者很条幅
                NSRange range = [ds.htmlStr rangeOfString:@"<body>"];
                [str insertString:@"<div style=\"height: 40px\"></div>" atIndex:range.length+range.location];
                ds.htmlStr = [str copy];
                
                self.topView.hidden = YES;
                [SYZhihuTool getStoryRecommendersWithId:self.story.id completed:^(id obj) {
                    NSMutableArray *avatars = [@[] mutableCopy];
                    for (SYEditor *editor in obj) {
                        [avatars addObject:editor.avatar];
                    }
                    if (avatars.count > 0) {
                       self.headerView.avatars = avatars;
                        self.headerView.hidden = NO;
                    } else {
                        self.headerView.hidden = YES;
                    }
                }];
                
            } else {
                self.headerView.hidden = YES;
                self.topView.hidden = NO;
            }
            
            [self.webView loadHTMLString:ds.htmlStr baseURL:nil];
            self.topView.story = ds;
        });
    }];
    
    // 设置 extraStory
    [SYZhihuTool getExtraWithId:self.story.id completed:^(id obj) {
        SYExtraStory *es = (SYExtraStory *)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.storyNav.extraStory = es;
        });
    }];
}


- (UIView *)currentTopView {
    if (!self.topView.hidden) {
        return self.topView;
    } else if (!self.headerView.hidden) {
        return self.headerView;
    }
    return nil;
}

- (SYTopView *)topView {
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"SYTopView" owner:self options:nil] firstObject];
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, -40, kScreenWidth, 220+40);
        _topView.hidden = YES;
    }
    return _topView;
}

- (SYTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [SYTableHeader headerViewWitTitle:@"推荐者" hidenRight:YES];
        _headerView.frame = CGRectMake(0, -40, kScreenWidth, 64+40);
    }
    return _headerView;
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-40-20);
        _webView = webView;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = kWhiteColor;
    }
    return _webView;
}

- (UILabel *)footer {
    if (!_footer) {
        UILabel *footer = [[UILabel alloc] init];
        footer.textColor = [UIColor grayColor];
        footer.textAlignment = NSTextAlignmentCenter;
        footer.text = @"载入下一篇";
        _footer = footer;
        UIImage *image = [UIImage imageNamed:@"upArrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [footer addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(footer);
            make.right.mas_equalTo(footer.mas_left).offset(-10);
        }];
        _upArrow = imageView;
    }
    return _footer;
}

- (UILabel *)header {
    if (!_header) {
        UILabel *header = [[UILabel alloc] init];
        header.textColor = SYColor(231, 231, 231, 1.0);
        header.textAlignment = NSTextAlignmentCenter;
        header.text = @"载入上一篇";
        _header = header;
        UIImage *image = [UIImage imageNamed:@"downArrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [header addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(header);
            make.right.mas_equalTo(header.mas_left).offset(-10);
        }];
        _downArrow = imageView;
    }
    return _header;
}

- (SYStoryNavigationView *)storyNav {
    if (!_storyNav) {
        _storyNav = [[[NSBundle mainBundle] loadNibNamed:@"SYStoryNavigationView" owner:self options:nil] firstObject];
        _storyNav.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
        [self.view addSubview:_storyNav];
        _storyNav.delegate = self;
    }
    return _storyNav;
}


@end
