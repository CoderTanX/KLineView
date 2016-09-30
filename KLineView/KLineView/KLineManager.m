//
//  KLineManager.m
//  KLineView
//
//  Created by 谭安溪 on 16/9/29.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import "KLineManager.h"
#import "KLineModel.h"
@implementation KLineManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.kLines = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
        NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *dataArray = dataDict[@"data3"];
        for (NSDictionary *dict in dataArray) {
            KLineModel *kLine = [KLineModel initWithDict:dict];
            [self.kLines addObject:kLine];
        }
    }
    return self;
}
@end
