//
//  KLineView.m
//  KLineView
//
//  Created by 谭安溪 on 16/9/27.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import "KLineView.h"
#define offsetLeftX  50
#define labelMargin 2
@interface KLineView ()
@property (nonatomic, assign) CGFloat contentLeft;
@property (nonatomic, assign) CGFloat contentWidth;
@end
@implementation KLineView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置初始值
        self.borderWidth = 1.0;
        self.borderColor = [UIColor grayColor];
        self.bottomMargin = 25.0;
        self.kLineViewHRatio = 0.65;
        [self addObserver];
    }
    return self;
}

- (void)addObserver
{   //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void) deviceOrientationDidChange:(NSNotification *) notification
{   //重新布局一下
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //设置偏移量
    self.contentLeft = rect.origin.x + offsetLeftX;
    self.contentWidth = rect.size.width - self.contentLeft;
    //获取图文上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画线的宽度，默认位1.0
    CGContextSetLineWidth(context, self.borderWidth);
    //设置画线的颜色
    [self.borderColor setStroke];
    //开始画上面k线图的边框
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, rect.origin.y, self.contentWidth, rect.size.height * self.kLineViewHRatio));
    //开始画下面的交易量图的边框
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, rect.origin.y + rect.size.height * self.kLineViewHRatio + self.bottomMargin, self.contentWidth, rect.size.height - (rect.origin.y + rect.size.height * self.kLineViewHRatio + self.bottomMargin)));
    
    //kLineView内部竖线
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft +  self.contentWidth * 0.5, rect.origin.y) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.5, rect.origin.y + rect.size.height * self.kLineViewHRatio) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.25, rect.origin.y) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.25, rect.origin.y + rect.size.height * self.kLineViewHRatio) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.75, rect.origin.y) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.75, rect.origin.y + rect.size.height * self.kLineViewHRatio) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    //kLineView内部横线
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft, rect.size.height * self.kLineViewHRatio * 0.5) endPoint:CGPointMake(self.contentLeft + rect.size.width, rect.size.height * self.kLineViewHRatio * 0.5) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:NO];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft, rect.size.height * self.kLineViewHRatio * 0.25) endPoint:CGPointMake(self.contentLeft + rect.size.width, rect.size.height * self.kLineViewHRatio * 0.25) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft, rect.size.height * self.kLineViewHRatio * 0.75) endPoint:CGPointMake(self.contentLeft + rect.size.width, rect.size.height * self.kLineViewHRatio * 0.75) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    
    //画时间Label
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    //开始时间
    NSString *startTime = @"9:30";
    [startTime drawAtPoint:CGPointMake(self.contentLeft, rect.size.height * self.kLineViewHRatio) withAttributes:attrs];
    //中间时间
    NSString *midTime = @"11:30";
    CGSize midLabelSize = [midTime sizeWithAttributes:attrs];
    [midTime drawAtPoint:CGPointMake(self.contentLeft + (self.contentWidth - midLabelSize.width) * 0.5, rect.size.height * self.kLineViewHRatio) withAttributes:attrs];
    //结束时间
    NSString *endTime = @"15:00";
    CGSize endLabelSize = [endTime sizeWithAttributes:attrs];
    [endTime drawAtPoint:CGPointMake(self.contentLeft + self.contentWidth - endLabelSize.width, rect.size.height * self.kLineViewHRatio) withAttributes:attrs];
    //画价格
    NSString *maxPrice = @"6.54";
    CGSize maxPriceLabelSize = [maxPrice sizeWithAttributes:attrs];
    [maxPrice drawAtPoint:CGPointMake(self.contentLeft - maxPriceLabelSize.width - labelMargin, rect.origin.x) withAttributes:attrs];
    NSString *midPrice = @"6.32";
    CGSize midPriceLabelSize = [midPrice sizeWithAttributes:attrs];
    [midPrice drawAtPoint:CGPointMake(self.contentLeft - midPriceLabelSize.width - labelMargin, rect.size.height * self.kLineViewHRatio * 0.5 - midPriceLabelSize.height * 0.5) withAttributes:attrs];
    NSString *minPrice = @"6.23";
    CGSize minPriceLabelSize = [minPrice sizeWithAttributes:attrs];
    [minPrice drawAtPoint:CGPointMake(self.contentLeft - midPriceLabelSize.width - labelMargin, rect.size.height * self.kLineViewHRatio - minPriceLabelSize.height) withAttributes:attrs];
}


/**
 *  根据两个点画一条细线
 *
 *  @param context    上下文
 *  @param startPoint 起点
 *  @param endPoint   终点
 *  @param lineWidth  细线宽度
 *  @param lineColor  细线颜色
 *  @param isDashed   是否是虚线
 */
- (void)drawLineContext:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor isDashed:(BOOL)isDashed{
    //设置起点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    //设置细线宽度
    CGContextSetLineWidth(context, lineWidth);
    if (isDashed) {//画虚线
        CGFloat lengths[] = {1,1};
        CGContextSetLineDash(context, 0, lengths, 1);
    }else{
        CGFloat lengths[] = {1,0};
        CGContextSetLineDash(context, 0, lengths, 0);
    }
    //设置细线颜色
    [lineColor setStroke];
    //设置终点
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    //换线
    CGContextStrokePath(context);
    
}



@end
