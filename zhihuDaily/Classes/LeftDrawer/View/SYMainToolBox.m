//
//  SYMainToolBox.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYMainToolBox.h"
#import "SYToolButton.h"

@interface SYMainToolBox ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;


@end

@implementation SYMainToolBox

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 20.0;
    self.avatarImage.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}


- (IBAction)didClickedButton:(UIButton *)sender {
    if ([self.toolBoxDelegate respondsToSelector:@selector(toolBox:didClickedTitle:)]) {
        [self.toolBoxDelegate toolBox:self didClickedTitle:sender.currentTitle];
    }
}


- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.tableView.dataSource = dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.tableView.delegate = delegate;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuActionClose" object:nil];
}

@end
