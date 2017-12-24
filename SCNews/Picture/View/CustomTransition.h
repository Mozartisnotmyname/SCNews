//
//  CustomTransition.h
//  PuBuLiu
//
//  Created by 王艳清 on 16/7/1.
//  Copyright © 2016年 王艳清. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransitionType) {
    push,
    pop
};

@interface CustomTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(TransitionType)type;

@end
