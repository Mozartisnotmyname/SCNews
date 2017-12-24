//
//  PictureViewController.h
//  SCNews
//
//  Created by 凌       陈 on 10/26/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@interface PictureViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) ImageInfo *imageInfo;

@end
