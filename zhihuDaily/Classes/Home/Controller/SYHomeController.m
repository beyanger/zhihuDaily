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
#import "SYZhihuTool.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface SYHomeController () <SYDetailControllerDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, weak) SYDetailController *currentDetailController;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray<SYLastestGroup *> *storyGroup;
@property (nonatomic, strong) NSMutableArray<SYStory *> *topStory;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, weak) UIScrollView *picturesView;

@end


static NSString *reuseid = @"useid";
@implementation SYHomeController

- (NSMutableArray *)allAritcle {
    if (!_storyGroup) {
        _storyGroup = [@[] mutableCopy];
    }
    return _storyGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTableView];
    [self picturesView];
    [self headerView];
    [self leftButton];
    [self titleLabel];
  
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"SYTableViewCell" bundle:nil] forCellReuseIdentifier:@"useid"];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [SYZhihuTool getLastestStoryWithCompleted:^(id obj) {
        SYLastestParamResult *result = (SYLastestParamResult *)obj;

        SYLastestGroup *group = [[SYLastestGroup alloc] init];
        group.stories = result.stories;
        
        self.storyGroup = [@[group] mutableCopy];
        self.topStory = [result.top_stories mutableCopy];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatePictureView];
            [self.tableView reloadData];
        });
    }];
    
}

- (void)updatePictureView {
    WEAKSELF(ws);
    CGRect frame = self.picturesView.frame;
    self.picturesView.contentSize = CGSizeMake(kScreenWidth*self.topStory.count, frame.size.height);
    for (NSUInteger i = 0 ; i < self.topStory.count; i++) {
        SYStory *story = self.topStory[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, frame.size.height);
        [self.picturesView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
        
        
    }

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
    dc.position = indexPath.row==(group.stories.count-1) ? -1 : indexPath.row;
    
    //self.currentDetailController = dc;
    [self presentViewController:dc animated:YES completion:nil];
}



- (SYStory *)nextStoryForDetailController:(SYDetailController *)detailController {
    SYLastestGroup *group = self.storyGroup[self.currentIndexPath.section];
    if (self.currentIndexPath.row >= group.stories.count-1) {
        return nil;
    }
    
    SYStory *story = group.stories[self.currentIndexPath.row+1];
    detailController.story = story;
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:self.currentIndexPath.section];
    
    
    detailController.position = self.currentIndexPath.row==(group.stories.count-1) ? -1 : self.currentIndexPath.row;
    
    return story;
}

- (SYStory *)prevStoryForDetailController:(SYDetailController *)detailController {
    SYLastestGroup *group = self.storyGroup[self.currentIndexPath.section];
    if (self.currentIndexPath.row <= 0) {
        return nil;
    }
    SYStory *story = group.stories[self.currentIndexPath.row-1];
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row-1 inSection:self.currentIndexPath.section];
    
    detailController.position = self.currentIndexPath.row==(group.stories.count-1) ? -1 : self.currentIndexPath.row;
    return story;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 80;
        tableView.showsVerticalScrollIndicator = NO;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        tableView.tableHeaderView = view;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (UIView *)headerView {
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 56);
        headerView.backgroundColor = SYColor(23, 144, 211, 1.);
        
        headerView.alpha = 0.0;
        _headerView = headerView;
    }
    return _headerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        
        NSDictionary *attr = @{
            NSFontAttributeName:[UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName:[UIColor redColor]};
        
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"今日要闻" attributes:attr];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(kScreenWidth*0.5, 35);
        _titleLabel = titleLabel;
        [self.view addSubview:titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] init];
        leftButton.frame = CGRectMake(10, 30, 30, 30);
        [leftButton addTarget:self action:@selector(didClickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        [self.view addSubview:leftButton];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UIScrollView *)picturesView {
    if (!_picturesView) {
        UIScrollView *picturesView = [[UIScrollView alloc] init];
        picturesView.frame = CGRectMake(0, -45, kScreenWidth, 245);
        [self.view addSubview:picturesView];
        _picturesView = picturesView;
    }
    return _picturesView;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.tableView.contentOffset.y < 0) {
            self.picturesView.frame = CGRectMake(0, -45, kScreenWidth, 245-self.tableView.contentOffset.y);
        }
    }
    
}


@end
