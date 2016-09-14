//
//  BaiduInterface.h
//  BaiduiOS
//
//  Created by guojicheng on 16/5/19.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#ifndef BaiduInterface_h
#define BaiduInterface_h

#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"

@class BaiduReact;

//#error 请修改为您在百度开发者平台申请的API_KEY和SECRET_KEY
#define API_KEY @"9oI5nu0IRWnt8Eq8QuGyEoMP" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"Aw7w385DGFkEmU5YE82tx1lP7DASkxl5" // 请修改您在百度开发者平台申请的SECRET_KEY

//#error 请修改为您在百度开发者平台申请的APP ID
#define APPID @"3407383" // 请修改为您在百度开发者平台申请的APP ID

@interface BaiduInterface : BDVoiceRecognitionClient<MVoiceRecognitionClientDelegate>
{
}

@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;
@property (nonatomic, assign) BOOL isSetting;
@property (nonatomic, retain) BaiduReact *baiduReact;

- (void)start;
- (void)finish;
- (void)cancel;

- (void)setInfo:(NSDictionary *)infos baiduReact:(BaiduReact*)baiduReact;

- (NSString *)composeInputModeResult:(id)aObj;

@end

#endif /* BaiduInterface_h */
