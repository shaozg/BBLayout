//
//  ViewController.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "ViewController.h"
#import "BBLayoutView.h"
#import "ViewFactory.h"
#import "Single1LineViewController.h"
#import "Demo2ViewController.h"
#import "FitWidthViewController.h"
#import "MultiLineViewController.h"
#import "CellDemoViewController.h"
#import "CellTableViewController.h"
#import "AnimationViewController.h"

@interface ViewController ()

@property (nonatomic, strong) BBLayoutView *layoutView;

@end

@implementation ViewController

- (BBLayoutView *)layoutView {
    if (nil == _layoutView) {
        NSInteger lineIndex = 1;
        
        CGRect rc = CGRectMake(0, naviBarHeight(), self.view.frame.size.width, self.view.frame.size.height - naviBarHeight());
        _layoutView = [[BBLayoutView alloc] initWithFrame:rc];
        _layoutView.horizontalAlignment = BBLayoutHorizontalAlignmentCenter;
        _layoutView.verticalAlignment = BBLayoutVerticalAlignmentAverage;
        
        UILabel *titleLabel = [ViewFactory lableWithTitle:@"BBLayout Demo"];
        titleLabel.backgroundColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:36];
        [titleLabel sizeToFit];
        [_layoutView addView:titleLabel];
        
        UIButton *btn1 = [ViewFactory bigBtnWithTitle:@"单行布局" target:self action:@selector(onClickBtn:) tag:lineIndex];
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"两端对齐布局" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"Label自适应高度布局" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"多行布局" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"一个cell" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"多个cell" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
        
        btn1 = [ViewFactory bigBtnWithTitle:@"带动画的布局" target:self action:@selector(onClickBtn:) tag:lineIndex];
        btn1.tag = lineIndex;
        [_layoutView addView:btn1 leading:0 lineNumber:lineIndex++];
    }
    return _layoutView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.layoutView];
    
    //debug
    [self.layoutView showBorder];
}

- (void)onClickBtn:(UIButton *)btn {
    UIViewController *vc = nil;
    if (btn.tag == 1) {
        vc = [[Single1LineViewController alloc] init];
    } else if (btn.tag == 2) {
        vc = [[Demo2ViewController alloc] init];
    } else if (btn.tag == 3) {
        vc = [[FitWidthViewController alloc] init];
    } else if (btn.tag == 4) {
        vc = [[MultiLineViewController alloc] init];
    } else if (btn.tag == 5) {
        vc = [[CellDemoViewController alloc] init];
    } else if (btn.tag == 6) {
        vc = [[CellTableViewController alloc] init];
    } else if (btn.tag == 7) {
        vc = [[AnimationViewController alloc] init];
    }
    vc.title = btn.titleLabel.text;
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
