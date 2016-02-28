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
#import "SYCommentsTableController.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate, UIScrollViewDelegate>





@property (nonatomic, strong) SYTopView   *topView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *footer;
@property (nonatomic, strong) UILabel *header;

@property (nonatomic, weak) UIImageView *upArrow;
@property (nonatomic, weak) UIImageView *downArrow;

@property (nonatomic, strong) SYStoryNavigationView *storyNav;




@end

@implementation SYDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.topView];
    [self.view addSubview:self.header];
    [self.view addSubview:self.footer];
    
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
            SYCommentsTableController *ctc = [[SYCommentsTableController alloc] init];
            ctc.story = self.story;
            [self.navigationController pushViewController:ctc animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    
}


- (SYTopView *)topView {
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"SYTopView" owner:self options:nil] firstObject];
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, -60, kScreenWidth, 220+40);
    }
    return _topView;
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-40-20);
        _webView = webView;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat yoffset = scrollView.contentOffset.y;
    if ( yoffset < -60) {
        self.story  = [self.delegate prevStoryForDetailController:self story:self.story];
    } else if ((kScreenHeight -60 - scrollView.contentSize.height + yoffset) > 60) {
        self.story  = [self.delegate nextStoryForDetailController:self story:self.story];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yoffset = scrollView.contentOffset.y;
    if (yoffset > 220) {
        Black_StatusBar;
    } else {
        White_StatusBar;
    }
    
    if (yoffset < 0) {
        self.topView.frame = CGRectMake(0, -60, kScreenWidth, 260-yoffset);
        self.header.transform = CGAffineTransformMakeTranslation(0, -yoffset);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (yoffset < -60.) transform = CGAffineTransformMakeRotation(M_PI);
        
        if (!CGAffineTransformEqualToTransform(self.downArrow.transform, transform)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.downArrow.transform = transform;
            }];
        }
    } else {
        self.topView.frame = CGRectMake(0, -60-yoffset, kScreenWidth, 260);
    
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
        
        header.textColor = [UIColor whiteColor];
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


- (void)setStory:(SYStory *)story {
    if (!story) return;
    _story = story;
 
    
    [SYZhihuTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = (SYDetailStory *)obj;
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




@end
