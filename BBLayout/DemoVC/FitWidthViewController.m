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

@end

@implementation FitWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Label自适应高度布局";
    
    [self.view addSubview:self.layoutView];
    CGSize s = [self.titleLabel sizeThatFits:CGSizeMake(self.layoutView.frame.size.width, CGFLOAT_MAX)];
    self.titleLabel.frame = CGRectMake(0, 0, s.width, s.height);
    
    [self.layoutView layout];
}

- (BBLayoutView *)layoutView {
    if (nil == _layoutView) {
        CGRect rc = CGRectMake(5, naviBarHeight(), SCREEN_WIDTH-2*5, 120);
        _layoutView = [BBLayoutView layoutWithFrame:rc];
        
        self.titleLabel = [ViewFactory lableWithTitle:@"asdojifawejfao0sidjfgoiaerua0w8efua0w-9efuajp9wdifuas0[9dpofiua0-sd9[pfija0wdf"];
        self.titleLabel.numberOfLines = 2;
        UILabel *label2 = [ViewFactory lableWithTitle:@"aoefu8w9uf不好不知道"];
        
        [_layoutView addView:self.titleLabel leading:5];
        [_layoutView addView:label2 leading:5 lineNumber:1];
        [_layoutView updateLineSpace:15 lineIndex:1];
        
        [_layoutView showBorder];
    }
    return _layoutView;
}
@end
