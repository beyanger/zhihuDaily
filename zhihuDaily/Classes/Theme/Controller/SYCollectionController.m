//
//  SYCollectionController.m
//  zhihuDaily
//
//  Created by yang on 16/3/2.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCollectionController.h"
#import "SYZhihuTool.h"
#import "AppDelegate.h"

@interface SYCollectionController ()

@property (nonatomic, strong) NSMutableArray<SYStory *> *collectionStroy;;

@end

@implementation SYCollectionController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SYZhihuTool getColltedStoriesWithCompleted:^(id obj) {
        self.collectionStroy = obj;
        [self.tableView reloadData];
    }];
}



#pragma mark tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"不再收藏";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SYZhihuTool cancelCollectedWithStroy:self.stories[indexPath.row]];
        [self.collectionStroy removeObject:self.stories[indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 更新到数据库中
    
    }
}


#pragma mark setter & getter
- (NSArray<SYStory *> *)stories {
    return self.collectionStroy;
}


@end
