//
//  UIImageView+Extension.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

-(void)TT_setImageWithURL:(NSURL *)url;

-(void)TT_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image, NSError *error))complete;

- (void)TT_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NSInteger)options progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progressBlock completed:(void (^)(UIImage *image, NSError *error))complete;

- (void)TT_setImageAfterClickWithURL:(NSURL *)url;


@end
