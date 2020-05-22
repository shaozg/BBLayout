//
//  Demo2ViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "Demo2ViewController.h"
#import "BBLayoutView.h"
#import "ViewFactory.h"

@interface Demo2ViewController ()

@property (nonatomic, strong) BBLayoutView *lv_justifiedContainer;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"两端对齐布局";
    
    [self.view addSubview:self.lv_justifiedContainer];
    self.lv_justifiedContainer.frame = CGRectMake(5, naviBarHeight(), SCREEN_WIDTH-2*5, 40);
    [self.lv_justifiedContainer showBorder];
}

- (BBLayoutView *)lv_justifiedContainer {
    if (nil == _lv_justifiedContainer) {
        _lv_justifiedContainer = [BBLayoutView layoutWithFrame:CGRectZero];
        
        BBLayoutLineModel *lineModel = [BBLayoutLineModel lineModelWithAlignment:BBLayoutHorizontalAlignmentJustified];
        [lineModel addView:[ViewFactory lableWithTitle:@"索引0"] leading:5 index:0];
        [lineModel addView:[ViewFactory lableWithTitle:@"索引1"] leading:10 index:1];
        [lineModel addView:[ViewFactory lableWithTitle:@"索引-1"] leading:5 index:-1];
        [lineModel addView:[ViewFactory lableWithTitle:@"索引-2"] leading:10 index:-2];
        [_lv_justifiedContainer addLineModel:lineModel];
    }
    return _lv_justifiedContainer;
}

@end
