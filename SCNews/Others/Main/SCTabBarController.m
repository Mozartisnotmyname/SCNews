//
//  SCTabBarController.m
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SCTabBarController.h"
#import "SCNavigationController.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "MusicViewController.h"
#import "PictureViewController.h"
#import <SDImageCache.h>
#import "Color.h"
#import "LGSideMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface SCTabBarController ()

@property (nonatomic, strong) LeftViewController *leftViewController;
@property (nonatomic, strong) RightViewController *rightViewController;
@property (nonatomic, strong) LGSideMenuController *sideMenuController;
@property (nonatomic, assign) BOOL isShakeCanChangeSkin;

@end

@implementation SCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SetColorWithRGB(0xF8F8F8);
    
    NewsViewController *vc1 = [[NewsViewController alloc] init];
    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tabbar_news"] selectedImage:[UIImage imageNamed:@"tabbar_news_hl"] withTittle:@"新闻"];
    
    PictureViewController *vc2 = [[PictureViewController alloc] init];
    [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tabbar_picture"] selectedImage:[UIImage imageNamed:@"tabbar_picture_hl"] withTittle:@"图片"];
    
    VideoViewController *tencentVC = [[VideoViewController alloc]init];
    [self addChildViewController:tencentVC withImage:[UIImage imageNamed:@"tabbar_video"] selectedImage:[UIImage imageNamed:@"tabbar_video_hl"] withTittle:@"视频"];
    
    MusicViewController *vc4 = [[MusicViewController alloc] init];
    vc4.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"tabbar_music"] selectedImage:[UIImage imageNamed:@"tabbar_music_hl"] withTittle:@"音乐"];

    
    [self setupBasic];
}

-(void)setupBasic {
    
    // tabBar设置颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    
    // 侧滑菜单栏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       
        self.leftViewController = [LeftViewController new];
        
        //self.rightViewController = [RightViewController new];
        
        self.sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:self
                                  leftViewController:self.leftViewController
                                 rightViewController:self.rightViewController];
        
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        window.rootViewController = self.sideMenuController ;
        
        // 侧滑左菜单栏设置
        self.sideMenuController.leftViewWidth = 250.0;
        self.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
        self.sideMenuController.leftViewBackgroundColor = [UIColor colorWithRed:100.0 / 255.0 green:194.0 / 255.0  blue:237.0 / 255.0 alpha:0.90];
        self.sideMenuController.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
        
        // 侧滑右菜单栏设置
        //self.sideMenuController.rightViewWidth = 100.0;
        //self.sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
//        self.sideMenuController.rightViewBackgroundImage = [UIImage imageNamed:@"imageRight"];
        //self.sideMenuController.rightViewBackgroundColor = [UIColor colorWithRed:0.65 green:0.5 blue:0.65 alpha:0.95];
        //self.sideMenuController.rootViewCoverColorForRightView = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.05];
    });
}

-(void)dealloc {
    
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (self.isShakeCanChangeSkin == NO) return;
            self.tabBar.barTintColor = [UIColor whiteColor];
    }
}

- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    SCNavigationController *nav = [[SCNavigationController alloc] initWithRootViewController:controller];
    
    // 设置tabBar图片和选中图片
    [nav.tabBarItem setImage:image];
    [nav.tabBarItem setSelectedImage:selectImage];
    
    // 设置controller标题
    controller.title = tittle;
    
    // 设置导航栏的颜色
    [nav.navigationBar setBarTintColor:SetColorWithRGB(0xff0000)];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    [controller.tabBarItem setBadgeColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}

-(void)shakeCanChangeSkin:(BOOL)status {
    self.isShakeCanChangeSkin = status;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [self.sideMenuController leftViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isLeftViewStatusBarHidden) {
        self.sideMenuController.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [self.sideMenuController rightViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isRightViewStatusBarHidden ||
        (self.sideMenuController.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
            self.sideMenuController.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
        }
}

- (BOOL)isLeftViewStatusBarHidden {
    return self.sideMenuController.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
    return self.sideMenuController.isRightViewStatusBarHidden;
}


-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - TabBar 选中的Item
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    // 为选中的item添加动画
//    //[self animationWithIndex:[self.tabBar.items indexOfObject:item]];
//}

#pragma mark - TabBar Item选中时的动画
- (void)animationWithIndex:(NSInteger) index {
    
    NSMutableArray * tabBarButtonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration =0.1;
    animation.repeatCount =1;
    animation.autoreverses =YES;
    animation.fromValue =@1;
    animation.toValue =@1.2;
    [[tabBarButtonArray[index] layer]addAnimation:animation forKey:nil];
}

@end
