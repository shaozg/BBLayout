//
//  BBLayoutView.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/1.
//  Copyright © 2020 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "BBLayoutView.h"

@interface BBLayoutLineModel ()

@property (nonatomic, assign) CGFloat bb_centerX;
@property (nonatomic, assign) CGFloat bb_centerY;

//将所有的view 调用 addSubview:
- (void)addToView:(UIView *)superView;

// 是否包含这个view
- (BOOL)containsView:(UIView *)theView;

- (void)layoutWithMaxWidth:(CGFloat)maxWidth hAlignment:(BBLayoutHorizontalAlignment)hAlignment;

// 该行最高的子view
- (CGFloat)maxHeight;

@end

@interface BBLayoutView ()

//将要布局的子view
@property (nonatomic, strong) NSMutableArray <BBLayoutLineModel *> *lineVMs;

@end

@implementation BBLayoutView
- (instancetype)init {
    if (self = [super init]) {
        self.horizontalAlignment = BBLayoutHorizontalAlignmentLeft;
        self.verticalAlignment = BBLayoutVerticalAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalAlignment = BBLayoutHorizontalAlignmentLeft;
        self.verticalAlignment = BBLayoutVerticalAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)layoutWithFrame:(CGRect)frame {
    return [BBLayoutView layoutWithFrame:frame horizontalAlignment:BBLayoutHorizontalAlignmentLeft];
}
+ (instancetype)layoutWithFrame:(CGRect)frame horizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment {
    return [BBLayoutView layoutWithFrame:frame horizontalAlignment:hAlignment verticalAlignment:BBLayoutVerticalAlignmentCenter];
}
+ (instancetype)layoutWithFrame:(CGRect)frame horizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment verticalAlignment:(BBLayoutVerticalAlignment)vAlignment {
    BBLayoutView *layout = [[BBLayoutView alloc] initWithFrame:frame];
    layout.horizontalAlignment = hAlignment;
    layout.verticalAlignment = vAlignment;
    return layout;
}

#pragma mark - Getter & Setter
- (NSMutableArray <BBLayoutLineModel *> *)lineVMs {
    if (_lineVMs == nil) {
        _lineVMs = [NSMutableArray arrayWithCapacity:1];
    }
    return _lineVMs;
}

#pragma mark - Private
- (BBLayoutLineModel *)lineVMWithView:(UIView *)view {
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        if ([lineVM containsView:view]) {
            return lineVM;
        }
    }
    return nil;
}

//需要占用的高度
- (CGFloat)totalNeedHeight {
    CGFloat height = 0;
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        height += lineVM.lineSpace + [lineVM maxHeight];
    }
    return height;
}

//需要占用的实际高度，忽略lineSpace
- (CGFloat)totalHeightIgnoreLineSpace {
    CGFloat height = 0;
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        height += [lineVM maxHeight];
    }
    return height;
}

- (CGFloat)bb_width {
    return self.frame.size.width;
}

- (CGFloat)bb_height {
    return self.frame.size.height;
}

#pragma mark - Private Layout Mehtods
- (CGFloat)calc_lineCenterYWithLineVM:(BBLayoutLineModel *)lineVM preLineBottom:(CGFloat)lineBottom {
    if (_verticalAlignment == BBLayoutVerticalAlignmentEqualSpace) {
        if (self.lineVMs.count > 1) {
            if ([self.lineVMs firstObject] == lineVM) {
                lineBottom = [lineVM maxHeight] / 2.f;
            } else {
                CGFloat space = (self.bb_height - [self totalHeightIgnoreLineSpace]) / (CGFloat)(self.lineVMs.count - 1);
                lineBottom += space + [lineVM maxHeight] / 2.f;
            }
        } else {
            lineBottom = self.bb_height / 2;
        }
    } else if (_verticalAlignment == BBLayoutVerticalAlignmentAverage) {
        CGFloat space = (self.bb_height - [self totalHeightIgnoreLineSpace]) / (CGFloat)(self.lineVMs.count + 1);
        if ([self.lineVMs firstObject] == lineVM) {
            lineBottom += [lineVM maxHeight] / 2.f;
        } else {
            lineBottom += space + [lineVM maxHeight] / 2;
        }
    }
    else {
        lineBottom += lineVM.lineSpace + [lineVM maxHeight] / 2.f;
    }
    return lineBottom;
}

- (CGFloat)p_getYPad {
    if (_verticalAlignment == BBLayoutVerticalAlignmentTop) {
        return 0.0f;
    } else if (_verticalAlignment == BBLayoutVerticalAlignmentCenter) {
        CGFloat yPad = (self.bb_height - [self totalNeedHeight]) / 2.0f;
        return yPad;
    } else if (_verticalAlignment == BBLayoutVerticalAlignmentEqualSpace) {
        CGFloat yPad = self.lineVMs.count > 1 ? 0 : (self.bb_height / 2.f);
        return yPad;
    } else if (_verticalAlignment == BBLayoutVerticalAlignmentAverage) {
        CGFloat yPad = (self.bb_height - [self totalHeightIgnoreLineSpace]) / (CGFloat)(self.lineVMs.count + 1);
        return yPad;
    }
    else {
        CGFloat yPad = (self.bb_height - [self totalNeedHeight]);
        return yPad;
    }
}

#pragma mark - Public
- (void)addView:(UIView *)view {
    [self addView:view leading:0];
}

- (void)addView:(UIView *)view leading:(CGFloat)leadingSpace {
    [self addView:view leading:leadingSpace lineNumber:0];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber {
    [self addView:view leading:leading lineNumber:lineNumber fitWidth:NO];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber fitWidth:(BOOL)fitWidth {
    [self addView:view leading:leading lineNumber:lineNumber fitWidth:fitWidth fillWidth:NO];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber fillWidth:(BOOL)fillWidth {
    [self addView:view leading:leading lineNumber:lineNumber fitWidth:NO fillWidth:fillWidth];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber fitWidth:(BOOL)fitWidth fillWidth:(BOOL)fillWidth {
    if (fitWidth && fillWidth) {
        NSAssert(0, @"Both fitWidth and fillWidth can not be YES");
        return;
    }
    
    BBLayoutLineModel *lineModel = nil;
    if (self.lineVMs.count == 0 ||
        (self.lineVMs.count == lineNumber && lineNumber > 0)) {
        lineModel = [BBLayoutLineModel lineModel];
        [self.lineVMs addObject:lineModel];
    } else if (self.lineVMs.count > lineNumber) {
        lineModel = [self.lineVMs objectAtIndex:lineNumber];
    } else {
        NSAssert(0, @"lineNumber bigger than self.lineVMs.count");
        return;
    }
    if (fitWidth) {
        [lineModel addView:view leading:leading fitWidth:fitWidth];
    } else if (fillWidth) {
        [lineModel addView:view leading:leading fillWidth:fillWidth];
    } else {
        [lineModel addView:view leading:leading];
    }
    
    [self addSubview:view];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index {
    [self addView:view leading:leading index:index lineNumber:0];
}
- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index lineNumber:(NSInteger)lineNumber {
    [self addView:view leading:leading index:index lineNumber:lineNumber fitWidth:NO fillWidth:NO];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index lineNumber:(NSInteger)lineNumber fitWidth:(BOOL)fitWidth fillWidth:(BOOL)fillWidth {
    if (fitWidth && fillWidth) {
        NSAssert(0, @"Both fitWidth and fillWidth can not be YES");
        return;
    }
    
    BBLayoutLineModel *lineModel = nil;
    if (self.lineVMs.count == 0 ||
        (self.lineVMs.count == lineNumber && lineNumber > 0)) {
        lineModel = [BBLayoutLineModel lineModel];
        [self.lineVMs addObject:lineModel];
    } else if (self.lineVMs.count > lineNumber) {
        lineModel = [self.lineVMs objectAtIndex:lineNumber];
    } else {
        NSAssert(0, @"lineNumber bigger than self.lineVMs.count");
        return;
    }
    
    if (fillWidth) {
        [lineModel addView:view leading:leading fillWidth:fillWidth];
    } else {
        [lineModel addView:view leading:leading fitWidth:fitWidth];
    }
    
    if (index != 0) {
        [lineModel updateIndex:index forView:view];
    }
    
    [self addSubview:view];
}

- (void)insertView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber atIndex:(NSInteger)index {
    BBLayoutLineModel *lineModel = nil;
    if (self.lineVMs.count == 0 ||
        (self.lineVMs.count == lineNumber && lineNumber > 0)) {
        lineModel = [BBLayoutLineModel lineModel];
        [self.lineVMs addObject:lineModel];
    } else if (self.lineVMs.count > lineNumber) {
        lineModel = [self.lineVMs objectAtIndex:lineNumber];
    } else {
        NSAssert(0, @"lineNumber bigger than self.lineVMs.count");
        return;
    }
    
    [lineModel insertView:view leading:leading atIndex:index];
    
    [self addSubview:view];
}

- (void)removeView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        if ([lineVM containsView:view]) {
            [lineVM removeView:view];
            
            if (lineVM.count == 0) {
                [self.lineVMs removeObject:lineVM];
            }
            [self layout];
            break;
        }
    }
}

- (void)removeView:(UIView *)view lineIndex:(NSInteger)index {
    if (self.lineVMs.count <= index) {
        NSAssert(0, @"index beyonds self.lineVMs.count");
        return;
    }
    
    BBLayoutLineModel *lineVM = self.lineVMs[index];
    if ([lineVM containsView:view]) {
        [lineVM removeView:view];
        
        if (lineVM.count == 0) {
            [self.lineVMs removeObject:lineVM];
        }
        [self layout];
    }
}


- (void)addLineModel:(BBLayoutLineModel *)lineModel {
    [self.lineVMs addObject:lineModel];
    [lineModel addToView:self];
}

- (void)addLineWithSpace:(CGFloat)lineSpace {
    BBLayoutLineModel *lineModel = [BBLayoutLineModel lineModelWithSpace:lineSpace];
    [self.lineVMs addObject:lineModel];
}

- (void)removeLineModelAtIndex:(NSInteger)index {
    if (self.lineVMs.count <= index) {
        NSAssert(0, @"index beyonds self.lineVMs.count");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self.lineVMs objectAtIndex:index];
    [lineVM removeAllViews];
    
    [self.lineVMs removeObject:lineVM];
    [self layout];
}

- (void)removeLineModel:(BBLayoutLineModel *)lineModel {
    if (lineModel == nil) {
        return ;
    }

    if ([self.lineVMs containsObject:lineModel]) {
        [self.lineVMs removeObject:lineModel];
        [self layout];
    }
}

- (void)updateLeading:(CGFloat)leading forView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self lineVMWithView:view];
    if (lineVM) {
        [lineVM updateLeading:leading forView:view];
        [self layout];
    }
}

- (void)updateYPad:(CGFloat)yPad forView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self lineVMWithView:view];
    if (lineVM) {
        [lineVM updateYPad:yPad forView:view];
        [self layout];
    }
}

- (void)updateOtherLeading:(CGFloat)leading forView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self lineVMWithView:view];
    if (lineVM) {
        [lineVM updateOtherSideLeading:leading forView:view];
        [self layout];
    }
}

- (void)updateIndex:(int)index forView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self lineVMWithView:view];
    if (lineVM) {
        [lineVM updateIndex:index forView:view];
        [self layout];
    }
}


- (void)updateHorizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment {
    [self updateHorizontalAlignment:hAlignment lineNumber:0];
}
- (void)updateHorizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment lineNumber:(NSInteger)lineNumber {
    if (lineNumber < self.lineVMs.count) {
        BBLayoutLineModel * lineModel = [self.lineVMs objectAtIndex:lineNumber];
        lineModel.alignment = hAlignment;
        [self layout];
    }
}

- (void)updateLineSpace:(CGFloat)lineSpace {
    [self updateLineSpace:lineSpace lineIndex:0];
}
- (void)updateLineSpace:(CGFloat)lineSpace lineIndex:(NSInteger)lineIndex {
    if (self.lineVMs.count <= lineIndex) {
        NSAssert(0, @"index beyonds self.lineVMs.count");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self.lineVMs objectAtIndex:lineIndex];
    lineVM.lineSpace = lineSpace;
}

- (void)layout {
    //先处理X以及Width，因为UILabel自身数据变化可能会修改高度
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        [lineVM layoutWithMaxWidth:self.bb_width hAlignment:self.horizontalAlignment];
    }
    
    //再处理Y以及Height
    CGFloat yPad = [self p_getYPad];
    CGFloat lineCenterY = yPad;
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        lineCenterY = [self calc_lineCenterYWithLineVM:lineVM preLineBottom:lineCenterY];
        lineVM.bb_centerY = lineCenterY;
        
        lineCenterY += [lineVM maxHeight] / 2.f;
    }
}

- (void)layoutSubviews {
    [self layout];
}

- (NSUInteger)numberOfLines {
    return self.lineVMs.count;
}

- (void)showBorder {
    [self showBorderWithColor:[UIColor redColor]];
}
- (void)showBorderWithColor:(UIColor *)color {
#if DEBUG
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
#endif
}

@end
