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
@property (weak, nonatomic) IBOutlet SYToolButton *collection;
@property (weak, nonatomic) IBOutlet SYToolButton *message;
@property (weak, nonatomic) IBOutlet SYToolButton *setting;

@end

@implementation SYMainToolBox


- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 25.0;
    self.collection.backgroundColor = [UIColor orangeColor];
    self.message.backgroundColor = [UIColor blueColor];
    self.setting.backgroundColor = [UIColor purpleColor];
    
}



- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.tableView.dataSource = dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.tableView.delegate = delegate;
}

@end
