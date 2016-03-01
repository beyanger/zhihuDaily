//
//  SYEditorCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorCell.h"
#import "UIImageView+WebCache.h"

@interface SYEditorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editorImageView;

@end

@implementation SYEditorCell


- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 18;
    self.avatarImageView.clipsToBounds = YES;
    self.editorImageView.hidden = YES;
}


- (void)setEditor:(id)obj {
    _editor = obj;
    
    if ([obj isKindOfClass:[SYEditor class]]) {
        SYEditor *editor = obj;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:editor.avatar]];
        self.nameLabel.text = editor.name;
        self.bioLabel.text = editor.bio;
        self.editorImageView.hidden = NO;
    } else if ([obj isKindOfClass:[SYRecommender class]]) {
        SYRecommender *recommender = obj;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommender.avatar]];
        self.nameLabel.text = recommender.name;
        self.bioLabel.text = recommender.bio;
        self.editorImageView.hidden = YES;
    }
}

static NSString *editor_reuseid = @"editor_reuseid";
+ (instancetype)editorCellWithTableView:(UITableView *)tableView {
    
    SYEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:editor_reuseid];
    //[cell.editorImageView removeFromSuperview];
    cell.editorImageView.alpha = 0.0;
    return cell;
}

+ (instancetype)recommenderCellWithTableView:(UITableView *)tableView {
    SYEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:editor_reuseid];
    
    return cell;
}






@end
