//
//  AppDelegate.m
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "AppDelegate.h"
#import "SCTabBarController.h"
#import "TTConst.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "RootNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUserDefaults];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RootNavigationController alloc] init];
    [self.window makeKeyAndVisible];
    
    // 后台播放音频设置,需要在Capabilities->Background Modes中勾选Audio,Airplay,and Picture in Picture
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 设置接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return YES;
}

-(void)setupUserDefaults {
    
    BOOL isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
    if (!isShakeCanChangeSkin) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsShakeCanChangeSkinKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    BOOL isDownLoadNoImageIn3G = [[NSUserDefaults standardUserDefaults] boolForKey:IsDownLoadNoImageIn3GKey];
    if (!isDownLoadNoImageIn3G) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsDownLoadNoImageIn3GKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
    if (userName==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"SCNews" forKey:UserNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *userSignature = [[NSUserDefaults standardUserDefaults] stringForKey:UserSignatureKey];
    if (userSignature==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"这个家伙很懒,什么也没有留下" forKey:UserSignatureKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
