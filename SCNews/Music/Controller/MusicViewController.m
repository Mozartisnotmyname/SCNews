//
//  MusicViewController.m
//  SCNews
//
//  Created by 凌       陈 on 10/25/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicDownloader.h"
#import <SVProgressHUD.h>
#import "OMHotSongInfo.h"
#import "MusicPlayerManager.h"
#import "OMSongInfo.h"
#import <MJRefresh.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "DetailControlViewController.h"


#define kCustomRowCount 7

static NSString *CellIdentifier = @"LazyTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
static NSString *songURLString = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=2&offset=0&size=100";//前100热门歌曲

@interface MusicViewController ()

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) DetailControlViewController *detailController;

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadInProgress;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) MusicDownloader *downloader;

@property (nonatomic, strong) id playerTimeObserver;

//锁屏图片视图,用来绘制带歌词的image
@property (nonatomic, strong) UIImageView * lrcImageView;
@property (nonatomic, strong) UIImage * lastImage;//最后一次锁屏之后的歌词海报

@end

MusicPlayerManager *musicPlayer;
OMSongInfo *songInfo;

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downloader = [[MusicDownloader alloc] init];
    _downloader.isDataRequestFinish = false;
    _imageDownloadInProgress = [NSMutableDictionary dictionary];
    
    // detailController初始化
    _detailController = [[DetailControlViewController alloc] init];
    
    
    musicPlayer = MusicPlayerManager.sharedManager;
    songInfo = OMSongInfo.sharedManager;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.cornerRadius = 10;
    
    // KVO监测数据请求是否结束
    [self.downloader addObserver:self forKeyPath:@"isDataRequestFinish" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    // 加载数据
    [self RequestData:songURLString];
    
    // 设置上下拉加载
    [self setupBasic];
    [self setupRefresh];
    
    // 设置锁屏控制
    [self createRemoteCommandCenter];
    
    // 设置KVO
    [songInfo addObserver:self forKeyPath:@"playSongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    [musicPlayer addObserver:self forKeyPath:@"finishPlaySongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playSongSetting)
                                                 name: @"repeatPlay"
                                               object: nil];
    // 播放遇到中断，比如电话进来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) RequestData: (NSString *)urlString {
    
    [SVProgressHUD show];
    
    [_downloader requestData:urlString];
}

// -------------------------------------------------------------------------------
//  terminateAllDownloads
// -------------------------------------------------------------------------------
-(void) terminateAllDownloads {
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadInProgress removeAllObjects];
}

// -------------------------------------------------------------------------------
//  dealloc
// -----------------------------------------------------------------------------
-(void) dealloc {
    
    // remove observer
    [self.downloader removeObserver:self forKeyPath:@"isDataRequestFinish"];
    
    // terminate all pending download connections
    [self terminateAllDownloads];
}


#pragma mark --private Method--设置tableView
-(void)setupBasic {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
}

#pragma mark --private Method--初始化刷新控件
-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    [self RequestData:songURLString];
}

- (void)loadMoreData
{
    [self RequestData:songURLString];
}

#pragma mark - 锁屏界面开启和监控远程控制事件
//锁屏界面开启和监控远程控制事件
- (void)createRemoteCommandCenter{
    
    // 远程控制命令中心 iOS 7.1 之后  详情看官方文档：https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    //添加喜欢按钮
    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
    likeCommand.enabled = YES;
    likeCommand.localizedTitle = @"喜欢";
    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"喜欢");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //添加不喜欢按钮，这里用作“下一首”
    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
    dislikeCommand.enabled = YES;
    dislikeCommand.localizedTitle = @"下一首";
    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //标记
    MPFeedbackCommand *bookmarkCommand = commandCenter.bookmarkCommand;
    bookmarkCommand.enabled = YES;
    bookmarkCommand.localizedTitle = @"标记";
    [bookmarkCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"标记");
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制播放
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [musicPlayer.play pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制暂停
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [musicPlayer.play play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制上一曲
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一曲");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制下一曲
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一曲");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    //快进
    MPSkipIntervalCommand *skipBackwardIntervalCommand = commandCenter.skipForwardCommand;
    skipBackwardIntervalCommand.preferredIntervals = @[@(54)];
    skipBackwardIntervalCommand.enabled = YES;
    [skipBackwardIntervalCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        NSLog(@"你按了快进按键！");
        
        // 歌曲总时间
        CMTime duration = musicPlayer.play.currentItem.asset.duration;
        Float64 completeTime = CMTimeGetSeconds(duration);
        
//        // 快进10秒
//        _songSlider.value = _songSlider.value + 10 / completeTime;
//        
//        // 计算快进后当前播放时间
//        Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
       
        Float64 currentTime =  CMTimeGetSeconds(musicPlayer.play.currentItem.currentTime) + 10;
        
        // 播放器定位到对应的位置
        CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
        [musicPlayer.play seekToTime:targetTime];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = musicPlayer.play.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [musicPlayer.play seekToTime:CMTimeMake(totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isDataRequestFinish"]) {
        if (self.downloader.isDataRequestFinish == true) {
            self.downloader.isDataRequestFinish = false;
            
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            self.entries = _downloader.songInfo.OMSongs;
            
            [self.tableView reloadData];
        }
    }
    
    if ([keyPath  isEqual: @"playSongIndex"]) {
        //        musicPlayer.finishPlaySongIndex = songInfo.playSongIndex;
        [self playSongSetting];
    }
    
    if ([keyPath  isEqual: @"finishPlaySongIndex"]) {
        //        songInfo.playSongIndex = musicPlayer.finishPlaySongIndex;
        [self playSongSetting];
    }
}

#pragma mark - 音乐被中断处理
- (void) onAudioSessionEvent: (NSNotification *) notification
{
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received!");
        
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
            [musicPlayer stopPlay];
        } else {
            NSLog(@"Interruption ended!");
            //Resume your audio
            [musicPlayer startPlay];
        }
    }
}

#pragma mark - 播放音乐调用
-(void) playSongSetting {
    
    if (_playerTimeObserver != nil) {
        
        [musicPlayer.play removeTimeObserver:_playerTimeObserver];
        _playerTimeObserver = nil;
        
        [musicPlayer.play.currentItem cancelPendingSeeks];
        [musicPlayer.play.currentItem.asset cancelLoading];
        
    }
    
    // detail页面控制界面信息设置
    _detailController.topview.songTitleLabel.text = songInfo.title;
    _detailController.topview.singerNameLabel.text = [[@"- " stringByAppendingString:songInfo.author] stringByAppendingString:@" -"];
    [_detailController.midView.midIconView setAlbumImage:songInfo.pic_big];
    //    [_deliverView setBackgroundImage:songInfo.pic_small];
    [_detailController.midView.midIconView.imageView startRotating];
    [_detailController.midView.midLrcView AnalysisLRC:songInfo.lrcString];
    
    
    
    [musicPlayer setPlayItem:songInfo.file_link];
    [musicPlayer setPlay];
    [musicPlayer startPlay];
    
    // 歌词index清零
    songInfo.lrcIndex = 0;
    
    // 控制界面设置
    [_detailController playSetting];
    
    // 播放结束通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:musicPlayer.play.currentItem];
    
    // 每秒更新一下状态（播放时间和歌词）
    _playerTimeObserver = [musicPlayer.play addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        NSLog(@"当前播放时间：%f", currentTime);
        
        CMTime total = musicPlayer.play.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        // 设置当前播放时间
        _detailController.bottomView.currentTimeLabel.text = [songInfo intToString:(int)currentTime];
        // 设置总时间
        _detailController.bottomView.durationTimeLabel.text =[songInfo intToString:(int)totalTime];
        
       // 设置播放进度条
        _detailController.bottomView.songSlider.value = (float) ( currentTime / totalTime );
        
        
        // 设置歌词
        if (songInfo.isLrcExistFlg == true) {
            
            if (!_detailController.midView.midLrcView.isDragging) {
                
                if (songInfo.lrcIndex <= songInfo.mLRCDictinary.count - 1) {
                    
                    if ((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]]) {
                        
                        _detailController.midView.midLrcView.currentRow = songInfo.lrcIndex;
                        
                        //
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_detailController.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                            
                            [_detailController.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
                        });
                        
                        // 刷新歌词列表
                        [_detailController.midView.midLrcView.tableView reloadData];
                        [_detailController.midView.midLrcView.lockScreenTableView reloadData];
                        

                        songInfo.lrcIndex = songInfo.lrcIndex + 1;
                        
                    } else {
                        
                        if (songInfo.lrcIndex != 0) {

                            if (((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex - 1]]) && ((int)currentTime < [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]])) {

                                _detailController.midView.midLrcView.currentRow = songInfo.lrcIndex - 1;

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_detailController.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                    
                                    [_detailController.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                });
                                
                                // 刷新歌词列表
                                [_detailController.midView.midLrcView.tableView reloadData];
                                [_detailController.midView.midLrcView.lockScreenTableView reloadData];
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        
        //监听锁屏状态 lock=1则为锁屏状态
        uint64_t locked;
        __block int token = 0;
        notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(token, &locked);
        
        //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
        uint64_t screenLight;
        __block int lightToken = 0;
        notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(lightToken, &screenLight);
        
        BOOL isShowLyricsPoster = NO;
        // NSLog(@"screenLight=%llu locked=%llu",screenLight,locked);
        if (screenLight == 0 && locked == 1) {
            //点亮且锁屏时
            isShowLyricsPoster = YES;
        }else if(screenLight){
            return;
        }
        
        //展示锁屏歌曲信息，上面监听屏幕锁屏和点亮状态的目的是为了提高效率
        [self showLockScreenTotaltime:totalTime andCurrentTime:currentTime andLyricsPoster:isShowLyricsPoster];
        
    }];

}


#pragma mark - 锁屏播放设置
//展示锁屏歌曲信息：图片、歌词、进度、演唱者
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andLyricsPoster:(BOOL)isShow{
    
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:songInfo.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:songInfo.author forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:songInfo.album_title forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    UIImage * lrcImage = songInfo.pic_big;
    if (isShow) {
        
        //制作带歌词的海报
        if (!_lrcImageView) {
            _lrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480,800)];
        }
        
        //主要为了把歌词绘制到图片上，已达到更新歌词的目的
//        [_lrcImageView addSubview:_deliverView.midView.midLrcView.lockScreenTableView];
        _lrcImageView.image = lrcImage;
        _lrcImageView.backgroundColor = [UIColor blackColor];
        
        //获取添加了歌词数据的海报图片
        UIGraphicsBeginImageContextWithOptions(_lrcImageView.frame.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_lrcImageView.layer renderInContext:context];
        lrcImage = UIGraphicsGetImageFromCurrentImageContext();
        _lastImage = lrcImage;
        UIGraphicsEndImageContext();
        
    }else{
        if (_lastImage) {
            lrcImage = _lastImage;
        }
    }
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:lrcImage]
                 forKey:MPMediaItemPropertyArtwork];
    
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
}


#pragma mark - 下一曲
-(void) nextButtonAction: (UIButton *)sender {
    
    if (songInfo.playSongIndex < songInfo.OMSongs.count) {
        OMHotSongInfo *info = songInfo.OMSongs[songInfo.playSongIndex + 1];
        NSLog(@"即将播放下一首歌曲: 《%@》", info.title);
        [songInfo setSongInfo:info];
        [songInfo getSelectedSong:info.song_id index:songInfo.playSongIndex + 1];
    } else {
        NSLog(@"后面没歌曲啦~");
    }
    
}

#pragma mark - 歌曲播放结束操作
-(void) finishedPlaying {
    
    NSLog(@"本歌曲播放结束，准备播放下一首歌曲！");
    //    songInfo.playSongIndex = songInfo.playSongIndex + 1;
    [self nextButtonAction:nil];
}


#pragma mark - Table cell image support

// ----------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// ----------------------------------------------------------------------------
- (void)startIconDownload:(OMHotSongInfo *)info forIndexPath:(NSIndexPath *)indexPath
{
    MusicDownloader *downloader = (self.imageDownloadInProgress)[indexPath];
    if (downloader == nil)
    {
        downloader = [[MusicDownloader alloc] init];
        downloader.hotSonginfo = info;
        [downloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = info.albumImage_small;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadInProgress)[indexPath] = downloader;
        [downloader startDownload];
    }
}

// -----------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// ------------------------------------------------------------------------------
-(void) loadImagesForOnScreenRows {
    
    if (self.entries.count > 0) {
        NSArray *visiblePaths= [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths) {
            OMHotSongInfo *info = (self.entries)[indexPath.row];
            
            if (!info.albumImage_small) {
                [self startIconDownload:info forIndexPath:indexPath];
            }
        }
    }
}


// -----------------------------------------------------------------------------
// reloadData
// -----------------------------------------------------------------------------
-(void) reloadLazyLoadingTableViewData {
    
    // 刷新tableView
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
// -----------------------------------------------------------------------------
//	numberOfSectionsInTableView
//  height of tableView.
// -----------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// -----------------------------------------------------------------------------
//	tableView:heightForRowAtIndexPath:
//  height of tableView.
// -----------------------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

// -------------------------------------------------------------------------------
//	tableView:numberOfRowsInSection:
//  Customize the number of rows in the table view.
// -------------------------------------------------------------------------------
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.entries.count;
    
    // if there's no data yet, return enough rows to fill the screen
    if (count == 0) {
        return kCustomRowCount;
    }
    return count;
}

// -------------------------------------------------------------------------------
//	tableView:numberOfRowsInSection:
//  Customize the number of rows in the table view.
// -----------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSUInteger nodeCount = self.entries.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [self.tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:PlaceholderCellIdentifier];
        }
    }
    else
    {
        // add a placeholder cell while waiting on table data
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        }
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell representing the app
            OMHotSongInfo *info = (self.entries)[indexPath.row];
            
            cell.textLabel.text = info.title;
            cell.detailTextLabel.text = info.author;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!info.albumImage_small)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:info forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imageView.image = info.albumImage_small;
            }
        }
    }
    
    return cell;
}

// -------------------------------------------------------------------------------
//	tableView:didSelectRowAtIndexPath:
//  Select the number of rows in the table view.
// -------------------------------------------------------------------------------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OMHotSongInfo *info = songInfo.OMSongs[indexPath.row];
    NSLog(@"你选择了《%@》这首歌", info.title);
    [songInfo setSongInfo:info];
    [songInfo getSelectedSong:info.song_id index:indexPath.row];
    
    [_detailController playSetting];
    [self presentViewController:_detailController animated:YES completion:nil];
}




#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnScreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnScreenRows];
}
@end
