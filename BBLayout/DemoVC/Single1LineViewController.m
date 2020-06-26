//
//  Single1LineViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "Single1LineViewController.h"
#import "BBLayoutView.h"
#import "ViewFactory.h"
#import "HAlignTestView.h"

@interface Single1LineViewController ()

@property (nonatomic, strong) BBLayoutView *layoutView;

@property (nonatomic, strong) HAlignTestView *btnLayoutView;

@end

@implementation Single1LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.layoutView];
    
    [self.view addSubview:self.btnLayoutView];
}

- (BBLayoutView *)layoutView {
    if (nil == _layoutView) {
        _layoutView = [[BBLayoutView alloc] initWithFrame:CGRectMake(0, naviBarHeight(), SCREEN_WIDTH, 50)];
        
        [_layoutView addView:[ViewFactory viewWithSize:CGSizeMake(60, 40)] leading:10];
        [_layoutView addView:[ViewFactory viewWithSize:CGSizeMake(20, 50)] leading:20];
        [_layoutView addView:[ViewFactory viewWithSize:CGSizeMake(40, 20)] leading:30];
        UIView *lastView = [ViewFactory viewWithSize:CGSizeMake(100, 10)];
        [_layoutView addView:lastView leading:5];
        
        [_layoutView updateOtherLeading:5 forView:lastView];
        [_layoutView showBorder];
    }
    return _layoutView;
}

- (HAlignTestView *)btnLayoutView {
    if (nil == _btnLayoutView) {
        _btnLayoutView = [HAlignTestView hAlignmentViewWithFrame:CGRectMake(1, CGRectGetMaxY(self.view.frame) - 100, SCREEN_WIDTH-2, 40)];
        
        _btnLayoutView.demoLayoutView = self.layoutView;
    }
    return _btnLayoutView;
}
@end
