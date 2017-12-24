//
//  PictrueBrowserView.m
//  SCNews
//
//  Created by 凌       陈 on 11/5/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "PictrueBrowserView.h"




@implementation PictrueBrowserView {
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int pictrueIndex;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delegate = self;
    
    self.showsHorizontalScrollIndicator = false;
    
    self.pagingEnabled = true;
    
    self.contentSize = CGSizeMake(ScreenWidth * 5, 0);
    
    
    _firstView = [[PictrueView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _firstView.backgroundColor = [UIColor blueColor];
    [self addSubview:_firstView];
    
    _secondView = [[PictrueView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
    _secondView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_secondView];
    
    _thirdView = [[PictrueView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight)];
    _thirdView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_thirdView];
    
    NSLog(@"屏幕的宽度：%f", ScreenWidth);
    NSLog(@"屏幕的高度：%f", ScreenHeight);
    
    pictrueIndex = 0;
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark -- scrollView代理
-(void) scrollViewDidScroll: (UIScrollView *)scrollView {
    
    double spread = self.contentOffset.x / ScreenWidth;
    
    _firstView.alpha =  1.0 - spread;
    
    _secondView.alpha = spread;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    endContentOffsetX = scrollView.contentOffset.x;
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) { //画面从右往左移动，前一页
        _scrollType = LeftScroll;
        
        if (pictrueIndex > 0) {
            pictrueIndex--;

        } else {
        
        }
        
        
        
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
        _scrollType = RightScroll;
        
        if (pictrueIndex < _cellArray.count) {
            pictrueIndex++;
        }
        
    }
    
   
    NSInteger index = (scrollView.contentOffset.x + ScreenWidth * 0.5) / ScreenWidth;
    if (index == 3) {
        //显示最后一张的时候，强制设置为第二张（也就是轮播图的第一张），这样就开始无限循环了
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else if (index == 0) {
        //显示第一张的时候，强制设置为倒数第二张（轮播图最后一张），实现倒序无限循环
        [scrollView setContentOffset:CGPointMake(2 * ScreenWidth, 0) animated:NO];
    }
}


@end
