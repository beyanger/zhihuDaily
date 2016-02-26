//
//  SYBaseViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYBaseViewController.h"
#import "Masonry.h"


@interface SYBaseViewController ()

@property (nonatomic, strong) UIImageView *sy_headerBackgroundView;

@property (nonatomic, strong) UILabel *sy_titleLabel;

@property (nonatomic, strong) UIButton *sy_backButton;

@end

@implementation SYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    [self.view addSubview:self.sy_headerBackgroundView];
    [self.view addSubview:self.sy_titleLabel];
    [self.view addSubview:self.sy_backButton];
    [self.sy_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.view.mas_top).offset(40);
        make.left.mas_equalTo(ws.view.mas_left).offset(44);
        make.right.mas_equalTo(ws.view.mas_right).offset(-44);
    }];
}

- (UIImageView *)sy_headerBackgroundView {
    if (!_sy_headerBackgroundView) {
        _sy_headerBackgroundView = [[UIImageView alloc] init];
        _sy_headerBackgroundView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _sy_headerBackgroundView.backgroundColor = SYColor(48, 127, 255, 1.0);;
    }
    return _sy_headerBackgroundView;
}



- (UILabel *)sy_titleLabel {
    if (!_sy_titleLabel) {
        _sy_titleLabel = [[UILabel alloc] init];
        _sy_titleLabel.textColor = [UIColor whiteColor];
        _sy_titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _sy_titleLabel;
}

- (UIButton *)sy_backButton {
    if (!_sy_backButton) {
        _sy_backButton = [[UIButton alloc] init];
        [_sy_backButton setImage:[UIImage imageNamed:@"Field_Back"] forState:UIControlStateNormal];
        _sy_backButton.frame = CGRectMake(0, 20, 40, 40);
        [_sy_backButton addTarget:self action:@selector(sy_back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sy_backButton;
}

- (void)sy_back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setTitle:(NSString *)title {
    self.sy_titleLabel.text = title;
    [super setTitle:title];
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
