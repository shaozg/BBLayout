//
//  CellDemoViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/4.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "CellDemoViewController.h"
#import "BBLayoutView.h"
#import "ViewFactory.h"

@interface CellDemoViewController ()

@property (nonatomic, strong) BBLayoutView *hLayoutView;
@property (nonatomic, strong) BBLayoutView *vTitleLayoutView;

@property (nonatomic, strong) BBLayoutView *ctlBtnLayout;

@property (nonatomic, strong) UIView *mvView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *memLabel;

@property (nonatomic, assign) BOOL longTitle;
@end

@implementation CellDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hLayoutView];
    [self.view addSubview:self.ctlBtnLayout];
    
    [self.vTitleLayoutView showBorder];
    [self.hLayoutView showBorder];
    [self.ctlBtnLayout showBorder];
}

- (BBLayoutView *)hLayoutView {
    if (nil == _hLayoutView) {
        _hLayoutView = [BBLayoutView layoutWithFrame:CGRectMake(0, naviBarHeight(), SCREEN_WIDTH, 66) horizontalAlignment:BBLayoutHorizontalAlignmentJustified];
        
        UILabel *sortLabel = [ViewFactory lableWithTitle:@"2"];
        sortLabel.textAlignment = NSTextAlignmentCenter;
        sortLabel.frame = CGRectMake(0, 0, 40, 30);
        [_hLayoutView addView:sortLabel leading:10 index:0];
        
        [_hLayoutView addView:self.vTitleLayoutView leading:10 lineNumber:0 fillWidth:YES];
        [_hLayoutView updateIndex:1 forView:self.vTitleLayoutView];
        
        CGSize s = CGSizeMake(30, 30);
        self.mvView = [ViewFactory imageViewWithSize:s];
        [_hLayoutView addView:[ViewFactory imageViewWithSize:s] leading:5 index:-1];
        [_hLayoutView addView:self.mvView leading:10 index:-2];
        
        [_hLayoutView updateOtherLeading:10 forView:self.vTitleLayoutView];
    }
    
    return _hLayoutView;
}

- (BBLayoutView *)vTitleLayoutView {
    if (nil == _vTitleLayoutView) {
        _vTitleLayoutView = [BBLayoutView layoutWithFrame:CGRectMake(0, 0, 100, 66)];
        
        self.titleLabel = [ViewFactory lableWithTitle:@"给未来"];
        [_vTitleLayoutView addView:self.titleLabel leading:0 lineNumber:0 fitWidth:YES];
        
        UILabel *l = [ViewFactory lableWithTitle2:@"会员"];
        self.memLabel = l;
        self.descLabel = [ViewFactory lableWithTitle:@"李现"];
        [_vTitleLayoutView addLineWithSpace:10];
        [_vTitleLayoutView addView:[ViewFactory lableWithTitle2:@"无损"] leading:0 lineNumber:1];
        [_vTitleLayoutView addView:l leading:5 lineNumber:1];
        [_vTitleLayoutView addView:self.descLabel leading:5 lineNumber:1 fillWidth:YES];
    }
    return _vTitleLayoutView;
}

- (BBLayoutView *)ctlBtnLayout {
    if (nil == _ctlBtnLayout) {
        _ctlBtnLayout = [BBLayoutView layoutWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 100, SCREEN_WIDTH, 40) horizontalAlignment:BBLayoutHorizontalAlignmentCenter];
        
        CGSize size = CGSizeMake(80, 40);
        UIView *btn1 = [ViewFactory btnWithTitle:@"长标题" size:size target:self action:@selector(onClickLongTitle:) tag:1];
        [_ctlBtnLayout addView:btn1];
        
        UIButton *btn2 = [ViewFactory btnWithTitle:@"隐藏会员" size:size target:self action:@selector(hideMemLabelBtn:) tag:2];
        [_ctlBtnLayout addView:btn2 leading:30];
        
        UIButton *btn3 = [ViewFactory btnWithTitle:@"隐藏MV" size:size target:self action:@selector(hideMVBtn:) tag:3];
        [_ctlBtnLayout addView:btn3 leading:30];
    }
    return _ctlBtnLayout;
}


- (void)onClickLongTitle:(UIButton *)btn {
    if (!self.longTitle) {
        self.titleLabel.text = @"这是一个非常非常长非常非常古老的流行歌曲标题的名字";
        self.descLabel.text = @"这个一个副标题，副标题也可能比较长，虽然不会换行还是会超出范围的";
    } else {
        self.titleLabel.text = @"给未来";
        self.descLabel.text = @"李现";
    }
    [self.titleLabel sizeToFit];
//    [self.vTitleLayoutView layout];
    [btn setTitle:!self.longTitle ? @"短标题" : @"长标题" forState:UIControlStateNormal];
    self.longTitle = !self.longTitle;
}

- (void)hideMemLabelBtn:(UIButton *)btn {
    if ([self.memLabel superview] != nil) {
        [self.vTitleLayoutView removeView:self.memLabel];
        [btn setTitle:@"显示会员" forState:UIControlStateNormal];
    } else {
        [self.vTitleLayoutView insertView:self.memLabel leading:5 lineNumber:1 atIndex:1];
        [btn setTitle:@"隐藏会员" forState:UIControlStateNormal];
    }
}

- (void)hideMVBtn:(UIButton *)btn {
    if (self.mvView.superview != nil) {
        [self.titleLabel sizeToFit];
        [self.hLayoutView removeView:self.mvView];
        [btn setTitle:@"显示MV" forState:UIControlStateNormal];
    } else {
        [self.hLayoutView insertView:self.mvView leading:10 lineNumber:0 atIndex:2];
        [self.hLayoutView updateIndex:-2 forView:self.mvView];
        [btn setTitle:@"隐藏MV" forState:UIControlStateNormal];
    }
}
@end
