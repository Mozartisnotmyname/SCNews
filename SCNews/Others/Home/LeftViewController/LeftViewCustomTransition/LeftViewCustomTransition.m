//
//  LeftViewCustomTransition.m
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "LeftViewCustomTransition.h"
#import "LeftViewController.h"
#import "RadioViewController.h"
#import "ListeningViewController.h"
#import "RecordingViewController.h"
#import "ReadingViewController.h"
#import "Size.h"


@interface LeftViewCustomTransition ()

@property (nonatomic, assign) TransitionType type;
@property (nonatomic, assign) WhichViewController whichViewController;


@end

@implementation LeftViewCustomTransition


- (instancetype)initWithTransitionType:(TransitionType)type whichViewController: (WhichViewController)whichViewController {
    if (self = [super init]) {
        _type = type;
        _whichViewController = whichViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}



- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case push:
            [self doPushAnimation:transitionContext];
            break;
        case pop:
            [self doPopAnimation:transitionContext];
            break;
        default:
            break;
    }
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_whichViewController) {
        case Radio:
        {
            LeftViewController *fromVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            RadioViewController *toVC = (RadioViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view aboveSubview:fromVC.view];
            
            //自定义动画
            toVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
            toVC.view.alpha = 1.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                //fromVC.view.transform = CGAffineTransformMakeTranslation(-320, -568);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                [transitionContext completeTransition:YES];
                
            }];
        }
            break;
        case Listening:
        {
            LeftViewController *fromVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            ListeningViewController *toVC = (ListeningViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view aboveSubview:fromVC.view];
            
            //自定义动画
            toVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
            toVC.view.alpha = 1.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                //fromVC.view.transform = CGAffineTransformMakeTranslation(-320, -568);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                [transitionContext completeTransition:YES];
                
            }];
        }
            break;
        case Recording:
        {
            LeftViewController *fromVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            RecordingViewController *toVC = (RecordingViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view aboveSubview:fromVC.view];
            
            //自定义动画
            toVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
            toVC.view.alpha = 1.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                //fromVC.view.transform = CGAffineTransformMakeTranslation(-320, -568);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                [transitionContext completeTransition:YES];
                
            }];
        }
            
            break;
        case Reading:
        {
            LeftViewController *fromVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            ReadingViewController *toVC = (ReadingViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view aboveSubview:fromVC.view];
            //自定义动画
            
            toVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
            toVC.view.alpha = 1.0;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                //fromVC.view.transform = CGAffineTransformMakeTranslation(-320, -568);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                [transitionContext completeTransition:YES];
                
            }];
        }
            break;
        default:
            break;
    }
    
    
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_whichViewController) {
        case Radio:
        {
            RadioViewController *fromVC = (RadioViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            LeftViewController *toVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view belowSubview:fromVC.view];
            
            //自定义动画
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                fromVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
                
                //toVC.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
            }];
        }
            break;
        case Listening:
        {
            ListeningViewController *fromVC = (ListeningViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            LeftViewController *toVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view belowSubview:fromVC.view];
            
            //自定义动画
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                fromVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
                
                //toVC.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
            }];
        }
            break;
        case Recording:
        {
            RecordingViewController *fromVC = (RecordingViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            LeftViewController *toVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view belowSubview:fromVC.view];
            
            //自定义动画
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                fromVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
                
                //toVC.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
            }];
        }
            break;
        case Reading:
        {
            ReadingViewController *fromVC = (ReadingViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            LeftViewController *toVC = (LeftViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            //添加toView到上下文
            [[transitionContext containerView] insertSubview:toVC.view belowSubview:fromVC.view];
            
            //自定义动画
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                
                fromVC.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
                
                //toVC.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                fromVC.view.transform = CGAffineTransformIdentity;
                
                // 声明过渡结束时调用 completeTransition: 这个方法
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
            }];
        }
            break;
        default:
            break;
    }
    
}



@end
