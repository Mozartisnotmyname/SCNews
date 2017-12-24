//
//  LeftViewController.h
//  SCNews
//
//  Created by 凌       陈 on 11/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// 将LeftViewController分为三段，方便布局
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *bottomView;

// topView的信息
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIImageView *vipImage;

// midView的信息
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *myDownload;
@property (nonatomic, strong) UIImageView *scan;
@property (nonatomic, strong) UIImageView *radio;
@property (nonatomic, strong) UIButton *myDownloadBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UIButton *radioBtn;
@property (strong, nonatomic) NSArray *titlesArray;

// bottomView的信息
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *exitButton;

@end
