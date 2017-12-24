//
//  LeftViewCustomTransition.h
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransitionType) {
    push,
    pop
};

typedef NS_ENUM(NSInteger, WhichViewController) {
    Radio,
    Listening,
    Recording,
    Reading
};

@interface LeftViewCustomTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(TransitionType)type whichViewController: (WhichViewController)whichViewController;

@end
