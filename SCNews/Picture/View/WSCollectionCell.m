//
//  WSCollectionCell.m
//  瀑布流
//
//  Created by iMac on 16/12/26.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "WSCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation WSCollectionCell




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageInfo = ImageInfo.sharedManager;
        [self creatSubView];
        
    }
    return self;
}

- (void)creatSubView {
    
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.tag = 10;
    [self addSubview:imgV];
    
    UIView *labelView = [[UIView alloc] init];
    labelView.tag = 20;
    [self addSubview:labelView];
    
    
    UIVisualEffectView *visulEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visulEffectView.tag = 21;
    [labelView addSubview:visulEffectView];
    
    UILabel *label = [[UILabel alloc]init];
    label.tag = 22;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [labelView addSubview:label];
}



-(void)setModel:(CellModel *)model {
    
    _model = model;
    UIImageView *imgV = (UIImageView *)[self viewWithTag:10];
    UIView *labelView = (UIView *)[self viewWithTag:20];
    UIVisualEffectView *visulEffectView = (UIVisualEffectView *)[self viewWithTag:21];
    UILabel *label = (UILabel *)[self viewWithTag:22];

    imgV.frame = self.bounds;
    labelView.frame = CGRectMake(0, self.frame.size.height-16, self.frame.size.width, 16);
    visulEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(labelView.frame), CGRectGetHeight(labelView.frame));
    label.frame = CGRectMake(0, 0, CGRectGetWidth(labelView.frame), 10);
    
    __weak typeof(self) weakSelf = self;
    [imgV sd_setImageWithURL:[NSURL URLWithString:_model.imgURL]
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload
                              progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                      float progress = 0;
//                                      if (expectedSize != 0) {
//                                          progress = (float)receivedSize / (float)expectedSize;
//                                      }
//                                      weakSelf.progressView.hidden = NO;
//                                      [weakSelf.progressView setProgress:progress animated:YES];
                                  });
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 _model.image = image;
                                 [_imageInfo.imageArray addObject:_model];

                             }];
    label.text = _model.title;
    
}

@end
