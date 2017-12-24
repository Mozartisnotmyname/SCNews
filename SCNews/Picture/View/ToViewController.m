//
//  ToViewController.m
//  PuBuLiu
//
//  Created by 王艳清 on 16/7/1.
//  Copyright © 2016年 王艳清. All rights reserved.
//

#import "ToViewController.h"




@interface ToViewController ()
{
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    NSInteger pictrueIndex;
}

@end

@implementation ToViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    self.topView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:_topView];
    
    // 向下滑动退出
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responseGlide)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp)];
    [self.topView  addGestureRecognizer:recognizer];
    
    
    _imageInfo = ImageInfo.sharedManager;
    
    pictrueIndex = _currentIndexPath.row;
    
    [self setupContentScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ss");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)setupContentScrollView {
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* _imageInfo.imageArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.topView insertSubview:contentScrollView atIndex:0];
    
    [_imageInfo.imageArray enumerateObjectsUsingBlock:^(CellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_currentIndexPath.row == obj.index) {
            *stop = YES;
            
            [contentScrollView setContentOffset:CGPointMake(pictrueIndex * ScreenWidth, 0) animated:NO];
            PictrueView *pictrueView = [[PictrueView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            pictrueView.image = obj.image;
            pictrueView.frame = CGRectMake(contentScrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            
            [contentScrollView addSubview:pictrueView];
            
        }
        
    }];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        
        endContentOffsetX = scrollView.contentOffset.x;
        if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) { //画面从右往左移动，前一页
            
            if (pictrueIndex > 0) {
                pictrueIndex--;
            }
            
        } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
            
            if (pictrueIndex < _imageInfo.imageArray.count) {
                pictrueIndex++;
            }
        }
        
        [_imageInfo.imageArray enumerateObjectsUsingBlock:^(CellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (pictrueIndex == obj.index) {
                *stop = YES;
                
                [scrollView setContentOffset:CGPointMake(pictrueIndex * ScreenWidth, 0) animated:NO];
                PictrueView *pictrueView = [[PictrueView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                pictrueView.image = obj.image;
                pictrueView.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
                
                [scrollView addSubview:pictrueView];
                
            }
            
        }];
        
        
    }
}


#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
    }
}

#pragma mark - 下滑退出detail控制界面
- (void)responseGlide {
    
    NSLog(@"向下手势");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 导航控制器的代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[CustomTransition alloc] initWithTransitionType:push];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[CustomTransition alloc] initWithTransitionType:pop];
}

@end
