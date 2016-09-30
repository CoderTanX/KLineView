//
//  KLineModel.h
//  KLineView
//
//  Created by 谭安溪 on 16/9/29.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLineModel : NSObject
@property (nonatomic, copy) NSString *data_time_stamp;///<时间
@property (nonatomic, copy) NSString *curr_time;///<当前时间
@property (nonatomic, assign) CGFloat last_px;///<价格
@property (nonatomic, assign) CGFloat pre_close_px;///<开盘价格
@property (nonatomic, assign) NSInteger last_volume_trade;///<交易量
+ (instancetype)initWithDict:(NSDictionary *)dict;
@end
