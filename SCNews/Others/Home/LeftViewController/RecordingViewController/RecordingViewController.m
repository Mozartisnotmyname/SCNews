//
//  RecordingViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/10/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "RecordingViewController.h"
#import "Size.h"
#import <AVFoundation/AVFoundation.h>

#define kRecordAudioFile @"myRecord.caf"


@interface RecordingViewController () <AVAudioRecorderDelegate>

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIProgressView *progressView;

// 录音相关变量
@property (nonatomic,strong)AVAudioRecorder * audioRecorder;//音频录音机
@property (nonatomic,strong)AVAudioPlayer   * audioPlayer;//音频播放器，用于播放录音
@property (nonatomic,strong)NSTimer         * timer;//录音声波监控；


@end

@implementation RecordingViewController

-(instancetype) init {
    self = [super init];
    if (self) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationbar_back_icon"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backToPushViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        

//
//        // 音频指示器
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 180, 300, 30)];
//        [self.view addSubview:_progressView];
//
//        // 录音
//        _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 60, 30)];
//        [_recordBtn setBackgroundColor:[UIColor redColor]];
//        [_recordBtn setTitle:@"录音" forState:UIControlStateNormal];
//        [_recordBtn setTitle:@"按下" forState:UIControlStateHighlighted];
//        [_recordBtn addTarget:self action:@selector(recordBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_recordBtn];
//
//        // 暂停
//        _pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 200, 60, 30)];
//        [_pauseBtn setBackgroundColor:[UIColor redColor]];
//        [_pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
//        [_pauseBtn setTitle:@"按下" forState:UIControlStateHighlighted];
//        [_pauseBtn addTarget:self action:@selector(pauseBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_pauseBtn];
//
//        // 结束
//        _stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 200, 60, 30)];
//        [_stopBtn  setBackgroundColor:[UIColor redColor]];
//        [_stopBtn  setTitle:@"结束" forState:UIControlStateNormal];
//        [_stopBtn setTitle:@"按下" forState:UIControlStateHighlighted];
//        [_stopBtn  addTarget:self action:@selector(stopBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_stopBtn];
//
//        // 播放
//        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 200, 60, 30)];
//        [_playBtn setBackgroundColor:[UIColor redColor]];
//        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
//        [_playBtn setTitle:@"按下" forState:UIControlStateHighlighted];
//        [_playBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_playBtn];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    // Do any additional setup after loading the view.
    
    [self setAudioSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置音频会话
 */
-(void) setAudioSession {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // 设置播放和录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  设置录音文件的保存路劲
 */
-(NSURL *)getSavePath
{
    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file:path:%@",urlStr);
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件的设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSettion
{
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般的录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数，分为8，16，24，32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //。。。。是他设置
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder * )audioRecorder
{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL * url =[self getSavePath];
        //创建录音格式设置
        NSDictionary * setting = [self getAudioSettion];
        //创建录音机
        NSError * error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要控制声波则必须设置为YES
        if(error)
        {
            NSLog(@"创建录音机对象发生错误，错误信息是：%@",error.localizedDescription);
            return nil;
        }
        
    }
    return _audioRecorder;
    
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        NSURL * url = [self getSavePath];
        NSError * error = nil;
        _audioPlayer =[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程出错：错误信息是：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
/**
 *  录音声波监控定时器
 *
 *  @return 定时器
 */
-(NSTimer * )timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)audioPowerChange
{
    [self.audioRecorder updateMeters];//跟新检测值
    float power = [self.audioRecorder averagePowerForChannel:0];//获取第一个通道的音频，注音音频的强度方位-160到0
    CGFloat progerss = (1.0/160)*(power+160);
    [self.progressView setProgress:progerss];
}


/**
 *  点击录音按钮
 */
-(void) recordBtnAction {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
    }
}

/**
 *  点击暂停按钮
 */
-(void) pauseBtnAction {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];\
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  点击停止按钮
 */
-(void) stopBtnAction {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];\
        self.timer.fireDate=[NSDate distantFuture];
    }
}


/**
 *  点击播放按钮
 */
-(void) playBtnAction {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

#pragma mark - 返回push view
-(void) backToPushViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音完成!");
}


#pragma mark - 导航控制器的代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:push whichViewController:Recording];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[LeftViewCustomTransition alloc] initWithTransitionType:pop whichViewController:Recording];
}


@end
