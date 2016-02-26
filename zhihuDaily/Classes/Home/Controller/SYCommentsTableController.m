//
//  SYCommentsTableController.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentsTableController.h"
#import "SYCommentCell.h"
#import "SYZhihuTool.h"
#import "UINavigationBar+Awesome.h"
static NSString *comment_reuseid = @"comment_reuseid";

@interface SYCommentsTableController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *allComments;

@property (nonatomic, strong) SYCommentCell *prototypeCell;
@end

@implementation SYCommentsTableController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";

    [self setupTableView];
    
    [self setupDataSource];
    
    [self setupBackBtn];
}

- (void)dealloc
{
    
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 60, kScreenWidth, kScreenHeight-104);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SYCommentCell" bundle:nil] forCellReuseIdentifier:comment_reuseid];
}

- (void)setupBackBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor lightGrayColor];
    button.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(backGo) forControlEvents:UIControlEventTouchUpInside];
}


- (void)backGo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupDataSource {
    [SYZhihuTool getLongCommentsWithId:self.story.id completed:^(id obj) {
        self.allComments[@(0)] = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

    [SYZhihuTool getShortCommentsWithId:self.story.id completed:^(id obj) {
        self.allComments[@(1)] = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allComments.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *comments = self.allComments[@(section)];
    return comments.count;
}


- (SYCommentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:comment_reuseid forIndexPath:indexPath];

    NSArray *array = self.allComments[@(indexPath.section)];
    
    cell.comment = array[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 180;
    
    
}

- (NSMutableDictionary *)allComments {
    if (!_allComments) {
        _allComments = [@{} mutableCopy];
    }
    return _allComments;
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
