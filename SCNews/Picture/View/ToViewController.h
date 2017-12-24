//
//  ToViewController.h
//  PuBuLiu
//
//  Created by 王艳清 on 16/7/1.
//  Copyright © 2016年 王艳清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictrueBrowserView.h"
#import "CustomTransition.h"
#import "WSCollectionCell.h"
#import "PictrueView.h"
#import "ImageInfo.h"

@interface ToViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) PictrueBrowserView *pictrueBrowserView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) ImageInfo *imageInfo;

@end
