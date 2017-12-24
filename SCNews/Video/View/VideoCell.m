//
//  VideoCell.m
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(VideoModel *)model{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = model.title;
    self.descriptionLabel.text = model.descriptionDe;
    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    if (model.playCount > 10000) {
        self.countLabel.text = [NSString stringWithFormat:@"%f万", model.playCount/10000.0];
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%ld", model.playCount];
    }
    
    self.timeDurationLabel.text = model.ptime;

}
@end
