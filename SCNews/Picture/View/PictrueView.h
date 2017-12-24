//
//  PictrueView.h
//  SCNews
//
//  Created by 凌       陈 on 11/6/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictrueView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *label;

@end
