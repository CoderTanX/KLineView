//
//  KLineView.h
//  KLineView
//
//  Created by 谭安溪 on 16/9/27.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLineView : UIView
@property (nonatomic, assign) CGFloat borderWidth; ///<边框的宽度
@property (nonatomic, strong) UIColor *borderColor;///<边框的颜色
@property (nonatomic, assign) CGFloat bottomMargin; ///<上下的间距
@property (nonatomic, assign) CGFloat kLineViewHRatio; ///<上面K线图高度所占的比例
@end
