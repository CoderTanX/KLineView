//
//  KLineView.h
//  KLineView
//
//  Created by 谭安溪 on 16/9/27.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineManager.h"
@interface KLineView : UIView
@property (nonatomic, assign) CGFloat borderWidth; ///<边框的宽度
@property (nonatomic, strong) UIColor *borderColor;///<边框的颜色
@property (nonatomic, assign) CGFloat bottomMargin; ///<上下的间距
@property (nonatomic, assign) CGFloat kLineViewHRatio; ///<上面K线图高度所占的比例
@property (nonatomic, strong) KLineManager *manager;///<数据管理类
@end
