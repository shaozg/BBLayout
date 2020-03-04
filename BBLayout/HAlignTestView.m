//
//  HAlignTestView.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "HAlignTestView.h"
#import "ViewFactory.h"

@interface HAlignTestView ()

@property (nonatomic, strong) BBLayoutView *layoutView;

@property (nonatomic, assign) BOOL vAlignment;

@end

@implementation HAlignTestView

+ (instancetype)hAlignmentViewWithFrame:(CGRect)frame {
    HAlignTestView *view = [[HAlignTestView alloc] initWithFrame:frame];
    [view setup];
    return view;
}

+ (instancetype)vAlignmentViewWithFrame:(CGRect)frame {
    HAlignTestView *view = [[HAlignTestView alloc] initWithFrame:frame];
    view.vAlignment = YES;
    [view setup];
    return view;
}

- (void)setup {
    [self addSubview:self.layoutView];
}

- (BBLayoutView *)layoutView {
    if (nil == _layoutView) {
        _layoutView = [BBLayoutView layoutWithFrame:self.bounds horizontalAlignment:BBLayoutHorizontalAlignmentCenter];
        
        [_layoutView addView:[ViewFactory lableWithTitle:self.vAlignment?@"V布局:":@"H布局:"]];
        [_layoutView addView:[self alignBtnWithTitle:self.vAlignment ? @"居中" : @"左对齐" tag:0] leading:5];
        [_layoutView addView:[self alignBtnWithTitle:self.vAlignment ? @"顶部对齐" : @"中间对齐" tag:1] leading:5];
        [_layoutView addView:[self alignBtnWithTitle:self.vAlignment ? @"底部对齐" : @"右对齐" tag:2] leading:5];
        [_layoutView addView:[self alignBtnWithTitle:self.vAlignment ? @"等行距" : @"等间距" tag:3] leading:5];
        [_layoutView addView:[self alignBtnWithTitle:@"等分" tag:4] leading:5];
        
        [_layoutView showBorder];
    }
    return _layoutView;
}

- (UIButton *)alignBtnWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = tag;
    [btn1 setTitle:title forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    btn1.frame = CGRectMake(0, 0, 60, 40);
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blackColor]];
    [btn1 addTarget:self action:@selector(onClickAlignBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn1;
}

- (void)onClickAlignBtn:(UIButton *)btn {
    if (btn.tag <= 4) {
        if (self.vAlignment) {
            if (_demoLayoutView.verticalAlignment != btn.tag) {
                _demoLayoutView.verticalAlignment = btn.tag;
                [_demoLayoutView layout];
            }
        } else {
            if (_demoLayoutView.horizontalAlignment != btn.tag) {
                _demoLayoutView.horizontalAlignment = btn.tag;
                [_demoLayoutView layout];
            }
        }
    }
}
@end
