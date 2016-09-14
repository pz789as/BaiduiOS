//
//  BaiduInterface.m
//  BaiduiOS
//
//  Created by guojicheng on 16/5/19.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaiduInterface.h"
#import "RCTConvert.h"
#import "BaiduReact.h"

#define VOICE_LEVEL_INTERVAL 0.1

@implementation BaiduInterface

- (void)setInfo:(NSDictionary *)infos baiduReact:(BaiduReact*)baiduReact
{
    self.baiduReact = baiduReact;
    
    BDVoiceRecognitionClient* sharedInstance=[BDVoiceRecognitionClient sharedInstance];
    
    [sharedInstance setPropertyList: @[[NSNumber numberWithInt: EVoiceRecognitionPropertyInput]]];//设置识别模式
    
    [sharedInstance setLanguage: EVoiceRecognitionLanguageChinese];//设置语言
    
    //    [sharedInstance disablePuncs:YES];//是否禁用标点；默认不禁用
    
    [sharedInstance setNeedVadFlag:[RCTConvert BOOL:infos[@"needVadFlag"]]];//设置端点检测，默认开启，自动判断说话结束
    
    //    [sharedInstance setNeedCompressFlag:YES];//设置上传语音进行压缩，默认开启
    
    [sharedInstance setOnlineWaitTime:[RCTConvert NSInteger:infos[@"onlineWaitTime"]]];//在线响应时间，超过就使用离线
    
    //如果时TEST，就需要设置license临时文件，否则需要去百度中心设置bundleID
    NSString* licenseFilePath= [[RCTConvert NSString:infos[@"licenseMode"]]  isEqual: @"TEST"] ? [[NSBundle mainBundle] pathForResource:@"temp_license_ios" ofType:@"dat"] : nil;
    
    NSString* datFilePath = [[NSBundle mainBundle] pathForResource:@"s_1" ofType:@""];
    NSString* LMDatFilePath = [[NSBundle mainBundle] pathForResource:@"s_2_InputMethod" ofType:@""];
    NSDictionary* recogGrammSlot = @{@"$name_CORE" : @"张三\n 李四\n",
                                     @"$song_CORE" : @"小苹果\n 我的滑板鞋\n",
                                     @"$app_CORE" : @"百度\n 百度地图\n",
                                     @"$artist_CORE" : @"刘德华\n 周华健\n"};
    
    int ret = [sharedInstance loadOfflineEngine:[RCTConvert NSString:infos[@"AppID"]]
                                        license:licenseFilePath
                                        datFile:datFilePath
                                      LMDatFile:LMDatFilePath
                                      grammSlot:recogGrammSlot];
    
    NSString* msgLog;
    if (ret == 0){
        msgLog = @"离线配置成功，离线识别状态正常";
        [self.baiduReact recognitionCallback:@CB_CODE_LOG result:msgLog];
    }else{
        switch (ret) {
            case EVoiceRecognitionClientErrorOfflineEngineGetLicenseFailed:
                msgLog = @"获取license失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineVerifyLicenseFaild:
                msgLog = @"验证license失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineDatFileNotExist:
                msgLog = @"指定的模型文件不存在";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineSetSlotFailed:
                msgLog = @"设置离线识别引擎槽失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineInitializeFailed:
                msgLog = @"初始化失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineSetParamFailed:
                msgLog = @"设置参数错误";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineLMDataFileNotExist:
                msgLog = @"导航模型文件不存在";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineSetPropertyFailed:
                msgLog = @"设置识别垂类失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineFeedAudioDataFailed:
                msgLog = @"识别失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineStopRecognitionFailed:
                msgLog = @"识别失败";
                break;
            case EVoiceRecognitionClientErrorOfflineEngineRecognizeFailed:
                msgLog = @"识别失败";
                break;
        }
        
        [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:msgLog];
    }
    [sharedInstance setApiKey:[RCTConvert NSString:infos[@"API_KEY"]]
                withSecretKey:[RCTConvert NSString:infos[@"SECRET_KEY"]]];
    
    self.isSetting = TRUE;
}

- (void)start
{
    BDVoiceRecognitionClient* sharedInstance=[BDVoiceRecognitionClient sharedInstance];
    NSString * msgStatus;
    
    if (self.isSetting == FALSE) {
        msgStatus = @"参数未配置，应该先调用setInfo。";
        [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:msgStatus];
    }else{
        int startStatus = [sharedInstance startVoiceRecognition:self];
        switch (startStatus) {
            case EVoiceRecognitionStartWorking:
                msgStatus = @"开始工作";
                break;
            case EVoiceRecognitionStartWorkNOMicrophonePermission:
                msgStatus = @"没有麦克风权限";
                break;
            case EVoiceRecognitionStartWorkNoAPIKEY:
                msgStatus = @"没有设定应用API KEY";
                break;
            case EVoiceRecognitionStartWorkGetAccessTokenFailed:
                msgStatus = @"获取accessToken失败";
                break;
            case EVoiceRecognitionStartWorkNetUnusable:
                msgStatus = @"当前网络不可用";
                break;
            case EVoiceRecognitionStartWorkDelegateInvaild:
                msgStatus = @"没有实现MVoiceRecognitionClientDelegate中VoiceRecognitionClientWorkStatus方法,或传入的对像为空";
                break;
            case EVoiceRecognitionStartWorkRecorderUnusable:
                msgStatus = @"录音设备不可用";
                break;
            case EVoiceRecognitionStartWorkPreModelError:
                msgStatus = @"启动预处理模块出错";
                break;
            case EVoiceRecognitionStartWorkPropertyInvalid:
                msgStatus = @"设置的识别属性无效";
                break;
            case EVoiceRecognitionStartWorkOfflineEngineNotInit:
                msgStatus = @"离线引擎没有初始化";
                break;
            case EVoiceRecognitionStartWorkOfflineEngineNotSupport:
                msgStatus = @"离线不支持的垂类识别";
                break;
            case EVoiceRecognitionStartWorkBusy:
                msgStatus = @"busy,当前识别器正在工作";
                break;
        }
        if ([msgStatus isEqual:@"开始工作"]){
            [self.baiduReact recognitionCallback:@CB_CODE_STATUS result:@SPEECH_START];
        }else{
            [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:msgStatus];
        }
    }
}

- (void)finish
{
    [self freeVoiceLevelMeterTimerTimer];
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];
}

- (void)cancel
{
    [self freeVoiceLevelMeterTimerTimer];
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
}

- (NSString *)composeInputModeResult:(id)aObj
{
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
    for (NSArray *result in aObj)
    {
        NSDictionary *dic = [result objectAtIndex:0];
        NSString *candidateWord = [[dic allKeys] objectAtIndex:0];
        [tmpString appendString:candidateWord];
    }
    return tmpString;
}

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    // 为了更加具体的显示错误信息，此处没有使用aStatus参数
    //[self createErrorViewWithErrorType:aSubStatus];
    NSString* msgStatus;
    switch (aStatus) {
        case EVoiceRecognitionClientErrorStatusClassVDP:
            msgStatus = @"语音数据处理过程出错";
            break;
        case EVoiceRecognitionClientErrorStatusClassRecord:
            msgStatus = @"录音出错";
            break;
        case EVoiceRecognitionClientErrorStatusClassLocalNet:
            msgStatus = @"本地网络联接出错";
            break;
        case EVoiceRecognitionClientErrorStatusClassServerNet:
            msgStatus = @"服务器返回网络错误";
            break;
        case EVoiceRecognitionClientErrorStatusClassOffline:
            msgStatus = @"离线识别出错";
            break;
        default:
            msgStatus = @"离线识别出错，错误未知";
            break;
    }
    [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:msgStatus];
}

- (void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFlushData: // 连续上屏中间结果
        {
            NSString *text = [aObj objectAtIndex:0];
            
            if ([text length] > 0)
            {
                //[clientSampleViewController logOutToContinusManualResut:text];
            }
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
        {
            [self createRunLogWithStatus:aStatus];
            
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                //  搜索模式下的结果为数组，示例为
                // ["公园", "公元"]
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i=0; i < [audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
                [self.baiduReact recognitionCallback:@CB_CODE_RESULT result:tmpString];
            }
            else
            {
                NSString *tmpString = [self composeInputModeResult:aObj];
                [self.baiduReact recognitionCallback:@CB_CODE_RESULT result:tmpString];
            }
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            // 此状态只有在输入模式下使用
            // 输入模式下的结果为带置信度的结果，示例如下：
            //  [
            //      [
            //         {
            //             "百度" = "0.6055192947387695";
            //         },
            //         {
            //             "摆渡" = "0.3625582158565521";
            //         },
            //      ]
            //      [
            //         {
            //             "一下" = "0.7665404081344604";
            //         }
            //      ],
            //   ]
            
            NSString *tmpString = [self composeInputModeResult:aObj];
            NSLog(@"receive:%@", tmpString);
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: // 用户说话完成，等待服务器返回识别结果
        {
            [self createRunLogWithStatus:aStatus];
            
            [self freeVoiceLevelMeterTimerTimer];
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {
            [self createRunLogWithStatus:aStatus];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            //                  if ([BDVRSConfig sharedInstance].playStartMusicSwitch) // 如果播放了提示音，此时再给用户提示可以说话
            //                  {
            //                    [self createRecordView];
            //                  }
            [self startVoiceLevelMeterTimer];// 开启语音音量监听
            
            [self createRunLogWithStatus:aStatus];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusNone:
        case EVoiceRecognitionClientWorkPlayStartTone:
        case EVoiceRecognitionClientWorkPlayStartToneFinish:
        case EVoiceRecognitionClientWorkStatusStart:
        case EVoiceRecognitionClientWorkPlayEndToneFinish:
        case EVoiceRecognitionClientWorkPlayEndTone:
        {
            [self createRunLogWithStatus:aStatus];
            break;
        }
        case EVoiceRecognitionClientWorkStatusNewRecordData:
        {
            break;
        }
        default:
        {
            [self createRunLogWithStatus:aStatus];
            break;
        }
    }
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
    }
}

- (void)dealloc
{
    [self freeVoiceLevelMeterTimerTimer];
}

//音量监控
- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];
    
    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate
                                                 interval:VOICE_LEVEL_INTERVAL
                                                   target:self
                                                 selector:@selector(timerFired:)
                                                 userInfo:nil
                                                  repeats:YES];
    self.voiceLevelMeterTimer = tmpTimer;
    [[NSRunLoop currentRunLoop] addTimer:_voiceLevelMeterTimer forMode:NSDefaultRunLoopMode];
}

- (void)timerFired:(id)sender
{
    // 获取语音音量级别
    int voiceLevel = [[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter];
    NSString *statusMsg = [NSLocalizedString(@"StringLogVoiceLevel", nil) stringByAppendingFormat:@": %d", voiceLevel];
    NSLog(@"%@", statusMsg);
    
    [self.baiduReact speechVolume:[NSString stringWithFormat:@"%d", voiceLevel]];
}

- (void)freeVoiceLevelMeterTimerTimer
{
    if(_voiceLevelMeterTimer)
    {
        if([_voiceLevelMeterTimer isValid])
            [_voiceLevelMeterTimer invalidate];
        self.voiceLevelMeterTimer = nil;
    }
}

- (void)createRunLogWithStatus:(int)aStatus
{
    NSString *statusMsg = nil;
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusNone: //空闲
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNone", nil);
            statusMsg = NSLocalizedString(@"空闲", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartTone:  //播放开始提示音
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartTone", nil);
            statusMsg = NSLocalizedString(@"播放开始提示音", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartToneFinish: //播放开始提示音完成
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartToneFinish", nil);
            statusMsg = NSLocalizedString(@"播放开始提示音完成", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: //识别工作开始，开始采集及处理数据
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusStartWorkIng", nil);
//            statusMsg = NSLocalizedString(@"识别工作开始，开始采集及处理数据", nil);
            [self.baiduReact
             recognitionCallback:@CB_CODE_STATUS
             result:@SPEECH_WORK
             ];
            break;
        }
        case EVoiceRecognitionClientWorkStatusStart: //检测到用户开始说话
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusStart", nil);
//            statusMsg = NSLocalizedString(@"检测到用户开始说话", nil);
            [self.baiduReact
             recognitionCallback:@CB_CODE_STATUS
             result:@SPEECH_WORK
             ];
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndTone: //播放结束提示音
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndTone", nil);
            statusMsg = NSLocalizedString(@"播放结束提示音", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndToneFinish: //播放结束提示音完成
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndToneFinish", nil);
            statusMsg = NSLocalizedString(@"播放结束提示音完成", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData: //语音识别功能完成，服务器返回正确结果
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusSentenceFinish", nil);
//            statusMsg = NSLocalizedString(@"语音识别功能完成，服务器返回正确结果", nil);
            [self.baiduReact
             recognitionCallback:@CB_CODE_STATUS
             result:@SPEECH_STOP
             ];
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: //语音识别功能完成，服务器返回正确结果
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusFinish", nil);
//            statusMsg = NSLocalizedString(@"语音识别功能完成，服务器返回正确结果", nil);
            [self.baiduReact
             recognitionCallback:@CB_CODE_STATUS
             result:@SPEECH_STOP
             ];
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: //本地声音采集结束结束，等待识别结果返回并结束录音
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusEnd", nil);
//            statusMsg = NSLocalizedString(@"本地声音采集结束结束，等待识别结果返回并结束录音", nil);
            [self.baiduReact
             recognitionCallback:@CB_CODE_STATUS
             result:@SPEECH_RECOG
             ];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusStart: //网络开始工作
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusStart", nil);
            statusMsg = NSLocalizedString(@"网络开始工作", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:  //网络工作完成
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusEnd", nil);
            statusMsg = NSLocalizedString(@"网络工作完成", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:  // 用户取消
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusCancel", nil);
            statusMsg = NSLocalizedString(@"用户取消", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: // 出现错误
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusErorr", nil);
            statusMsg = NSLocalizedString(@"出现错误", nil);
            [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:statusMsg];
            break;
        }
        default:
        {
            //            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusDefaultErorr", nil);
            statusMsg = NSLocalizedString(@"未知错误", nil);
            [self.baiduReact recognitionCallback:@CB_CODE_ERROR result:statusMsg];
            break;
        }
    }
    
    if (statusMsg)
    {
        [self.baiduReact recognitionCallback:@CB_CODE_LOG result:statusMsg];
        //根据msg处理
    }
}

@end