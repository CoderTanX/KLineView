//
//  KLineView.m
//  KLineView
//
//  Created by 谭安溪 on 16/9/27.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import "KLineView.h"
#import "KLineModel.h"
#define offsetLeftX  50
#define labelMargin 2
@interface KLineView ()
@property (nonatomic, assign) CGFloat contentLeft;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) NSMutableArray *kLines;
@property (nonatomic,assign) CGFloat maxPrice;///<最高价格
@property (nonatomic,assign) CGFloat minPrice;///<最低价格
@property (nonatomic,assign) CGFloat maxOffsetPrice;///<最大的偏移价格
@property (nonatomic,assign) NSInteger maxVolume;///<最大交易量
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;///<长按手势
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
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}

- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureSelected:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return  _longPressGesture;
}
- (void)longPressGestureSelected:(UILongPressGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    
    if (point.x<self.contentLeft) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged){
        NSLog(@"------");
        [self setNeedsDisplay];
    }
    
    
    
    
    
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
//    NSLog(@"%ld",self.maxVolume);
    //设置偏移量
    self.contentLeft = rect.origin.x + offsetLeftX;
    self.contentWidth = rect.size.width - self.contentLeft;
    //获取图文上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
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
    
    //底部量线
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft,rect.size.height - (rect.size.height - rect.size.height * self.kLineViewHRatio - self.bottomMargin)/2) endPoint:CGPointMake(rect.size.width,rect.size.height - (rect.size.height - rect.size.height * self.kLineViewHRatio - self.bottomMargin)/2) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft +  self.contentWidth * 0.5, rect.size.height * self.kLineViewHRatio + self.bottomMargin) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.5, rect.size.height) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.25, rect.size.height * self.kLineViewHRatio + self.bottomMargin) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.25, rect.size.height) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    [self drawLineContext:context startPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.75, rect.size.height * self.kLineViewHRatio + self.bottomMargin) endPoint:CGPointMake(self.contentLeft + self.contentWidth * 0.75, rect.size.height) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:YES];
    
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
    //开盘价格
    KLineModel *kLine = self.manager.kLines.firstObject;
    CGFloat pre_close_px = kLine.pre_close_px;
    NSString *maxPrice = [NSString stringWithFormat:@"%.2f",self.maxOffsetPrice + pre_close_px];
    CGSize maxPriceLabelSize = [maxPrice sizeWithAttributes:attrs];
    [maxPrice drawAtPoint:CGPointMake(self.contentLeft - maxPriceLabelSize.width - labelMargin, rect.origin.x) withAttributes:attrs];
    NSString *midPrice = [NSString stringWithFormat:@"%.2f",pre_close_px];
    CGSize midPriceLabelSize = [midPrice sizeWithAttributes:attrs];
    [midPrice drawAtPoint:CGPointMake(self.contentLeft - midPriceLabelSize.width - labelMargin, rect.size.height * self.kLineViewHRatio * 0.5 - midPriceLabelSize.height * 0.5) withAttributes:attrs];
    NSString *minPrice = [NSString stringWithFormat:@"%.2f",pre_close_px - self.maxOffsetPrice];;
    CGSize minPriceLabelSize = [minPrice sizeWithAttributes:attrs];
    [minPrice drawAtPoint:CGPointMake(self.contentLeft - midPriceLabelSize.width - labelMargin, rect.size.height * self.kLineViewHRatio - minPriceLabelSize.height) withAttributes:attrs];
    
    //中间量
    NSString *midVolumn = [NSString stringWithFormat:@"%ld",self.maxVolume/2];
    CGSize midVolumnSize = [midVolumn sizeWithAttributes:attrs];
    [midVolumn drawAtPoint:CGPointMake(self.contentLeft - midVolumnSize.width - labelMargin, rect.size.height - (rect.size.height - rect.size.height * self.kLineViewHRatio - self.bottomMargin)/2 -  midVolumnSize.height/2) withAttributes:attrs];
    NSString *maxVolumn = [NSString stringWithFormat:@"%ld",self.maxVolume];
    CGSize maxVolumnSize = [maxVolumn sizeWithAttributes:attrs];
    [maxVolumn drawAtPoint:CGPointMake(self.contentLeft - maxVolumnSize.width - labelMargin, rect.size.height * self.kLineViewHRatio + self.bottomMargin) withAttributes:attrs];
    
    
    //每个点占得宽度
    CGFloat pointWidth = self.contentWidth/270;
    //每个点占得高度
    CGFloat pointHeight = (rect.size.height *  self.kLineViewHRatio)/(2 * self.maxOffsetPrice);
    CGPoint StartPoint = CGPointZero;
    UIColor *volumnColor = [UIColor redColor];
    CGFloat StartPrice = 0.0;
    //画折线图
    for (int i= 0; i<self.manager.kLines.count; i++) {
        
        if (i == 0) {
            //起点
            KLineModel *kline = self.manager.kLines.firstObject;
            CGFloat startX = self.contentLeft + pointWidth/2;
            CGFloat startY = (self.maxOffsetPrice + pre_close_px - kline.last_px) * pointHeight;
            StartPoint = CGPointMake(startX, startY);
            StartPrice = kline.last_px;
        }else{
            
            
            KLineModel *kline = self.manager.kLines[i];
            CGFloat endX = self.contentLeft + i *pointWidth + pointWidth/2;
            CGFloat endY = rect.origin.y + (self.maxOffsetPrice + pre_close_px - kline.last_px) * pointHeight;
            CGPoint endPoint = CGPointMake(endX, endY);
            [self drawLineContext:context startPoint:StartPoint endPoint:endPoint lineWidth:1.0 lineColor:[UIColor blackColor] isDashed:NO];
            
            if (kline.last_px > StartPrice) {
                volumnColor = [UIColor redColor];
            }else if (kline.last_px < StartPrice){
                volumnColor = [UIColor greenColor];
            }else{
                volumnColor = [UIColor grayColor];
            }
            StartPrice = kline.last_px;
            
            StartPoint = endPoint;
            
            
        }
        //画成交量的线
        KLineModel *kline = self.manager.kLines[i];
        CGFloat volumnHeightScale = (rect.size.height - rect.size.height * self.kLineViewHRatio - self.bottomMargin)/self.maxVolume;
        [volumnColor setFill];
        CGContextFillRect(context, CGRectMake(self.contentLeft + i * pointWidth, rect.size.height - kline.last_volume_trade/100 * volumnHeightScale, pointWidth, kline.last_volume_trade/100 * volumnHeightScale));
        
    }
    
    if (self.longPressGesture.state == UIGestureRecognizerStateBegan || self.longPressGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [self.longPressGesture locationInView:self];
        NSInteger index =  floor((point.x - self.contentLeft)/pointWidth);
        NSLog(@"%ld",index);
        if (index<self.manager.kLines.count) {
            KLineModel *kLine = self.manager.kLines[index];
//            CGFloat selectPrice = kLine.last_px;
            CGFloat selectLineY = (self.maxOffsetPrice + pre_close_px - kLine.last_px) * pointHeight;
            CGFloat selectLineX = self.contentLeft + index *pointWidth + pointWidth/2;
            [self drawLineContext:context startPoint:CGPointMake(selectLineX, 0) endPoint:CGPointMake(selectLineX, rect.size.height) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:NO];
            [self drawLineContext:context startPoint:CGPointMake(self.contentLeft, selectLineY) endPoint:CGPointMake(rect.size.width, selectLineY) lineWidth:self.borderWidth lineColor:self.borderColor isDashed:NO];
            NSString *selectTime = kLine.curr_time;
            CGSize selectTimeSize = [selectTime sizeWithAttributes:attrs];
            [[UIColor whiteColor] setFill];
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextFillRect(context, CGRectMake(selectLineX - selectTimeSize.width*0.5, rect.size.height * self.kLineViewHRatio, selectTimeSize.width, selectTimeSize.height));
            [selectTime drawAtPoint:CGPointMake(selectLineX - selectTimeSize.width*0.5, rect.size.height * self.kLineViewHRatio) withAttributes:attrs];
            NSString *currentPrice = [NSString stringWithFormat:@"%.2f",kLine.last_px];
            CGSize currentPriceSize = [currentPrice sizeWithAttributes:attrs];
            [[UIColor whiteColor] setFill];
            CGContextFillRect(context, CGRectMake(self.contentLeft - currentPriceSize.width - labelMargin, selectLineY - currentPriceSize.height * 0.5, currentPriceSize.width, currentPriceSize.height));
            [currentPrice drawAtPoint:CGPointMake(self.contentLeft - currentPriceSize.width - labelMargin, selectLineY - currentPriceSize.height * 0.5) withAttributes:attrs];
            
        }
    }
    
}
- (CGFloat)maxPrice{
    return [[self.manager.kLines valueForKeyPath:@"@max.last_px.floatValue"] floatValue];
}

- (CGFloat)minPrice{
    return [[self.manager.kLines valueForKeyPath:@"@min.last_px.floatValue"] floatValue];
}

- (CGFloat)maxOffsetPrice{
    //开盘价格
    KLineModel *kLine = self.manager.kLines.firstObject;
    CGFloat pre_close_px = kLine.pre_close_px;
    return MAX(fabs(self.maxPrice - pre_close_px), fabs(pre_close_px - self.minPrice));
}
- (NSInteger)maxVolume{
    return [[self.manager.kLines valueForKeyPath:@"@max.last_volume_trade.integerValue"] integerValue]/100;
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
    //保存context
    CGContextSaveGState(context);
    //设置起点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    //设置细线宽度
    CGContextSetLineWidth(context, lineWidth);
    if (isDashed) {//画虚线
        CGFloat lengths[] = {1,1};
        CGContextSetLineDash(context, 0, lengths, 1);
    }
    //设置细线颜色
    [lineColor setStroke];
    //设置终点
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    //换线
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}



@end
