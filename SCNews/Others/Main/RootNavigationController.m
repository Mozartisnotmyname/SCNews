//
//  RootNavigationController.m
//  SCNews
//
//  Created by 凌       陈 on 11/2/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "RootNavigationController.h"
#import "SCTabBarController.h"

@interface RootNavigationController ()

@end

/**
*  RootNavigationController
*  最先加载的控制器，RootNavigationController的root控制器SCTabBarController
*  才是真正首页
**/

@implementation RootNavigationController


-(instancetype) init {
    
    SCTabBarController *tabbarController = [[SCTabBarController alloc] init];
    
    self = [super initWithRootViewController:tabbarController];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
