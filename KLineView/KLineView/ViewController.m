//
//  ViewController.m
//  KLineView
//
//  Created by 谭安溪 on 16/9/27.
//  Copyright © 2016年 谭安溪. All rights reserved.
//

#import "ViewController.h"
#import "KLineView.h"
#import "KLineManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet KLineView *klineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KLineManager *manager = [[KLineManager alloc] init];
    self.klineView.manager = manager;
}



@end
