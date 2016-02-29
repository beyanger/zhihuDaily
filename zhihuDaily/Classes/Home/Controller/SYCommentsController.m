//
//  SYCommentsTableController.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentsController.h"
#import "SYCommentCell.h"
#import "SYZhihuTool.h"
#import "UINavigationBar+Awesome.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SYCommentView.h"
#import "SYCommentPannel.h"
#import "MBProgressHUD+YS.h"


static NSString *comment_reuseid = @"comment_reuseid";

@interface SYCommentsController () <UITableViewDataSource, UITableViewDelegate, SYCommentPannelDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray<SYComment *> *> *allComments;

@property (nonatomic, weak) SYCommentPannel *pannel;

@property (nonatomic, weak) SYCommentCell *cell;


@end

@implementation SYCommentsController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    [self setupTableView];
    
    [self setupDataSource];
    
    [self setupBackBtn];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-100) style:UITableViewStylePlain];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    [tableView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
    [tableView addGestureRecognizer:tap];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SYCommentCell" bundle:nil] forCellReuseIdentifier:comment_reuseid];
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [longGesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        self.cell = [self.tableView cellForRowAtIndexPath:indexPath];
        self.pannel = [self addCommentViewWithLocation:location];
    } else if (longGesture.state == UIGestureRecognizerStateBegan) {
        [self removeCommentPannel];
    }
}

- (void)tapHandler {
    [self removeCommentPannel];
}


#pragma mark commentView delegate
- (void)commentView:(SYCommentPannel *)commentView didClicked:(NSUInteger)index {
    
    SYComment *comment = self.cell.comment;
    if (index == 0) {
        BOOL isLike = !comment.isLike;
        comment.likes += isLike?+1:-1;
        comment.isLike = isLike;
    } else if (index == 2) {
        [UIPasteboard generalPasteboard].string = comment.content;
        [MBProgressHUD showSuccess:@"复制成功"];
    }
    [self removeCommentPannel];
}

- (void)removeCommentPannel {
    
    SYCommentPannel *pannel = self.pannel;
    
    if (pannel) {
        [UIView animateWithDuration:0.2 animations:^{
            pannel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [pannel removeFromSuperview];
        }];
    }
    self.pannel = nil;
    self.cell = nil;
}


- (SYCommentPannel *)addCommentViewWithLocation:(CGPoint)location {
    SYCommentPannel *cv = [SYCommentPannel commentPannelWithLiked:self.cell.comment.isLike];
    cv.delegate  = self;
    cv.center = CGPointMake(kScreenWidth*0.5, location.y-20);
  
    cv.alpha = 0;
    [self.tableView addSubview:cv];
    [UIView animateWithDuration:0.5 animations:^{
        cv.alpha = 1.0;
    }];
    return cv;
}


- (void)setupBackBtn {
    SYCommentView *commentView = [SYCommentView commentView];
    commentView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGo)];
    [commentView addGestureRecognizer:tap];
    
    [self.view addSubview:commentView];
}


- (void)backGo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupDataSource {
    [SYZhihuTool getLongCommentsWithId:self.param.id completed:^(id obj) {
        self.allComments[0] = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

    [SYZhihuTool getShortCommentsWithId:self.param.id completed:^(id obj) {
        self.allComments[1] = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void)dealloc {
    [self removeCommentPannel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count =  (self.allComments.firstObject.count!=0) + (self.allComments.lastObject.count!=0);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!section && self.allComments.firstObject.count) {
        return self.allComments.firstObject.count;
    }
    return self.allComments.lastObject.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!section && self.allComments.firstObject.count) {
        return [NSString stringWithFormat:@"%ld条长评论", self.param.long_comments];
    }
    
    return [NSString stringWithFormat:@"%lu条短评论", self.param.short_comments];
}

- (SYCommentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:comment_reuseid forIndexPath:indexPath];
    
    cell.comment = self.allComments[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height =  [tableView fd_heightForCellWithIdentifier:comment_reuseid configuration:^(SYCommentCell *cell) {
        cell.comment = self.allComments[indexPath.section][indexPath.row];
    }];
    
    ;
    return height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self removeCommentPannel];
}


- (NSMutableArray<NSArray<SYComment *> *> *)allComments {
    if (!_allComments) {
        _allComments = [@[@[], @[]] mutableCopy];
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
