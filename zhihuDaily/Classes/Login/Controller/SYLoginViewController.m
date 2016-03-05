//
//  SYLoginViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLoginViewController.h"
#import "MBProgressHUD+YS.h"
#import "AppDelegate.h"

@interface SYLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;
@property (weak, nonatomic) IBOutlet UIButton *tencentButton;

@end

@implementation SYLoginViewController


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    Black_StatusBar;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark event handler
- (IBAction)back:(id)sender {
    White_StatusBar;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)login:(UIButton *)sender {
    [MBProgressHUD showSuccess:sender.currentTitle];
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
