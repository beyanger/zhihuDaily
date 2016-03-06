//
//  SYStoryListController.m
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYStoryListController.h"
#import "SYDetailController.h"
#import "SYTableViewCell.h"

static NSString *theme_reuseid = @"useid";

@interface SYStoryListController ()

@property (nonatomic, strong) UITableView *tableView;

@end



@implementation SYStoryListController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Table view delegete & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theme_reuseid forIndexPath:indexPath];
    
    cell.story = self.stories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYDetailController *dvc = [[SYDetailController alloc] init];
    dvc.delegate = self;
    dvc.story = self.stories[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}



#pragma mark deltail controller delegate
- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {
    NSInteger location = [self loacateStory:story];
    if (location == self.stories.count-1) {
        return nil;
    }
    return self.stories[location+1];
}
- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController story:(SYStory *)story {
    NSInteger location = [self loacateStory:story];
    if (location == 0) {
        return nil;
    }
    return self.stories[location-1];
}

- (NSInteger)loacateStory:(SYStory *)story {
    for (NSInteger i = 0; i < self.stories.count; i++) {
        if (self.stories[i].id == story.id) {
            return i;
        }
    }
    return -1;
}
- (SYStoryPositionType)detailController:(SYDetailController *)detailController story:(SYStory *)story {
    if (self.stories.count == 1 && self.stories.firstObject.id == story.id)
        return SYStoryPositionTypeFirstAndLast;
    if (self.stories.firstObject.id == story.id) {
        return SYStoryPositionTypeFirst;
    } else if ( self.stories.lastObject.id == story.id) {
        return SYStoryPositionTypeLast;
    }
    return SYStoryPositionTypeOther;
}


#pragma mark setter & getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-60);
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        [_tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:theme_reuseid];
    }
    return _tableView;
}

- (NSArray<SYStory *> *)stories {
    if ([self isKindOfClass:[SYStoryListController class]]) {
        NSLog(@"你需要自己实现");
    }
    return nil;
}

@end
