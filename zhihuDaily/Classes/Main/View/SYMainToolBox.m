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


- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 25.0;
}


- (IBAction)didClickedButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuAction" object:nil];
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

@end
