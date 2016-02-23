//
//  SYCommentCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYCommentCell.h"
#import "UIImageView+WebCache.h"

@interface SYCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;

@end


@implementation SYCommentCell

- (void)setComment:(SYComment *)comment {
    _comment = comment;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatar]];
    self.nameLabel.text = comment.author;
    self.commentLabel.text = comment.content;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld", comment.likes];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld", comment.time];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
