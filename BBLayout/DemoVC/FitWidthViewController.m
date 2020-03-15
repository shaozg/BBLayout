//
//  FitWidthViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "FitWidthViewController.h"
#import "BBLayoutView.h"
#import "ViewFactory.h"

@interface FitWidthViewController ()

@property (nonatomic, strong) BBLayoutView *layoutView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) BBLayoutView *ctlBtnLayout;

@end

@implementation FitWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Label自适应高度布局";
    
    [self.view addSubview:self.layoutView];
    
    [self.view addSubview:self.ctlBtnLayout];
}

- (BBLayoutView *)layoutView {
    if (nil == _layoutView) {
        CGRect rc = CGRectMake(5, naviBarHeight(), SCREEN_WIDTH-2*5, 120);
        _layoutView = [BBLayoutView layoutWithFrame:rc];
        
        self.titleLabel = [ViewFactory lableWithTitle:@"asdojifawejfao0sidjfgoia扫"];
        self.titleLabel.numberOfLines = 3;
        self.titleLabel.textAlignment = NSTextAlignmentJustified;
        UILabel *label2 = [ViewFactory lableWithTitle:@"aoefu8w9uf不好不知道"];
        
        [_layoutView addView:self.titleLabel leading:5 lineNumber:0 fillWidth:YES];
        [_layoutView addView:label2 leading:5 lineNumber:1];
        [_layoutView updateLineSpace:15 lineNumber:1];
        
        [_layoutView showBorder];
    }
    return _layoutView;
}

- (BBLayoutView *)ctlBtnLayout {
    if (nil == _ctlBtnLayout) {
        _ctlBtnLayout = [BBLayoutView layoutWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 100, SCREEN_WIDTH, 40) horizontalAlignment:BBLayoutHorizontalAlignmentCenter];
        
        CGSize size = CGSizeMake(80, 40);
        UIView *btn1 = [ViewFactory btnWithTitle:@"+" size:size target:self action:@selector(onClickPlusTitle:) tag:1];
        [_ctlBtnLayout addView:btn1];
        
        UIButton *btn2 = [ViewFactory btnWithTitle:@"-" size:size target:self action:@selector(onClickMinusTitle:) tag:2];
        [_ctlBtnLayout addView:btn2 leading:30];
    }
    return _ctlBtnLayout;
}


- (void)onClickPlusTitle:(UIButton *)btn {
    NSString *title = [NSString stringWithFormat:@"%@-%c", self.titleLabel.text, arc4random_uniform(26)+'A'];
    [self updateTitle:title];
}

- (void)onClickMinusTitle:(UIButton *)btn {
    NSString *title = self.titleLabel.text;
    if (title.length > 1) {
        title = [title substringToIndex:title.length-1];
        [self updateTitle:title];
    }
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
    
    [self.layoutView layout];
}
@end
