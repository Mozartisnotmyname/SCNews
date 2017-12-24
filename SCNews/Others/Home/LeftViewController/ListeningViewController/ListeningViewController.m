//
//  ListeningViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "ListeningViewController.h"
#import "XDSHaloButton.h"
#import <AFNetworking.h>

@interface ListeningViewController ()

@end

@implementation ListeningViewController

-(instancetype) init {
    self = [super init];
    if (self) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backToPushViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) requestData {
    

    //    NSString *urlStr = [@"http://image.baidu.com/data/imgs?col=美女&tag=小清新&sort=0&pn=10&rn=10&p=channel&from=1" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager GET:urlStr parameters:nil progress:^(NSProgress *progress) {
    //
    //
    //    } success:^(NSURLSessionDataTask *task, id responseObject ){
    //        if ([responseObject isKindOfClass:[NSDictionary class]])
    //        {
    //
    //        }
    //
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=18&offset=0&size=50" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [responseObject[@"data"] mutableCopy];
        [array removeLastObject];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取数据失败！");
    }];
    
}

#pragma mark - 返回push view
-(void) backToPushViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fontButtonClick:(UIButton *) sender {
    
    
}


#pragma mark - 导航控制器的代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:push whichViewController:Listening];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:pop whichViewController:Listening];
}

@end
