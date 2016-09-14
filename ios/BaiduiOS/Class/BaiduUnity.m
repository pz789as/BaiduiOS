//
//  BaiduUnity.m
//  BaiduiOS
//
//  Created by guojicheng on 16/5/31.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "BaiduUnity.h"
#import "BaiduInterface.h"

@implementation BaiduUnity

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

-(void)start
{
    [_baidu start];
}

-(void)stop
{
    [_baidu stop];
}

-(void)cancel
{
    [_baidu cancel];
}

-(void)asrCallback
{
    UnitySendMessage("Main Camera", "XunfeiISE", "成功啦.哇哈哈哈");
}

@end

BaiduUnity *m_baiduUnity = NULL;

#if defined (__cplusplus)
extern "C"
{
#endif
    void _Start()
    {
        if (m_baiduUnity == NULL)
        {
            m_baiduUnity = [[BaiduUnity alloc] init];
        }
        m_baiduUnity.start();
    }
#if defined (__cplusplus)
}
#endif
