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

@interface SYImageView ()

@property (nonatomic, weak) UIImageView *imageView;


@property (nonatomic, weak) UIButton *downLoadButton;

@end


@implementation SYImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SYColor(128, 128, 128, 0.4);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    WEAKSELF;
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    
    [self.imageView addGestureRecognizer:tap];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIButton *downLoadButton = [[UIButton alloc] init];
    [downLoadButton setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
    [self addSubview:downLoadButton];
    self.downLoadButton = downLoadButton;
    [downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws);
        make.right.mas_equalTo(ws).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [downLoadButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self remove];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}



+ (void)showImageWithURLString:(NSString *)url {
    SYImageView *view = [[self alloc] init];
    
    view.frame = kScreenBounds;
    view.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    view.alpha = 0.0;
    [view setImage:url];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        view.imageView.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }];
}


- (void)setImage:(NSString *)imgUrl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.imageView.image = image;
    }];
    
    
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self remove];
    });
    
}
@end
