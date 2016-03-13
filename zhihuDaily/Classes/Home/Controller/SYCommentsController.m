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
#import "UIView+Extension.h"

static NSString *comment_reuseid = @"comment_reuseid";

@interface SYCommentsController () <UITableViewDataSource, UITableViewDelegate, SYCommentPannelDelegate, SYCommentCellDelegate>

@property (nonatomic, strong) NSMutableArray<NSMutableArray<SYComment *> *> *allComments;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYCommentView *commentView;

@property (nonatomic, weak) SYCommentPannel *pannel;
@property (nonatomic, weak) SYCommentCell *cell;
@end

@implementation SYCommentsController

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
    [self.tableView reloadData];
}


- (void)dealloc {
    [self removeCommentPannel];
}



#pragma mark event action
- (void)longPressHandler:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [longGesture locationInView:self.tableView];
        self.pannel = [self addCommentViewWithLocation:location];
    } else if (longGesture.state == UIGestureRecognizerStateBegan) {
        [self removeCommentPannel];
    }
    
}
- (void)tapPressHandler:(UITapGestureRecognizer *)tapGesture {
    if (self.pannel) {
        [self removeCommentPannel];
    } else {
        CGPoint location = [tapGesture locationInView:self.tableView];
        self.pannel = [self addCommentViewWithLocation:location];
    }
}

- (void)removeCommentPannel {
    SYCommentPannel *pannel = self.pannel;
    self.pannel = nil;
    self.cell = nil;
    if (pannel) {
        [UIView animateWithDuration:0.2 animations:^{
            pannel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [pannel removeFromSuperview];
        }];
    }
}


- (SYCommentPannel *)addCommentViewWithLocation:(CGPoint)location {
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
    self.cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!self.cell) return self.pannel;
    
    SYCommentPannel *cv = [SYCommentPannel commentPannelWithLiked:self.cell.comment.isLike];
    cv.delegate  = self;
   
    CGFloat xoffset = cv.width*0.5+12;
    
    if (location.x < xoffset) {
        cv.center = CGPointMake(xoffset, location.y-20);
    } else if (location.x > (kScreenWidth-xoffset)) {
        cv.center = CGPointMake(kScreenWidth-xoffset, location.y-20);
    } else {
        cv.center = CGPointMake(location.x, location.y-20);
    }
    
    cv.alpha = 0;
    [self.tableView addSubview:cv];
    [UIView animateWithDuration:0.5 animations:^{
        cv.alpha = 1.0;
    }];
    return cv;
}



#pragma mark - Table view  delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  (self.allComments.firstObject.count!=0) + (self.allComments.lastObject.count!=0);
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
  
    cell.delegate = self;
    if (!indexPath.section && self.allComments.firstObject.count) {
        cell.comment = self.allComments[indexPath.section][indexPath.row];
        return cell;
    }
    cell.comment = self.allComments.lastObject[indexPath.row];
    return cell;
}

//// 使用高度缓存的话，则cell的点击展开失效，所以使用系统自带的高度估算功能来高度自适应
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGFloat height =  [tableView fd_heightForCellWithIdentifier:comment_reuseid configuration:^(SYCommentCell *cell) {
//        if (!indexPath.section && self.allComments.firstObject.count) {
//            cell.comment = self.allComments[indexPath.section][indexPath.row];
//            return;
//        }
//        cell.comment = self.allComments.lastObject[indexPath.row];
//    }];
//    
//    return height;
//}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == self.allComments.lastObject.count-5) {
        [self loadMoreShortComments];
    }
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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

// cell里点击展开按钮的代理方法
- (void)commentCelll:(SYCommentCell *)cell actionType:(int)type {
    [self.tableView reloadData];
}



#pragma mark private method
- (void)loadMoreShortComments {
    
    if (self.allComments.lastObject.count == self.param.short_comments) {
        NSLog(@"没有更多短评论了....");
        return;
    }
    
    [SYZhihuTool getBeforeShortCommentsWithId:self.param.id commentid:self.allComments.lastObject.lastObject.id completed:^(id obj) {
        [self.allComments.lastObject addObjectsFromArray:obj];
        [self.tableView reloadData];
    }];
}
- (void)loadMoreLongComments {
    if (self.allComments.firstObject.count == self.param.long_comments) {
        NSLog(@"没有更多长评论了");
        return;
    }
    [SYZhihuTool getBeforeLongCommentsWithId:self.param.id commentid:self.allComments.firstObject.lastObject.id completed:^(id obj) {
        [self.allComments.firstObject addObjectsFromArray:obj];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}



#pragma mark setter & getter
- (void)setParam:(SYCommentParam *)param {
    _param = param;
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



- (NSMutableArray<NSMutableArray<SYComment *> *> *)allComments {
    if (!_allComments) {
        _allComments = [@[@[], @[]] mutableCopy];
    }
    return _allComments;
}


- (UITableView *)tableView {
    if (!_tableView) {
      
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-100) style:UITableViewStylePlain];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        [_tableView addGestureRecognizer:longPress];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressHandler:)];
        [_tableView addGestureRecognizer:tap];
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"SYCommentCell" bundle:nil] forCellReuseIdentifier:comment_reuseid];
        
        _tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (SYCommentView *)commentView {
    if (!_commentView) {
        _commentView = [SYCommentView commentView];
        _commentView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGo)];
        [_commentView addGestureRecognizer:tap];
    }
    return _commentView;
}

- (void)backGo {
    [self.navigationController popViewControllerAnimated:YES];
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
