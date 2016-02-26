//
//  SYChannelController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYThemeController.h"
#import "SYRefreshView.h"
#import "SYThemeHeaderView.h"
#import "SYThemeItem.h"
#import "SYZhihuTool.h"
#import "SYStory.h"


@interface SYThemeController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<SYStory *> *stories;
@property (nonatomic, strong) SYThemeItem *themeItem;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYThemeHeaderView *headerView;



@end

static NSString *theme_reuseid = @"theme_reuseid";

@implementation SYThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-60);
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (SYThemeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SYThemeHeaderView alloc] initWithAttachScrollView:self.tableView];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _headerView.backgroundColor = [UIColor purpleColor];
    }
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:theme_reuseid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theme_reuseid];
    }
    
    cell.textLabel.text = self.stories[indexPath.row].title;
    return cell;
}



- (void)setThemeid:(int)themeid {
    _themeid = themeid;
    [SYZhihuTool getThemeWithThemeId:themeid completed:^(id obj) {
        self.themeItem = obj;
        self.headerView.themeItem = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSArray<SYStory *> *)stories {
    return self.themeItem.stories;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
