//
//  ContentTableViewController.h
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTNormalNews;

@interface ContentTableViewController : UITableViewController

@property(nonatomic, strong) TTNormalNews *news;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelName;
@property(nonatomic,copy) NSString *urlString;
@property (nonatomic,assign) NSInteger index;

@end
