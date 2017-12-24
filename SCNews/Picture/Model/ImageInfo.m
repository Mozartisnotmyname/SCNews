//
//  ImageInfo.m
//  SCNews
//
//  Created by 凌       陈 on 11/7/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

static  ImageInfo*_sharedManager = nil;

+(ImageInfo *)sharedManager {
    @synchronized( [ImageInfo class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _imageArray = [NSMutableArray array];
    }
    return self;
}

@end
