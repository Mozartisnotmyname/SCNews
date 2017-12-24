//
//  RadioModel.h
//  SCNews
//
//  Created by 凌       陈 on 11/14/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *streamUrl;
@property (nonatomic, strong) NSString *imageUrl;

@end
