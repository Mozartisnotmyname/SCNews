//
//  DataManager.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^onSuccess)(NSArray *sidArray,NSArray *videoArray);
typedef void(^onFailed)(NSError *error);

@interface DataManager : NSObject

@property(nonatomic,copy)NSArray *sidArray;
@property(nonatomic,copy)NSArray *videoArray;



+(DataManager *)shareManager;
- (void)getSIDArrayWithURLString:(NSString *)URLString success:(onSuccess)success failed:(onFailed)failed;

- (void)getVideoListWithURLString:(NSString *)URLString ListID:(NSString *)ID success:(onSuccess)success failed:(onFailed)failed;

@end
