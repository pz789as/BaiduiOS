//
//  BaiduReact.m
//  BaiduiOS
//
//  Created by guojicheng on 16/5/19.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaiduReact.h"
#import "RCTEventDispatcher.h"
#import "RCTConvert.h"

//@implementation RCTConvert(Speech_Status)
//
//RCT_ENUM_CONVERTER(Speech_Status,
//                   (
//                    @{
//                      @"SPEECH_START":@(SPEECH_START),
//                      @"SPEECH_WORK":@(SPEECH_WORK),
//                      @"SPEECH_RECOG":@(SPEECH_RECOG),
//                      @"SPEECH_STOP":@(SPEECH_STOP)
//                      }),
//                   SPEECH_STOP,
//                   integerValue);
//
//- (NSDictionary*)constantsToExport
//{
//    return @{
//             @"SPEECH_START":@(SPEECH_START),
//             @"SPEECH_WORK":@(SPEECH_WORK),
//             @"SPEECH_RECOG":@(SPEECH_RECOG),
//             @"SPEECH_STOP":@(SPEECH_STOP)
//             };
//}
//@end

@implementation BaiduReact

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(HelloWorld)
{
    NSLog(@"Test Print HelloWorld!");
}

RCT_EXPORT_METHOD(start)
{
    NSLog(@"start recognition");
    [self.baidu start];
}

RCT_EXPORT_METHOD(setInfo:(NSDictionary *) infos)
{
    NSLog(@"set infos for recognition");
    [self.baidu setInfo:infos baiduReact:self];
}

RCT_EXPORT_METHOD(finish)
{
    NSLog(@"finish recognition");
    [self.baidu finish];
}

RCT_EXPORT_METHOD(cancel)
{
    NSLog(@"cancel recognition");
    [self.baidu cancel];
}

- (instancetype) init
{
    self = [super init];
    self.baidu = [[BaiduInterface alloc] init];
    if (self.baidu){
        NSLog(@"初始化百度语音成功");
    }else{
        NSLog(@"初始化百度语音失败");
    }
    
    return self;
}

- (void) dealloc
{
    
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"CB_CODE_RESULT":@"0",
             @"CB_CODE_ERROR":@"1",
             @"CB_CODE_STATUS":@"2",
             @"CB_CODE_LOG":@"3",
             
             @"SPEECH_START":@"0",
             @"SPEECH_WORK":@"1",
             @"SPEECH_RECOG":@"2",
             @"SPEECH_STOP":@"3",
             };
}

@synthesize bridge = _bridge;

- (void)recognitionCallback:(NSString*)code result:(NSString*)result
{
    [_bridge.eventDispatcher
     sendDeviceEventWithName:@"recognitionCallback"
     body:@{
            @"code":code,
            @"result":result
            }];
//    NSLog(@"code:%@, result:%@", code, result);
}

- (void)speechVolume:(NSString*)volume
{
    [_bridge.eventDispatcher
     sendDeviceEventWithName:@"getVolume"
     body:@{
            @"volume":volume
            }];
}

@end