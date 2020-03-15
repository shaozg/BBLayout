//
//  AnimationViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/15.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "AnimationViewController.h"
#import "ViewFactory.h"
#import "BBLayoutView.h"

#define kAnimationDur 1

@interface AnimationViewController ()

@property (nonatomic, strong) BBLayoutView *hLayoutView;
@property (nonatomic, strong) BBLayoutView *rLayoutView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hLayoutView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.timer fire];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

- (BBLayoutView *)hLayoutView {
    if (nil == _hLayoutView) {
        CGRect rc = CGRectMake(5, naviBarHeight()+10, SCREEN_WIDTH-2*5, 80);
        _hLayoutView = [BBLayoutView layoutWithFrame:rc];
        
        UIView *v1 = [ViewFactory viewWithSize:CGSizeMake(0, rc.size.height)];
        [_hLayoutView addView:v1 leading:0];
        __weak typeof(self) weaSelf = self;
        [_hLayoutView updateWidthBlock:^CGFloat{
            __strong typeof(self) strongSelf = weaSelf;
            return (strongSelf.hLayoutView.frame.size.width - 20) * 0.6;
        } forView:v1];
        
        [_hLayoutView addView:self.rLayoutView leading:20];
        [_hLayoutView updateWidthBlock:^CGFloat{
            __strong typeof(self) strongSelf = weaSelf;
            return (strongSelf.hLayoutView.frame.size.width - 20) * 0.4;
        } forView:self.rLayoutView];
        
        [_hLayoutView showBorder];
    }
    return _hLayoutView;
}

- (BBLayoutView *)rLayoutView {
    if (nil == _rLayoutView) {
        CGFloat right_v_w = 30;
        _rLayoutView = [BBLayoutView layoutWithFrame:CGRectMake(0, 0, 0, 80)];
        _rLayoutView.verticalAlignment = BBLayoutVerticalAlignmentCenter;
        
        UIView *v1 = [ViewFactory viewWithSize:CGSizeMake(0, 30)];
        [_rLayoutView addView:v1 leading:0];
        
        [_rLayoutView addView:[ViewFactory viewWithSize:CGSizeMake(right_v_w, 30)] leading:20];
        
        [_rLayoutView addLineWithSpace:5];
        UIView *v21 = [ViewFactory viewWithSize:CGSizeMake(0, 30)];
        [_rLayoutView addView:v21 leading:0 lineNumber:1];
        
        [_rLayoutView addView:[ViewFactory viewWithSize:CGSizeMake(right_v_w, 30)] leading:20 lineNumber:1];
        
        __weak typeof(self) weaSelf = self;
        [_rLayoutView updateWidthBlock:^CGFloat{
            __strong typeof(self) strongSelf = weaSelf;
            return strongSelf.rLayoutView.frame.size.width - 20 - right_v_w;
        } forView:v1];
        
        [_rLayoutView updateWidthBlock:^CGFloat{
            __strong typeof(self) strongSelf = weaSelf;
            return strongSelf.rLayoutView.frame.size.width - 20 - right_v_w;
        } forView:v21 lineNumber:1];
        
//        [_rLayoutView showBorderWithColor:[UIColor orangeColor] width:3];
    }
    return _rLayoutView;
}

- (NSTimer *)timer {
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kAnimationDur target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)timerEvent:(id)sender {
    static float rate = 1;
    if (rate >= 0.9) {
        rate = 0.4;
    } else {
        rate = 1;
    }
    
    [UIView animateWithDuration:kAnimationDur animations:^{
        self.hLayoutView.frame = CGRectMake(5, naviBarHeight()+10, (SCREEN_WIDTH-2*5)*rate, 80);
        [self.hLayoutView layout];
        [self.rLayoutView layout];
    }];
}
@end
