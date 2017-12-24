//
//  CustomTransition.m
//  PuBuLiu
//
//  Created by 王艳清 on 16/7/1.
//  Copyright © 2016年 王艳清. All rights reserved.
//

#import "CustomTransition.h"
#import "PictureViewController.h"
#import "ToViewController.h"

@interface CustomTransition ()

@property (nonatomic, assign) TransitionType type;

@end

@implementation CustomTransition

- (instancetype)initWithTransitionType:(TransitionType)type {
    if (self = [super init]) {
        _type = type;
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
    PictureViewController *fromVC = (PictureViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ToViewController *toVC = (ToViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到当前点击的cell的imageView
 
    UICollectionViewCell *cell = (UICollectionViewCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [cell snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell convertRect:cell.contentView.bounds toView: containerView];
    //设置动画前的各个控件的状态
    cell.hidden = YES;
    toVC.view.alpha = 0;
    toVC.topView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [toVC.topView convertRect:toVC.topView.bounds toView:containerView];
        toVC.view.alpha = 1;
    }completion:^(BOOL finished) {
        tempView.hidden = YES;
        toVC.topView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    ToViewController *fromVC = (ToViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PictureViewController *toVC = (PictureViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UICollectionViewCell *cell = (UICollectionViewCell *)[fromVC.collectionView cellForItemAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置初始状态
    cell.hidden = YES;
    fromVC.topView.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [cell.contentView convertRect:cell.contentView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            fromVC.topView.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
