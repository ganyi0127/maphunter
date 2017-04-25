//
//  ACWifiInfo.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/7/20.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACWifiInfo : NSObject
//wifi名
@property (nonatomic, copy) NSString *ssid;
//wifi强度
@property (nonatomic, assign) NSInteger power;

- (instancetype)initWithSsid:(NSString *)ssid power:(NSInteger)power;
@end