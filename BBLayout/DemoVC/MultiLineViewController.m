//
//  MultiLineViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "MultiLineViewController.h"
#import "ViewFactory.h"
#import "BBLayoutView.h"
#import "HAlignTestView.h"

@interface MultiLineViewController ()

@property (nonatomic, strong) BBLayoutView *lv_container;

@property (nonatomic, strong) HAlignTestView *hLayoutView;
@property (nonatomic, strong) HAlignTestView *vLayoutView;

@end

@implementation MultiLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.lv_container];
    
    [self.view addSubview:self.hLayoutView];
    [self.view addSubview:self.vLayoutView];
}

- (BBLayoutView *)lv_container {
    if (nil == _lv_container) {
        _lv_container = [BBLayoutView layoutWithFrame:CGRectMake(10, naviBarHeight(), SCREEN_WIDTH-2*10, 160)];
        _lv_container.horizontalAlignment = BBLayoutHorizontalAlignmentRight;
        
        //第一行
        [_lv_container addView:[ViewFactory lableWithTitle:@"fit-width"] leading:8 lineNumber:0 fitWidth:YES];
        [_lv_container addView:[ViewFactory viewWithSize:CGSizeMake(60, 40)] leading:10];
        [_lv_container addView:[ViewFactory viewWithSize:CGSizeMake(80, 20)] leading:15];
        [_lv_container addView:[ViewFactory viewWithSize:CGSizeMake(100, 27)] leading:18];
        
        //第二行
        [_lv_container addLineWithSpace:10];
        [_lv_container addView:[ViewFactory viewWithSize:CGSizeMake(80, 30)] leading:5 lineNumber:1];
        [_lv_container addView:[ViewFactory lableWithTitle:@"这是一个小标题"] leading:8 lineNumber:1];
        [_lv_container addView:[ViewFactory viewWithSize:CGSizeMake(40, 30)] leading:5 lineNumber:1];
        
        //第三行
        [_lv_container addLineWithSpace:16];
        [_lv_container addView:[ViewFactory lableWithTitle:@"这个label自动填充"] leading:0 lineNumber:2 fillWidth:YES];
        
        [_lv_container showBorder];
    }
    return _lv_container;
}

- (HAlignTestView *)hLayoutView {
    if (nil == _hLayoutView) {
        _hLayoutView = [HAlignTestView hAlignmentViewWithFrame:CGRectMake(1, CGRectGetMaxY(self.view.frame) - 100 - 80, SCREEN_WIDTH-2, 40)];
        
        _hLayoutView.demoLayoutView = self.lv_container;
    }
    return _hLayoutView;
}

- (HAlignTestView *)vLayoutView {
    if (nil == _vLayoutView) {
        _vLayoutView = [HAlignTestView vAlignmentViewWithFrame:CGRectMake(1, CGRectGetMaxY(self.view.frame) - 100, SCREEN_WIDTH-2, 40)];
        
        _vLayoutView.demoLayoutView = self.lv_container;
    }
    return _vLayoutView;
}
@end
