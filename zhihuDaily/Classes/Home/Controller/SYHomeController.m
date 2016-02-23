//
//  SYHomeController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYHomeController.h"
#import "SYStory.h"
#import "SYLastestGroup.h"
#import "YSHttpTool.h"
#import "MJExtension.h"
#import "SYLastestParamResult.h"
#import "SYTableViewCell.h"
#import "SYDetailController.h"
#import "SYStoryTool.h"

@interface SYHomeController () <SYDetailControllerDelegate>

@property (nonatomic, weak) SYDetailController *currentDetailController;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray<SYLastestGroup *> *storyGroup;

@end


static NSString *reuseid = @"useid";
@implementation SYHomeController


- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)allAritcle {
    if (!_storyGroup) {
        _storyGroup = [@[] mutableCopy];
    }
    return _storyGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    

    [SYStoryTool getLastestStoryWithCompleted:^(id obj) {
        SYLastestParamResult *result = (SYLastestParamResult *)obj;
        for (SYStory *story in result.stories) {
            for (SYStory *top_story in result.top_stories) {
                if (story.id == top_story.id) {
                    story.top = 1;
                }
            }
        }
        SYLastestGroup *group = [[SYLastestGroup alloc] init];
        group.stories = result.stories;
        
        self.storyGroup = [@[group] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:@"useid"];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(didClickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
  
}

- (void)didClickedMenuButton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuAction" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storyGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SYLastestGroup *group = self.storyGroup[section];
    return group.stories.count;
    
}

- (SYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    if (!cell) {
        cell = [[SYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    
    SYLastestGroup *group = self.storyGroup[indexPath.section];
    cell.story = group.stories[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuActionClose" object:nil];
    self.currentIndexPath = indexPath;
    
    SYLastestGroup *group = self.storyGroup[indexPath.section];
    SYStory *story = group.stories[indexPath.row];
    
    SYDetailController *dc = [[SYDetailController alloc] initWithStory:story];
    dc.delegate = self;
    self.currentDetailController = dc;
    [self presentViewController:dc animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}


- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController {

    SYLastestGroup *group = self.storyGroup[self.currentIndexPath.section];
    
    if (self.currentIndexPath.row >= group.stories.count-1) {
        return nil;
    }
    
    SYStory *story = group.stories[self.currentIndexPath.row+1];
    
    self.currentDetailController.story = story;
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:self.currentIndexPath.section];
    return story;
}

@end
