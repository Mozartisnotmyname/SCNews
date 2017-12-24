//
//  UIImage+Extension.m
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
- (UIImage *)circleImage
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪
    CGContextClip(context);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
