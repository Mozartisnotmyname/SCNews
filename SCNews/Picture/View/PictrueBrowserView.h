//
//  PictrueBrowserView.h
//  SCNews
//
//  Created by 凌       陈 on 11/5/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "PictrueView.h"
#import "WSCollectionCell.h"

#define ScreenWidth    UIScreen.mainScreen.bounds.size.width
#define ScreenHeight   UIScreen.mainScreen.bounds.size.height
#define ScreenBounds   UIScreen.mainScreen.bounds

typedef NS_ENUM(NSInteger, ScrollType) {
    LeftScroll,
    RightScroll
};

@interface PictrueBrowserView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) PictrueView *firstView;
@property (nonatomic, strong) PictrueView *secondView;
@property (nonatomic, strong) PictrueView *thirdView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

@property (nonatomic, assign) ScrollType scrollType;

@property (nonatomic, assign) NSMutableArray *cellArray;

@property (nonatomic, assign) NSInteger currentIndex;


@end
