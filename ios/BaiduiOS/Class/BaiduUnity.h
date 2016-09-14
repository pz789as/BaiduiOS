//
//  BaiduUnity.h
//  BaiduiOS
//
//  Created by guojicheng on 16/5/31.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaiduInterface;

@interface BaiduUnity : NSObject

@property (nonatomic, retain) BaiduInterface *baidu;

-(void)start;
-(void)stop;
-(void)cancel;

@end
