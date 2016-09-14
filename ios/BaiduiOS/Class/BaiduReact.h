//
//  BaiduReact.h
//  BaiduiOS
//
//  Created by guojicheng on 16/5/19.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#ifndef BaiduReact_h
#define BaiduReact_h

#import "RCTBridgeModule.h"
#import "BaiduInterface.h"

#define CB_CODE_RESULT "0"
#define CB_CODE_ERROR "1"
#define CB_CODE_STATUS "2"
#define CB_CODE_LOG "3"

#define SPEECH_START "0"//开始
#define SPEECH_WORK "1"//检测到说话，工作中
#define SPEECH_RECOG "2"//识别中
#define SPEECH_STOP "3"//停止

@interface BaiduReact : NSObject<RCTBridgeModule>
{
    
}

- (void)HelloWorld;
- (void)setInfo:(NSDictionary *) infos;
- (void)recognitionCallback:(NSString*)code result:(NSString*)result;
- (void)speechVolume:(NSString*)volume;

@property (nonatomic, retain) BaiduInterface *baidu;

@end


#endif /* BaiduReact_h */
