//
//  BaseViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/2/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@end


/**
 *  BaseViewController
 *  为了使用Left和Right而建立的controller
 *
 **/
@implementation BaseViewController

- (id)init {
    self = [super init];
    if (self) {
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
//                                                                                 style:UIBarButtonItemStylePlain
//                                                                                target:self
//                                                                                action:@selector(showLeftView)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_home_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView)];
        
        /*
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showRightView)];
         */
    }
    
    
    return self;
}


#pragma mark -

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

@end
