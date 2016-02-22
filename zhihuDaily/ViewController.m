//
//  ViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "ViewController.h"
#import "SYMainToolBox.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) SYMainToolBox *toolBox;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    static BOOL flag = YES;
    if (flag) {
    SYMainToolBox *toolBox = [[[NSBundle mainBundle] loadNibNamed:@"SYMainToolBox" owner:nil options:nil] firstObject];
        self.toolBox = toolBox;
    toolBox.delegate = self;
    toolBox.dataSource = self;
    
    toolBox.frame = CGRectMake(-self.view.frame.size.width*0.6, 0, self.view.frame.size.width*0.6, self.view.frame.size.height);
    [self.view addSubview:toolBox];
    [UIView animateWithDuration:0.28 animations:^{
        toolBox.frame = CGRectMake(0, 0, self.view.frame.size.width*0.6, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    } else {
    
        [UIView animateWithDuration:0.28 animations:^{
            self.toolBox.frame = CGRectMake(-self.view.frame.size.width*0.6, 0, self.view.frame.size.width*0.6, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self.toolBox removeFromSuperview];
        }];
    }
    flag = !flag;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse_id = @"reuse_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse_id];
    }
    cell.textLabel.text = @"nihao";
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
