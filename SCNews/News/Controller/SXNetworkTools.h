//
//  SXNetworkTools.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.

#import <AFNetworking/AFNetworking.h>

@interface SXNetworkTools : AFHTTPSessionManager

+ (instancetype)sharedNetworkTools;
+ (instancetype)sharedNetworkToolsWithoutBaseUrl;

@end
