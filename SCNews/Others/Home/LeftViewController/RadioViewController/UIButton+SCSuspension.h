//
//  UIButton+SCSuspension.h
//  悬浮球Test1
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SCSuspension)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
