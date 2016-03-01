//
//  SYCollectionController.m
//  zhihuDaily
//
//  Created by yang on 16/3/2.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCollectionController.h"
#import "SYZhihuTool.h"

@interface SYCollectionController ()

@property (nonatomic, strong) NSMutableArray<SYStory *> *collectionStroy;;

@end

@implementation SYCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";

    [SYZhihuTool getColltedStoriesWithCompleted:^(id obj) {
        self.collectionStroy = obj;
        [self.tableView reloadData];
    }];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"不再收藏";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.collectionStroy removeObject:self.stories[indexPath.row]];
        [self.tableView reloadData];
        // 更新到数据库中
        [SYZhihuTool cancelCollectedWithStroy:self.stories[indexPath.row]];
    }
}




- (NSArray<SYStory *> *)stories {
    return self.collectionStroy;
}


@end
