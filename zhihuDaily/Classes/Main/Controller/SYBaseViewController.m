//
//  SYBaseViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYBaseViewController.h"
#import "Masonry.h"
#import "SYRefreshView.h"


@interface SYBaseViewController ()

@property (nonatomic, strong) UIImageView *sy_headerBackgroundView;

@property (nonatomic, strong) UILabel *sy_titleLabel;

@property (nonatomic, strong) UIButton *sy_backButton;

@property (nonatomic, weak) SYRefreshView *refreshView;

@end

@implementation SYBaseViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self.view addSubview:self.sy_header];
}



#pragma mark event handler
- (void)sy_back {
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark setter & getter
- (void)setTitle:(NSString *)title {
    self.sy_titleLabel.text = title;
    [super setTitle:title];
}

- (UIView *)sy_header {
    if (!_sy_header) {
        _sy_header = [[UIView alloc] init];
        _sy_header.frame = CGRectMake(0, 0, kScreenWidth, 64);
        _sy_header.backgroundColor = kGroundColor;
        _sy_header.clipsToBounds = YES;
        
        [_sy_header addSubview:self.sy_headerBackgroundView];
        [_sy_header addSubview:self.sy_titleLabel];
        [_sy_header addSubview:self.sy_backButton];
        
        [self.sy_headerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(_sy_header).offset(-40);
            make.right.mas_equalTo(_sy_header).offset(40);
            make.bottom.mas_equalTo(_sy_header);
        }];
        
        [self.sy_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_sy_header.mas_top).offset(42);
            make.centerX.mas_equalTo(_sy_header);
            make.width.mas_lessThanOrEqualTo(kScreenWidth-88);
            
        }];
    }
    return _sy_header;
}


- (UIImageView *)sy_headerBackgroundView {
    if (!_sy_headerBackgroundView) {
        _sy_headerBackgroundView = [[UIImageView alloc] init];
        _sy_headerBackgroundView.contentMode = UIViewContentModeCenter;
    }
    return _sy_headerBackgroundView;
}


- (UILabel *)sy_titleLabel {
    if (!_sy_titleLabel) {
        _sy_titleLabel = [[UILabel alloc] init];
        _sy_titleLabel.textColor = kWhiteColor;
        _sy_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sy_titleLabel;
}

- (UIButton *)sy_backButton {
    if (!_sy_backButton) {
        _sy_backButton = [[UIButton alloc] init];
        [_sy_backButton setImage:[UIImage imageNamed:@"Field_Back"] forState:UIControlStateNormal];
        _sy_backButton.frame = CGRectMake(0, 20, 44, 44);
        [_sy_backButton addTarget:self action:@selector(sy_back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sy_backButton;
}

- (void)setSy_attachScrollView:(UIScrollView *)sy_attachScrollView {
    if (!sy_attachScrollView) return;
    if (_sy_attachScrollView) return; // once only

    _sy_attachScrollView = sy_attachScrollView;
    SYRefreshView *refresh = [SYRefreshView refreshViewWithScrollView:sy_attachScrollView];
    [self.sy_header addSubview:refresh];
    _refreshView = refresh;
    WEAKSELF;
    [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.sy_titleLabel);
        make.right.mas_equalTo(ws.sy_titleLabel.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}


- (UIImageView *)sy_backgoundImageView {
    return self.sy_headerBackgroundView;
}

- (SYRefreshView *)sy_refreshView {
    return self.refreshView;
}

@end
