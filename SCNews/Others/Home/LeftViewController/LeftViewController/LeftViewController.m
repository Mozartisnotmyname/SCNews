//
//  LeftViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "LeftViewController.h"
#import "Masonry.h"
#import "Size.h"
#import "LeftViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "RadioViewController.h"
#import "ListeningViewController.h"
#import "RecordingViewController.h"
#import "ReadingViewController.h"


@interface LeftViewController ()

@property (nonatomic, strong) RadioViewController *radioViewController;
@property (nonatomic, strong) ListeningViewController *listeningViewController;
@property (nonatomic, strong) RecordingViewController *recordingViewController;
@property (nonatomic, strong) ReadingViewController *readingViewController;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubView];
    [self initViewController];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma  LeftViewController界面设置
-(void) setSubView {
    
    [self setTopView];
    [self setMidView];
    [self setBottomView];
    
}

#pragma  LeftViewController功能ViewController初始化
-(void) initViewController {
    _radioViewController = [RadioViewController new];
    _listeningViewController = [ListeningViewController new];
    _recordingViewController = [RecordingViewController new];
    _readingViewController = [ReadingViewController new];
}


#pragma  LeftViewController topView设置
-(void) setTopView {
    // top view初始化
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 5)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    // 用户头像设置
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height / 10 - 30, 60, 60)];
    _userImage.image = [UIImage imageNamed:@"cm4_default_user_40_58"];
    _userImage.backgroundColor = [UIColor grayColor];
    _userImage.layer.cornerRadius = 30;
    [_topView addSubview:_userImage];
    
    // 用户名设置
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height / 10 + 40 , 150, 30)];
    _userName.text = @"追风筝的人";
    _userName.font = [UIFont systemFontOfSize:17.0];
    _userName.textColor = [UIColor whiteColor];
    [_topView addSubview:_userName];
    

}

#pragma  LeftViewController midView设置
-(void) setMidView {
    // mid view 初始化
    _midView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5, self.view.frame.size.width, self.view.frame.size.height / 10 * 7)];
    _midView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_midView];
    
    self.titlesArray = @[@"Radio",
                         @"Listening",
                         @"Recording",
                         @"Reading"];
    //
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _midView.frame.size.width, _midView.frame.size.height) style:UITableViewStylePlain];
    [_tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_midView addSubview:_tableView];
    [_tableView reloadData];

}

#pragma  LeftViewController bottomView设置
-(void) setBottomView {
    // bottom view 初始化
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 10 * 9, self.view.frame.size.width, self.view.frame.size.height / 10)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
    
    _settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 125.0, _bottomView.frame.size.height)];
    _settingButton.titleLabel.textColor = [UIColor whiteColor];
    _settingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _settingButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"cm4_video_icn_setting"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"cm4_video_icn_setting_prs"] forState:UIControlStateHighlighted];
    //[_settingButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_settingButton.imageView.image.size.width, 0, _settingButton.imageView.image.size.width)];
    //[_settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, _settingButton.titleLabel.bounds.size.width, 0, -_settingButton.titleLabel.bounds.size.width)];
    [_settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_settingButton];
    
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(125.0, 0, 125.0, _bottomView.frame.size.height)];
   
    _exitButton.titleLabel.textColor = [UIColor whiteColor];
    _exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _exitButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [_exitButton setImage:[UIImage imageNamed:@"cm4_pro_btn_icn_arr"] forState:UIControlStateNormal];
    [_exitButton setImage:[UIImage imageNamed:@"cm4_pro_btn_icn_arr_night"] forState:UIControlStateHighlighted];
    //[_exitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_exitButton.imageView.image.size.width, 0, _exitButton.imageView.image.size.width)];
    //[_exitButton setImageEdgeInsets:UIEdgeInsetsMake(0, _exitButton.titleLabel.bounds.size.width, 0, -_exitButton.titleLabel.bounds.size.width)];
    [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_exitButton];
    
    
}

#pragma  LeftViewController设置按键响应
-(void) settingAction {
    NSLog(@"你按了设置按键！");
}

#pragma  LeftViewController退出按键响应
-(void) exitAction {
    NSLog(@"你按了退出按键！");
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"cm4_radio_icn_drama"];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"cm4_radio_icn_3d"];
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"cm4_radio_icn_mic"];
    } else if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"cm4_radio_icn_novel"];
    }
    
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.row == 0) {
        
        [self presentViewController:_radioViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 1) {
        
         [self presentViewController:_listeningViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 2) {
        
         [self presentViewController:_recordingViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 3) {
        
         [self presentViewController:_readingViewController animated:YES completion:nil];
        
    }
}




@end
