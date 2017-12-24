//
//  PictureViewController.m
//  SCNews
//
//  Created by 凌       陈 on 10/26/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "PictureViewController.h"
#import "SXNetworkTools.h"
#import <AFNetworking.h>
#import "CellModel.h"
#import "WSCollectionCell.h"
#import "WSLayout.h"
#import "ToViewController.h"
#import "CustomTransition.h"
#import <SVProgressHUD.h>

@interface PictureViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) WSLayout *wslayout;

// url session task
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@property (nonatomic, strong) UIImageView *pic1;

@end

@implementation PictureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageInfo = ImageInfo.sharedManager;
    
    // 请求图片数据
    [SVProgressHUD show];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestData {

//    [[[SXNetworkTools sharedNetworkTools] GET:pictureURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
//        
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSLog(@"success!");
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }] resume];
//    
//    NSString *path = [pictureURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
  
    
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
    
    NSString *urlStr = [@"http://image.baidu.com/channel/listjson?pn=0&rn=100&tag1=美女&tag2=全部&ie=utf8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [responseObject[@"data"] mutableCopy];
        [array removeLastObject];
        
        int index = 0;
        for (NSDictionary *dic in array) {
            
            CellModel *model = [[CellModel alloc]init];
            model.index = index;
            model.imgURL = dic[@"image_url"];
            model.imgWidth = [dic[@"image_width"] floatValue];
            model.imgHeight = [dic[@"image_height"] floatValue];
            model.title = dic[@"abs"];
            [_imageInfo.imageArray addObject:model];
            index++;
        }
        
        [self creatSubView];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
  
}


- (void)creatSubView {
    
    self.wslayout = [[WSLayout alloc] init];
    self.wslayout.lineNumber = 3; //列数
    self.wslayout.rowSpacing = 5; //行间距
    self.wslayout.lineSpacing = 5; //列间距
    self.wslayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // 透明时用这个属性(保证collectionView 不会被遮挡, 也不会向下移)
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    // 不透明时用这个属性
    //self.extendedLayoutIncludesOpaqueBars = YES;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.wslayout];
    
    [self.collectionView registerClass:[WSCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    
    //返回每个cell的高   对应indexPath
    [self.wslayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        
        CellModel *model = _imageInfo.imageArray[indexPath.row];
        CGFloat oldWidth = model.imgWidth;
        CGFloat oldHeight = model.imgHeight;
        
        CGFloat newWidth = width;
        CGFloat newHeigth = oldHeight*newWidth / oldWidth;
        return newHeigth;
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imageInfo.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WSCollectionCell *cell = (WSCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.model = _imageInfo.imageArray[indexPath.row];
    
    /*
    // 判断数组中是否存在该cell,不存在才添加
    __block BOOL isExist = NO;
    [cellArray enumerateObjectsUsingBlock:^(WSCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cell.model.index == obj.model.index) {
            *stop = YES;
            isExist = YES;
        }
      
    }];
    if (!isExist) {//如果不存在就添加进去
        [cellArray addObject:cell];
    }
    */
    /*
    // 判断数组中是否存在该cell,不存在才添加
    __block BOOL isExist = NO;
    [cellArray enumerateObjectsUsingBlock:^(WSCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([cell.model.imgURL isEqualToString:((WSCollectionCell *)cellArray[idx]).model.imgURL]) {//数组中已经存在该对象
            *stop = YES;
            isExist = YES;
        }
    }];
    if (!isExist) {//如果不存在就添加进去
        [cellArray addObject:cell];
    }
    */
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了第%ld个item",indexPath.row);
    self.currentIndexPath = indexPath;
    
    ToViewController *toVC = [[ToViewController alloc] init];
    toVC.collectionView = collectionView;
    toVC.currentIndexPath = indexPath;
    

    [self presentViewController:toVC animated:YES completion:nil];
    
    
}



@end
