//
//  SYImageView.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYImageView.h"
#import "Masonry.h"
#import "SDWebImageManager.h"

#import "MBProgressHUD+YS.h"
#import "SYLoadingLayer.h"

#import "MBProgressHUD+YS.h"

@interface SYImageView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIScrollView *containerView;

@property (nonatomic, weak) UIScrollView *imageContainer;


@property (nonatomic, weak) UIButton *downLoadButton;

@property (nonatomic, strong) NSString *current;

@end


@implementation SYImageView

#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SYColor(128, 128, 128, 0.4);
        self.frame = kScreenBounds;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIScrollView *containerView = [[UIScrollView alloc] init];
    self.containerView = containerView;
    containerView.frame = kScreenBounds;
    containerView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight);
    containerView.contentOffset = CGPointMake(kScreenWidth, 0);
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.pagingEnabled = YES;
    containerView.delegate = self;
    [self addSubview:containerView];
    
    UIScrollView *imageContainer = [[UIScrollView alloc] init];
    imageContainer.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    self.imageContainer = imageContainer;
    [containerView addSubview:imageContainer];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageContainer addSubview:imageView];
    imageView.frame = imageContainer.bounds;
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tap];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIButton *downLoadButton = [[UIButton alloc] init];
    [downLoadButton setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
    [self addSubview:downLoadButton];
    self.downLoadButton = downLoadButton;
    
    downLoadButton.frame = CGRectMake(kScreenWidth-60, kScreenHeight-60, 40, 40);
    [downLoadButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark private
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self remove];
}


- (void)remove {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)saveImage {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [MBProgressHUD showError:@"无法读取相册"];
    }
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    [MBProgressHUD showSuccess:@"已保存至相册"];
}


#pragma mark scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x<kScreenWidth*0.5) {
        // prev
        if ([self.delegate respondsToSelector:@selector(prevImageOfImageView:current:)]) {
            NSString *img = [self.delegate prevImageOfImageView:self current:self.current];
            if (img.length) {
                [scrollView setContentOffset:CGPointMake(2*kScreenWidth, 0) animated:NO];
                [self setImage:img];
            } else {
                [MBProgressHUD showError:@"已经是第一张了"];
            }
        }
    } else if (scrollView.contentOffset.x > kScreenWidth*1.5) {
        // next
        if ([self.delegate respondsToSelector:@selector(nextImageOfImageView:current:)]) {
            NSString *img = [self.delegate nextImageOfImageView:self current:self.current];
            if (img.length) {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self setImage:img];
            } else {
                [MBProgressHUD showError:@"已经是最后张了"];
            }
        }
        
    }
    [scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}




#pragma mark setter & getter
- (void)setImage:(NSString *)imgUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    self.current = imgUrl;
    self.imageView.image = nil;
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.imageView.image = image;
        //self.containerView.contentSize = image.size;
        
    }];
}


+ (instancetype)showImageWithURLString:(NSString *)url {
    SYImageView *view = [[self alloc] init];
    
    view.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    view.alpha = 0.0;
    [view setImage:url];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        view.imageView.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }];
    
    return view;
}

@end
