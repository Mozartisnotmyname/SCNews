//
//  VideoCell.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//


#import <UIKit/UIKit.h>
@class VideoModel;
@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIV;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, retain) VideoModel *model;



@end
