//
//  ReadingViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "ReadingViewController.h"
#import "LeftViewCustomTransition.h"
#import "Size.h"
#import "XDSReadManager.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController

-(instancetype) init {
    self = [super init];
    if (self) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backToPushViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        
        
        _readTXT = [UIButton buttonWithType:UIButtonTypeCustom];
        _readTXT.frame = CGRectMake(50, 100, ScreenWidth - 100, 60);
        [_readTXT setBackgroundColor:[UIColor redColor]];
        [_readTXT setTitle:@"Read TXT" forState:UIControlStateNormal];
        [_readTXT addTarget:self action:@selector(readTXTBegin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_readTXT];
        
        _readEpub = [UIButton buttonWithType:UIButtonTypeCustom];
        _readEpub.frame = CGRectMake(50, 180, ScreenWidth - 100, 60);
        [_readEpub setBackgroundColor:[UIColor redColor]];
        [_readEpub setTitle:@"Read Epub" forState:UIControlStateNormal];
        [_readEpub addTarget:self action:@selector(readEpubBegin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_readEpub];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回push view
-(void) backToPushViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 开始读txt
-(void) readTXTBegin {
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"鬼吹灯"withExtension:@"txt"];
    [self showReadPageViewControllerWithFileURL:fileURL];
}


#pragma mark - 开始读epub
-(void) readEpubBegin {
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"zoubianzhongguo"withExtension:@"epub"];
    //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"每天懂一点好玩心理学"withExtension:@"epub"];
    
    [self showReadPageViewControllerWithFileURL:fileURL];
}


- (void)showReadPageViewControllerWithFileURL:(NSURL *)fileURL{
    if (nil == fileURL) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XDSBookModel *bookModel = [XDSBookModel getLocalModelWithURL:fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            XDSReadPageViewController *pageView = [[XDSReadPageViewController alloc] init];
            [[XDSReadManager sharedManager] setResourceURL:fileURL];//文件位置
            [[XDSReadManager sharedManager] setBookModel:bookModel];
            [[XDSReadManager sharedManager] setRmDelegate:pageView];
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

#pragma mark - 导航控制器的代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:push whichViewController:Reading];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:pop whichViewController:Reading];
}


@end
