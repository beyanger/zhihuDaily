//
//  SYStoryListController.h
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYBaseViewController.h"
#import "SYDetailController.h"

@interface SYStoryListController : SYBaseViewController <UITableViewDataSource, UITableViewDelegate, SYDetailControllerDelegate>


- (NSArray<SYStory *> *)stories;

- (UITableView *)tableView;

@end
