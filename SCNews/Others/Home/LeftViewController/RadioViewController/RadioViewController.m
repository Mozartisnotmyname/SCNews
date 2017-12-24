//
//  RadioViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "RadioViewController.h"
#import "LeftViewCustomTransition.h"
#import "RadioModel.h"
#import "MJExtension/MJExtension.h"
#import "UIImageView+WebCache.h"
#import "Size.h"
#include "FSAudioController.h"
#import "UIButton+SCSuspension.h"

#define kAppIconSize 48

@interface RadioViewController () {
    BOOL _paused;
    BOOL _record;
    FSAudioController *_audioController;
    NSTimer *_progressUpdateTimer;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *radioList;

// 底部弹出View
@property (nonatomic, strong) UIView *playControlView;
@property (nonatomic ,strong) UIView *shadowView; //遮罩


@end

@implementation RadioViewController

-(instancetype) init {
    self = [super init];
    if (self) {
        
        // 退出界面按键
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backToPushViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        
        // radio播放列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0.1;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

        // 悬浮球
        UIButton *stopBtn= [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight - 60,60, 60)];
        stopBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        stopBtn.tag = 0;
        stopBtn.layer.cornerRadius = 30;
        [stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
        [stopBtn setDragEnable:YES];
        [stopBtn setAdsorbEnable:YES];
        [self.view addSubview:stopBtn];
        [stopBtn addTarget:self action:@selector(suspensionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // 获取radio数据
    [self getRadioData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (FSAudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[FSAudioController alloc] init];
        _record = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioStreamStateDidChange:)
                                                     name:FSAudioStreamStateChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioStreamErrorOccurred:)
                                                     name:FSAudioStreamErrorNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioStreamMetaDataAvailable:)
                                                     name:FSAudioStreamMetaDataNotification
                                                   object:nil];
    }
    return _audioController;
}

/*
 * =======================================
 * Private
 * =======================================
 */

- (void)updatePlaybackProgress
{
    if (self.audioController.activeStream.continuous) {
//        [self.progressLabel setText:@""];
    } else {
        FSStreamPosition cur = self.audioController.activeStream.currentTimePlayed;
        FSStreamPosition end = self.audioController.activeStream.duration;
        
//        [self.progressLabel setText:[NSString stringWithFormat:@"%i:%02i / %i:%02i",
//                                     cur.minute, cur.second,
//                                     end.minute, end.second]];
    }
}

/*
 * =======================================
 * Observers
 * =======================================
 */

- (void)audioStreamStateDidChange:(NSNotification *)notification
{
    if (!(notification.object == self.audioController.activeStream)) {
        return;
    }
    
    NSString *statusRetrievingURL = @"Retrieving stream URL";
    NSString *statusBuffering = @"Buffering...";
    NSString *statusSeeking = @"Seeking...";
    NSString *statusEmpty = @"";
    
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    
    switch (state) {
        case kFsAudioStreamRetrievingURL:
//            [self.stateLabel setText:statusRetrievingURL];
//
//            [self.playButton setHidden:YES];
//            [self.pauseButton setHidden:NO];
            _paused = NO;
            
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
//            [self.progressLabel setText:@""];
            
            break;
            
        case kFsAudioStreamStopped:
//            [self.stateLabel setText:statusEmpty];
//
//
//            [self.playButton setHidden:NO];
//            [self.pauseButton setHidden:YES];
            _paused = NO;
            
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
//            [self.progressLabel setText:@""];
            
            break;
            
        case kFsAudioStreamBuffering:
//            [self.stateLabel setText:statusBuffering];
//
//            [self.playButton setHidden:YES];
//            [self.pauseButton setHidden:NO];
            _paused = NO;
            
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
//            [self.progressLabel setText:@""];
            
            break;
            
        case kFsAudioStreamSeeking:
//            [self.stateLabel setText:statusSeeking];
//
//            [self.playButton setHidden:YES];
//            [self.pauseButton setHidden:NO];
            _paused = NO;
            break;
            
        case kFsAudioStreamPlaying:
            
//            if ([self.stateLabel.text isEqualToString:statusBuffering] ||
//                [self.stateLabel.text isEqualToString:statusRetrievingURL] ||
//                [self.stateLabel.text isEqualToString:statusSeeking]) {
//                [self.stateLabel setText:statusEmpty];
//            }
            
//            [self.playButton setHidden:YES];
//            [self.pauseButton setHidden:NO];
            _paused = NO;
            
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            
            _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                    target:self
                                                                  selector:@selector(updatePlaybackProgress)
                                                                  userInfo:nil
                                                                   repeats:YES];
            
            break;
            
        case kFsAudioStreamFailed:
            
//            [self.playButton setHidden:NO];
//            [self.pauseButton setHidden:YES];
            _paused = NO;
            
            if (_progressUpdateTimer) {
                [_progressUpdateTimer invalidate];
            }
            
            break;
    }
}

- (void)audioStreamErrorOccurred:(NSNotification *)notification
{
    if (!(notification.object == self.audioController.activeStream)) {
        return;
    }
    
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
//            [self.stateLabel setText:@"Cannot open the audio stream"];
            break;
        case kFsAudioStreamErrorStreamParse:
//            [self.stateLabel setText:@"Cannot read the audio stream"];
            break;
        case kFsAudioStreamErrorNetwork:
//            [self.stateLabel setText:@"Network failed: cannot play the audio stream"];
            break;
        case kFsAudioStreamErrorUnsupportedFormat:
//            [self.stateLabel setText:@"Unsupported format"];
            break;
        case kFsAudioStreamErrorStreamBouncing:
//            [self.stateLabel setText:@"Network failed: cannot get enough data to play"];
            break;
        default:
//            [self.stateLabel setText:@"Unknown error occurred"];
            break;
    }
}

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification
{
    if (!(notification.object == self.audioController.activeStream)) {
        return;
    }
    
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    
    NSMutableString *streamInfo = [[NSMutableString alloc] init];
    
    if (metaData[@"MPMediaItemPropertyArtist"] &&
        metaData[@"MPMediaItemPropertyTitle"]) {
        [streamInfo appendString:metaData[@"MPMediaItemPropertyArtist"]];
        [streamInfo appendString:@" - "];
        [streamInfo appendString:metaData[@"MPMediaItemPropertyTitle"]];
    } else if (metaData[@"StreamTitle"]) {
        [streamInfo appendString:metaData[@"StreamTitle"]];
    }
    
//    [self.stateLabel setText:streamInfo];
}

- (void) play: (NSString *)radioUrl {

    if (![self.audioController.url isEqual:radioUrl]) {
        [self.audioController stop];
        
        self.audioController.url = [NSURL URLWithString:radioUrl];
    }
    
    if (_paused) {
        /*
         * If we are paused, call pause again to unpause so
         * that the stream playback will continue.
         */
        [self.audioController pause];
        _paused = NO;
    }
    
    [self.audioController play];
    
//    [self.playButton setHidden:YES];
//    [self.pauseButton setHidden:NO];
    
}

- (void)pause
{
    [self.audioController pause];
    
    _paused = YES;
    
//    [self.playButton setHidden:NO];
//    [self.pauseButton setHidden:YES];
}


-(void) getRadioData {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"RadioInfo" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    if (jsonObject == nil) {
        return;
    }
    _radioList = [NSMutableArray array];
    _radioList = [RadioModel mj_objectArrayWithKeyValuesArray:[jsonObject objectForKey:@"radio_list"]];
    
    [_tableView reloadData];
}



#pragma - mark 弹出控制界面
-(void) pushPlayControlView {
    
//    // 全屏遮罩
//    _shadowView                 = [[UIView alloc] init];
//    _shadowView.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight / 9 * 8);
//    _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//
//
//    // UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
//    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
//    // 阴影部分view
//    [appWindow addSubview:_shadowView];
//    // 底部弹出的SongListView
//    [appWindow addSubview:_playControlView];
//
//    // 给全屏遮罩添加的点击事件
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPlayControlView)];
//    gesture.numberOfTapsRequired = 1;
//    gesture.cancelsTouchesInView = NO;
//    [_shadowView addGestureRecognizer:gesture];
    

    // playControlView出现动画
    _playControlView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight);
//    _shadowView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight);
    [UIView animateWithDuration:0.5 animations:^{
        
//        _shadowView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        _playControlView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight / 9 * 8);
        
    } completion:^(BOOL finished){
        
//        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
}

#pragma mark - 停止播放radio
-(void) suspensionButtonAction {
    
    [self pause];
}

#pragma mark - UITableViewDataSource
// -------------------------------------------------------------------------------
//    numberOfSectionsInTableView
//  height of tableView.
// -------------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// -------------------------------------------------------------------------------
//    tableView:heightForRowAtIndexPath:
//  height of tableView.
// -------------------------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

// -------------------------------------------------------------------------------
//    tableView:numberOfRowsInSection:
//  Customize the number of rows in the table view.
// -------------------------------------------------------------------------------
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _radioList.count;
}

// -------------------------------------------------------------------------------
//    tableView:numberOfRowsInSection:
//  Customize the number of rows in the table view.
// -----------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioModel *radioInfo = _radioList[indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RadioTableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle  reuseIdentifier:@"RadioTableViewCell"];
    }
    
    cell.textLabel.text = radioInfo.name;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", radioInfo.categories, radioInfo.country];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:radioInfo.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]
                               options:SDWebImageProgressiveDownload
                              progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                  });
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
                                 {
                                     CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                                     UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                     CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                     [image drawInRect:imageRect];
                                     cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                                     UIGraphicsEndImageContext();
                                 }
                                 else
                                 {
                                     cell.imageView.image = image;
                                 }
                             }];

    
    return cell;
}

// -------------------------------------------------------------------------------
//    tableView:didSelectRowAtIndexPath:
//  Select the number of rows in the table view.
// -------------------------------------------------------------------------------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"你选择了第%ld行", (long)indexPath.row);
    
    RadioModel *radioInfo = _radioList[indexPath.row];

    [self play:radioInfo.streamUrl];
}


#pragma mark - 返回push view
-(void) backToPushViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 导航控制器的代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:push whichViewController:Radio];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:pop whichViewController:Radio];
}

@end
