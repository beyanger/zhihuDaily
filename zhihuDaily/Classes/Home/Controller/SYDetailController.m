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
#import "SYCommentParam.h"
#import "SYRecommendController.h"
#import "SYRecommenderResult.h"
#import "SYLoginViewController.h"
#import "SYAccount.h"
#import "SYZhihuTool.h"
#import "MBProgressHUD+YS.h"
#import "AppDelegate.h"
#import "SYLoginController.h"

@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate, UIScrollViewDelegate, SYImageViewDelegate, SYShareViewDelegate>

@property (nonatomic, strong) SYTopView   *topView;
@property (nonatomic, strong) SYTableHeader *headerView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *footer;
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, weak) UIImageView *upArrow;
@property (nonatomic, weak) UIImageView *downArrow;

@property (nonatomic, strong) SYStoryNavigationView *storyNav;

@property (nonatomic, strong) NSArray<NSString *> *allImages;

@property (nonatomic, strong) NSArray<SYEditor *> *recommenders;


@property (nonatomic, strong) SYRecommenderResult *recommender;

@property (nonatomic, assign) BOOL isCollected;

@end

@implementation SYDetailController

#pragma mark life cycle
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

#pragma mark event action
- (void)tapHandler {
    SYRecommendController *rc = [[SYRecommendController alloc] init];
    
    if (self.recommender.editors.count > 0) {
        rc.editors = [self.recommender.editors arrayByAddingObjectsFromArray:self.recommender.items.lastObject.recommenders];
    } else {
        rc.editors = self.recommender.items.lastObject.recommenders;
    }

    
    [self.navigationController pushViewController:rc animated:YES];
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
            SYShareView *shareView = [SYShareView shareViewWithTitle:self.isCollected?@"取消收藏":@"收藏"];
            shareView.delegate = self;
            [shareView show];
        }
            break;
        
        case 4: {// comment
            SYCommentsController *ctc = [[SYCommentsController alloc] init];
            
            SYExtraStory *es =  self.storyNav.extraStory;
            SYCommentParam *param = [SYCommentParam commentWithId:self.story.id longComments:es.long_comments shortComment:es.short_comments];
            ctc.param = param;
            
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
    
    if ([absoString hasPrefix:@"http://daily.zhihu.com/story"]) {
        return YES;
    } else if ([absoString hasPrefix:@"http://mp.weixin.qq.com/s"]) {
        return YES;
    } else if([absoString hasPrefix:@"detailimage:"]) {
        NSString *url = [absoString substringFromIndex:@"detailimage:".length];
        SYImageView *imageView = [SYImageView showImageWithURLString:url];
        imageView.delegate = self;
        return NO;
    } else if ([absoString hasPrefix:@"http://"] || [absoString hasPrefix:@"https://"]) {
        SYWebViewController *nav = [[SYWebViewController alloc] init];
        nav.request = request;
        [self.navigationController pushViewController:nav animated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    SYStoryPositionType position = [self.delegate detailController:self story:self.story];

    BOOL isFirst = !!(position & SYStoryPositionTypeFirst);
    self.header.text = isFirst ? @"已经是第一篇" : @"载入上一篇";
    self.downArrow.hidden = isFirst;
    BOOL isLast = !!(position & SYStoryPositionTypeLast);
    self.footer.text = isLast ? @"已经是最后一篇了" : @"载入下一篇";
    self.upArrow.hidden = isLast;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整字号
    BOOL font = [kUserDefaults boolForKey:@"大号字"];
    if (font) {
        NSString *str = @"document.body.style.webkitTextSizeAdjust='120%';";
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
    
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
    
    self.allImages = [imageUrls componentsSeparatedByString:@"...beyanger...."];
#pragma todo 设置图片浏览界面的上一张和下一张功能
}

#pragma mark webView.scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat yoffset = scrollView.contentOffset.y;
    CGAffineTransform transform = CGAffineTransformIdentity;
    SYStory *story = nil;
    if (yoffset < -80) {
        story = [self.delegate prevStoryForDetailController:self story:self.story];
        transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } else if ((kScreenHeight -60 - scrollView.contentSize.height + yoffset) > 80) {
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
    
    if ([self currentTopView] == self.topView) {
        if (yoffset > 220) Black_StatusBar;
        else White_StatusBar;
    } else Black_StatusBar;
    
    
    if (yoffset < 0) {
        if (self.topView == [self currentTopView]) {
            self.topView.frame = CGRectMake(0, -40, kScreenWidth, 260-yoffset);
        }
        self.header.transform = CGAffineTransformMakeTranslation(0, -yoffset);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (yoffset < -80.) transform = CGAffineTransformMakeRotation(M_PI);
        
        if (!CGAffineTransformEqualToTransform(self.downArrow.transform, transform)) {
            [UIView animateWithDuration:0.25 animations:^{
                self.downArrow.transform = transform;
            }];
        }
    } else {
        if (self.topView == [self currentTopView]) {
            self.topView.frame = CGRectMake(0, -40-yoffset, kScreenWidth, 260);
        }
        
        CGFloat boffset = kScreenHeight-80-scrollView.contentSize.height + yoffset;
        
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


#pragma mark imageView delegate
- (NSString *)prevImageOfImageView:(SYImageView *)imageView current:(NSString *)current {
    NSInteger location = [self locateImage:current];
    if (location==0 || location == -1) {
        return nil;
    }
    return self.allImages[location-1];
}
- (NSString *)nextImageOfImageView:(SYImageView *)imageView current:(NSString *)current {
    NSInteger location = [self locateImage:current];
    if (location==(self.allImages.count-1) || location==-1) {
        return nil;
    }
    return self.allImages[location+1];
}
- (NSInteger)locateImage:(NSString *)image {
    for (NSUInteger i = 0; i < self.allImages.count; i++) {
        if ([self.allImages[i] isEqualToString:image]) {
            return i;
        }
    }
    return -1;
}


#pragma mark shareView delegate
- (void)shareView:(SYShareView *)shareView didSelected:(NSUInteger)index {
    if (kAccount.isLogin) {
        if (self.isCollected) {
            [MBProgressHUD showSuccess:@"取消收藏"];
            [SYZhihuTool cancelCollectedWithStroy:self.story];
        } else {
            [MBProgressHUD showSuccess:@"收藏成功"];
            [SYZhihuTool collectedWithStroy:self.story];
        }
        self.isCollected = !self.isCollected;
    } else {
        SYLoginController *loginvc = [[SYLoginController alloc] init];
        [self presentViewController:loginvc animated:YES completion:nil];
        
    }
    
}



#pragma mark setter & getter
- (void)setStory:(SYStory *)story {
    if (!story) return;
    _story = story;
    
    
    // 查询收藏状态
    self.isCollected = [SYZhihuTool queryCollectedStatusWithStory:story];
    
    // 设置 extraStory
    [SYZhihuTool getExtraWithId:self.story.id completed:^(id obj) {
        SYExtraStory *es = (SYExtraStory *)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.storyNav.extraStory = es;
        });
    }];
    
    
    [SYZhihuTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = obj;

            if (ds.image) { // 有图
                self.headerView.hidden = YES;
                self.topView.hidden = NO;
                self.topView.story = ds;
            } else if (ds.recommenders.count > 0) { // 有推荐者
                // 设置顶部推荐者的头像
                NSMutableArray *avatars = [@[] mutableCopy];
                for (SYRecommender *recommender in ds.recommenders) {
                    [avatars addObject:recommender.avatar];
                    self.headerView.avatars = avatars;
                }
                self.headerView.hidenMoreIndicator =  self.headerView.avatars.count <= 5;
                
                self.headerView.hidden = NO;
                self.topView.hidden = YES;
                // 设置顶部推荐者的下一级控制器的数据源，可以放在点击之后获取
                // 这里预先获取，以免点击之后再获取，增强用户体验
                [SYZhihuTool getStoryRecommendersWithId:story.id completed:^(id obj) {
                    self.recommender = obj;
                }];

                // 为推荐者插入一段40高度的hodler
                // 这里返回到数据有问题
                // 长度小于200 说明返回的值为空，需要加载story的网页版
                if (ds.htmlStr.length < 200) {
                    NSString *desturl = [NSString stringWithFormat:@"http://daily.zhihu.com/story/%lld", story.id];
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:desturl]]];
                    // 这里需要让
                    return;
                } else {
                    NSString *insert = @"<div style=\"height:40px\"></div>";
                    NSRange loc = [ds.htmlStr rangeOfString:insert];
                    if (loc.location == NSNotFound) {
                        // 如果没找到高度为40 的holder，那么插入之
                        NSMutableString *htmlStr = [ds.htmlStr mutableCopy];
                        NSRange range = [htmlStr rangeOfString:@"<body>"]; // 插入到body之后
                        [htmlStr insertString:insert atIndex:range.location+range.length];
                        ds.htmlStr = [htmlStr copy];
                    }
                }
                
            } else { // 啥也没有
                self.headerView.hidden = YES;
                self.topView.hidden = YES;
            }

            [self.webView loadHTMLString:ds.htmlStr baseURL:nil];
            
        });
    }];
    

}


- (SYTopView *)topView {
    if (!_topView) {
        _topView = [SYTopView topView];
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, -40, kScreenWidth, 220+40);
        _topView.hidden = YES;
    }
    return _topView;
}


- (SYTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [SYTableHeader headerViewWitTitle:@"推荐者" rightViewType:SYRightViewTypeMore];
        _headerView.frame = CGRectMake(0, -40, kScreenWidth, 60+40);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
        [_headerView addGestureRecognizer:tap];
        // 初始状态应该是被隐藏的，由数据决定其是否显示
        _headerView.hidden = YES;
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
        _storyNav = [SYStoryNavigationView storyNaviView];
        _storyNav.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
        [self.view addSubview:_storyNav];
        _storyNav.delegate = self;
    }
    return _storyNav;
}

- (UIView *)currentTopView {
//    if (!self.topView.hidden) {
//        return self.topView;
//    } else if (!self.headerView.hidden) {
//        return self.headerView;
//    }
//    return nil;
    
    return !self.topView.hidden ? self.topView : (!self.headerView.hidden ? self.headerView : nil);
}

@end
