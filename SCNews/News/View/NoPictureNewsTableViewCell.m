//
//  NoPictureNewsTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/14.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NoPictureNewsTableViewCell.h"

@interface NoPictureNewsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation NoPictureNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.newsTitleLabel.text = titleText;
}

-(void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    self.newsTitleLabel.text  = contentText;
}



@end
