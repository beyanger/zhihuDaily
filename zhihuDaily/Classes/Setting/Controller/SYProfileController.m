//
//  SYProfileController.m
//  zhihuDaily
//
//  Created by yang on 16/3/2.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYProfileController.h"
#import "UIImageView+WebCache.h"
#import "SYAccount.h"
#import "MBProgressHUD+YS.h"

@interface SYProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SYProfileController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我";
    
    self.avatarImageView.layer.cornerRadius = 40;
    self.avatarImageView.clipsToBounds = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:kAccount.avatar]];
    self.nameLabel.text = kAccount.name;
}

#pragma mark event handler
- (IBAction)logout:(UIButton *)sender {
    SYAccount *account = [SYAccount sharedAccount];
    [account logout];
    sender.enabled = NO;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:kAccount.avatar]];
    self.nameLabel.text = [SYAccount sharedAccount].name;
    [MBProgressHUD showSuccess:@"已经退出"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
