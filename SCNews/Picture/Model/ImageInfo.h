//
//  ImageInfo.h
//  SCNews
//
//  Created by 凌       陈 on 11/7/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageInfo : NSObject

@property (nonatomic, strong)NSMutableArray *imageArray;


+(ImageInfo *)sharedManager;

@end
