//
//  KLineModel.m
//  KLineView
//
//  Created by 谭安溪 on 16/9/29.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import "KLineModel.h"

@implementation KLineModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (instancetype)initWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
