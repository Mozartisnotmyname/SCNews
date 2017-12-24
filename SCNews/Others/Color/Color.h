//
//  Color.h
//  SC News Test01 热点
//
//  Created by 凌       陈 on 10/24/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SetColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Color : NSObject

@end
