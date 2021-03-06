//
//  BBLayoutLineModel.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/14.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "BBLayoutLineModel.h"

@interface BBLayoutItemModel : NSObject

//与前面的view或者左边的距离
@property (nonatomic, assign) CGFloat leading;

//要布局的view
@property (nonatomic, strong) UIView *view;

//自动适应大小
@property (nonatomic, assign) BOOL fitWidth;
//填充剩余的宽度
@property (nonatomic, assign) BOOL fillWidth;
//外面设置的宽度block
@property (nonatomic, copy) CGFloat (^widthBlock)(void);
//外面设置的高度block
@property (nonatomic, copy) CGFloat (^heightBlock)(void);

//只有当fitWidth = YES并且布局发生变化时候才用这个值
@property (nonatomic, assign) CGFloat orignalWidth;

@property (nonatomic, assign) CGFloat yPad;

//如果使用两端对齐，BBLayoutHorizontalAlignmentJustified 这个属性的时候，用到这个值
//如果这个值是0,1,2,3,...代表是从左到右算
//如果这个值是-1,-2,-3,-4,...代表是从右边往左算，那么leading标识右边的间距
@property (nonatomic, assign) int index;

//这个属性只有使用两端对齐 BBLayoutHorizontalAlignmentJustified 这个属性的时候，并且fillWidth为YES的时候，才有用
//标志这个item与另外一端的leading
@property (nonatomic, assign) CGFloat otherSideLeading;

@end

@implementation BBLayoutItemModel

+ (instancetype)defaultItemWithView:(UIView *)target {
    BBLayoutItemModel *itemModel = [[BBLayoutItemModel alloc] init];
    itemModel.view = target;
    return itemModel;
}

- (void)revertWidth {
    if (self.fillWidth && self.orignalWidth > 0) {
        CGRect frame = self.view.frame;
        frame.size.width = self.orignalWidth;
        [self.view setFrame:frame];
    }
}

- (CGFloat)left {
    CGRect frame = self.view.frame;
    return frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.view.frame;
    frame.origin.x = left;
    [self.view setFrame:frame];
}

- (CGFloat)right {
    CGRect frame = self.view.frame;
    return CGRectGetMaxX(frame);
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.view.frame;
    frame.origin.x = right - frame.size.width;
    [self.view setFrame:frame];
}

- (CGFloat)centerX {
    CGRect frame = self.view.frame;
    return frame.origin.x + frame.size.width / 2.f;
}
- (void)setCenterX:(CGFloat)centerX {
    CGFloat centerY = self.view.frame.origin.y + self.view.frame.size.height / 2.f;
    [self.view setCenter:CGPointMake(centerX, centerY)];
}
- (CGFloat)centerY {
    CGRect frame = self.view.frame;
    return frame.origin.y + frame.size.height / 2.f;
}
- (void)setCenterY:(CGFloat)centerY {
    CGFloat centerX = self.view.frame.origin.x + self.view.frame.size.width / 2.f;
    
    CGFloat yPad = isnan(self.yPad) ? 0 : self.yPad;
    [self.view setCenter:CGPointMake(centerX, centerY + yPad)];
}

- (CGFloat)width {
    CGRect frame = self.view.frame;
    return frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.view.frame;
    frame.size.width = width;
    [self.view setFrame:frame];
}

- (CGFloat)height {
    CGRect frame = self.view.frame;
    return frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.view.frame;
    frame.size.height = height;
    [self.view setFrame:frame];
}

- (void)calcLabelFitSize {
    if (self.fitWidth && [self.view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)(self.view);
        [label sizeToFit];
    }
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BBLayoutLineModel ()

@property (nonatomic, strong) NSMutableArray <BBLayoutItemModel *> *vms;

//行高，如果不设置，默认是当前行的最高的一个view 的高度
@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, strong) NSMutableDictionary *layoutFuns;

@end

@implementation BBLayoutLineModel
+ (instancetype)lineModel {
    return [BBLayoutLineModel lineModelWithSpace:0];
}

+ (instancetype)lineModelWithAlignment:(BBLayoutHorizontalAlignment)alignment {
    BBLayoutLineModel *line = [[BBLayoutLineModel alloc] init];
    line.lineSpace = 0;
    line.alignment = alignment;
    return line;
}

+ (instancetype)lineModelWithSpace:(CGFloat)space {
    BBLayoutLineModel *line = [[BBLayoutLineModel alloc] init];
    line.lineSpace = space;
    line.alignment = BBLayoutHorizontalAlignmentLeft;
    return line;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineSpace = 0;
        _layoutFuns = [NSMutableDictionary dictionary];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignLeft:)) forKey:@(BBLayoutHorizontalAlignmentLeft)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignRight:)) forKey:@(BBLayoutHorizontalAlignmentRight)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignCenter:)) forKey:@(BBLayoutHorizontalAlignmentCenter)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignAverage:)) forKey:@(BBLayoutHorizontalAlignmentAverage)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignEqualSpace:)) forKey:@(BBLayoutHorizontalAlignmentEqualSpace)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignJustified:)) forKey:@(BBLayoutHorizontalAlignmentJustified)];
        [_layoutFuns setObject:NSStringFromSelector(@selector(layout_alignEqualSpaceCenter:)) forKey:@(BBLayoutHorizontalAlignmentCenterEqualSpace)];
    }
    return self;
}

- (void)addView:(UIView *)theView {
    [self addView:theView leading:0];
}

- (void)addView:(UIView *)theView leading:(CGFloat)leading {
    [self addView:theView leading:leading fitWidth:NO];
}

- (void)addView:(UIView *)theView leading:(CGFloat)leading fitWidth:(BOOL)fitWidth {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.fitWidth = fitWidth;
    [self addItemModel:itemModel];
}
- (void)addView:(UIView *)theView leading:(CGFloat)leading fillWidth:(BOOL)fillWidth {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.fillWidth = fillWidth;
    itemModel.orignalWidth = fillWidth ? theView.frame.size.width : 0;
    [self addItemModel:itemModel];
}

// 只有 alignment == BBLayoutHorizontalAlignmentJustified 的时候，才需要调用这个方法。否则忽略index
- (void)addView:(UIView *)theView leading:(CGFloat)leading index:(int)index {
    [self addView:theView leading:leading index:index fillWidth:NO];
}

- (BBLayoutItemModel *)addView:(UIView *)theView leading:(CGFloat)leading index:(int)index fillWidth:(BOOL)fillWidth {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.index = index;
    itemModel.fillWidth = fillWidth;
    if (index >= 0) {
        [self insertItemModel:itemModel atIndex:index];
    } else {
        [self addItemModel:itemModel];
    }
    return itemModel;
}

- (void)insertView:(UIView *)theView leading:(CGFloat)leading atIndex:(NSInteger)index {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    [self insertItemModel:itemModel atIndex:index];
}

- (void)removeView:(UIView *)theView {
    for (BBLayoutItemModel *itemModel in self.vms) {
        if (itemModel.view == theView) {
            [self.vms removeObject:itemModel];
            [theView removeFromSuperview];
            break;
        }
    }
    
    //这种情况需要重新排列index的值
    [self adjustIndex];
}

- (void)removeAllViews {
    for (BBLayoutItemModel *itemModel in self.vms) {
        [itemModel.view removeFromSuperview];
    }
    
    [self.vms removeAllObjects];
}

- (void)insertItemModel:(BBLayoutItemModel *)itemModel atIndex:(NSInteger)index {
    if ([self containsView:itemModel.view]) {
        [self removeView:itemModel.view];
    }
    
    if (index < self.count) {
        [self.vms insertObject:itemModel atIndex:index];
    } else {
        [self.vms addObject:itemModel];
    }
}

- (void)addItemModel:(BBLayoutItemModel *)itemModel {
    if ([self containsView:itemModel.view]) {
        [self removeView:itemModel.view];
    }
    
    [self.vms addObject:itemModel];
}

- (void)removeItemVM:(BBLayoutItemModel *)vm {
    for (BBLayoutItemModel *tmp in self.vms) {
        if (tmp == vm) {
            [self.vms removeObject:vm];
            [vm.view removeFromSuperview];
            break;
        }
    }
    
    //重新排列index的值
    [self adjustIndex];
}

- (BBLayoutItemModel *)itemVMWithView:(UIView *)view {
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.view == view) {
            return vm;
        }
    }
    return nil;
}

- (void)adjustIndex {
    //这种情况需要重新排列index的值
    if (self.alignment == BBLayoutHorizontalAlignmentJustified) {
        for (NSInteger idx = 0; idx < self.vms.count; idx ++) {
            BBLayoutItemModel *itemModel = [self.vms objectAtIndex:idx];
            if (itemModel.index >= 0) {
                itemModel.index = (int)idx;
            } else {
                itemModel.index = (int)(idx - self.vms.count);
            }
        }
    }
}

- (NSUInteger)count {
    NSInteger count = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        count += vm.view.hidden ? 0 : 1;
    }
    return count;
}

- (void)updateLeading:(CGFloat)leading forView:(UIView *)view {
    BBLayoutItemModel *itemVM = [self itemVMWithView:view];
    itemVM.leading = leading;
}

- (void)updateYPad:(CGFloat)yPad forView:(UIView *)view {
    BBLayoutItemModel *itemVM = [self itemVMWithView:view];
    itemVM.yPad = yPad;
}

- (void)updateOtherSideLeading:(CGFloat)leading forView:(UIView *)view {
    BBLayoutItemModel *itemVM = [self itemVMWithView:view];
    itemVM.otherSideLeading = leading;
}

- (void)updateIndex:(int)index forView:(UIView *)view {
    BBLayoutItemModel *itemVM = [self itemVMWithView:view];
    itemVM.index = index;
    
    [self adjustIndex];
}

- (void)updateLineSpace:(CGFloat)space {
    self.lineSpace = space;
}

- (void)updateWidthBlock:(CGFloat (^)(void))widthBlock forView:(UIView *)view {
    BBLayoutItemModel *itemModel = [self itemVMWithView:view];
    itemModel.widthBlock = widthBlock;
}

- (void)updateHeightBlock:(CGFloat (^)(void))heightBlock forView:(UIView *)view {
    BBLayoutItemModel *itemModel = [self itemVMWithView:view];
    itemModel.heightBlock = heightBlock;
}

#pragma mark - Getter & Setter
- (NSMutableArray<BBLayoutItemModel *> *)vms {
    if (nil == _vms) {
        _vms = [NSMutableArray array];
    }
    return _vms;
}

#pragma mark - Private - Helper
- (BBLayoutItemModel *)itemVMAtIndex:(NSInteger)index {
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.view.hidden) {
            continue;
        }
        if (index == 0) {
            return vm;
        }
        index--;
    }
    return nil;
}

//这行的总宽度
- (CGFloat)totalNeedWidth {
    CGFloat width = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        CGFloat leading = vm.leading;
        if (self.alignment == BBLayoutHorizontalAlignmentCenterEqualSpace) {
            leading = 0;
        }
        
        if (vm.widthBlock) {
            width += leading + vm.widthBlock();
        } else {
            width += leading + vm.width;
        }
    }
    
    if (self.alignment == BBLayoutHorizontalAlignmentCenterEqualSpace) {
        width += self.itemSpace * MAX(0, (self.vms.count - 1));
    }
    return width;
}

- (CGFloat)totalWidthIgnoreLeading {
    CGFloat width = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        width += (vm.widthBlock != nil ? vm.widthBlock() : vm.width);
    }
    return width;
}

- (BOOL)haveFitWidthView {
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.fitWidth) {
            return vm.fitWidth;
        }
    }
    return NO;
}

- (BOOL)haveFillWidthView {
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.fillWidth && !vm.view.hidden) {
            return vm.fillWidth;
        }
    }
    return NO;
}

#pragma mark - Private - 布局方法
- (void)layout_alignLeft:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    UIView *leading_view = nil;
    for (NSInteger li = 0; li < [lineVM count]; li ++) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
        [itemVM calcLabelFitSize];
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        if (nil == leading_view) {
            itemVM.left = itemVM.leading;
        } else {
            CGFloat right = CGRectGetMaxX(leading_view.frame);
            itemVM.left = right + itemVM.leading;
        }
        leading_view = itemVM.view;
    }
    
    //如果已经越界了，就要检查是否有可压缩的view,如果有，倒着布局后面的，然后剩余的分给压缩的view
    //如果没有可压缩的view，那么继续布局完后面的
    CGFloat right = CGRectGetMaxX(leading_view.frame);
    if (right > bb_width) {
        if ([lineVM haveFitWidthView]) {
            BBLayoutItemModel *tail_vm = nil;
            for (NSInteger idx = lineVM.count-1; idx >= 0; idx --) {
                BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
                if (itemVM.fitWidth) {
                    if (tail_vm != nil) {
                        if (idx == 0) {
                            itemVM.left = itemVM.leading;
                            itemVM.width = tail_vm.left - tail_vm.leading - itemVM.leading;
                        } else {
                            BBLayoutItemModel *head_vm = [lineVM itemVMAtIndex:idx-1];
                            itemVM.left = head_vm.right + itemVM.leading;
                            itemVM.width = tail_vm.left - tail_vm.leading - (head_vm.right + itemVM.leading);
                        }
                    } else {
                        if (idx == 0) {
                            itemVM.left = itemVM.leading;
                            itemVM.width = bb_width - itemVM.leading;
                        } else {
                            BBLayoutItemModel *head_vm = [lineVM itemVMAtIndex:idx-1];
                            itemVM.left = head_vm.right + itemVM.leading;
                            itemVM.width = bb_width - head_vm.right - itemVM.leading;
                        }
                    }
                } else {//正常布局
                    if (nil == tail_vm) {
                        itemVM.right = bb_width;
                    } else {
                        itemVM.right = tail_vm.left - tail_vm.leading;
                    }
                }
                tail_vm = itemVM;
            }
        }
    }
    
    // 如果有自动填充宽度的view，自动填充
    if ([lineVM haveFillWidthView]) {
        BBLayoutItemModel *tail_vm = nil;
        for (NSInteger idx = lineVM.count-1; idx >= 0; idx --) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
            if (itemVM.fillWidth) {
                if (tail_vm != nil) {
                    if (idx == 0) {
                        itemVM.left = itemVM.leading;
                        itemVM.width = tail_vm.left - tail_vm.leading - itemVM.leading;
                    } else {
                        BBLayoutItemModel *head_vm = [lineVM itemVMAtIndex:idx-1];
                        itemVM.left = head_vm.right + itemVM.leading;
                        itemVM.width = tail_vm.left - tail_vm.leading - head_vm.right - itemVM.leading;
                    }
                } else {
                    if (idx == 0) {
                        itemVM.left = itemVM.leading;
                        itemVM.width = bb_width - itemVM.leading;
                    } else {
                        BBLayoutItemModel *head_vm = [lineVM itemVMAtIndex:idx-1];
                        itemVM.left = head_vm.right + itemVM.leading;
                        itemVM.width = bb_width - itemVM.left;
                    }
                }
            } else {
                if (tail_vm == nil) {
                    itemVM.right = bb_width;
                } else {
                    itemVM.right = tail_vm.left - tail_vm.leading;
                }
            }
            
            tail_vm = itemVM;
        }
    }
}

- (void)layout_alignRight:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    BBLayoutItemModel *tail_vm = nil;
    for (NSInteger i = lineVM.count - 1; i >= 0; i --) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:i];
        [itemVM calcLabelFitSize];
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        if (nil != tail_vm) {
            itemVM.right = tail_vm.left - tail_vm.leading;
        } else {
            itemVM.right = bb_width - itemVM.otherSideLeading;
        }
        tail_vm = itemVM;
    }
    
    //如果已经越界了，就要检查是否有可压缩的view,如果有，倒着布局后面的，然后剩余的分给压缩的view
    //如果没有可压缩的view，那么继续布局完后面的
    if (tail_vm.left < tail_vm.leading) {
        if ([lineVM haveFitWidthView]) {
            BBLayoutItemModel *head_vm = nil;
            for (NSInteger idx = 0; idx < lineVM.count; idx ++) {
                BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
                if (itemVM.fitWidth) {
                    if (head_vm != nil) {
                        if ([lineVM.vms lastObject] == itemVM) {
                            itemVM.left = head_vm.right + itemVM.leading;
                            itemVM.width = bb_width - head_vm.right - itemVM.leading;
                        } else {
                            BBLayoutItemModel *tail_vm = [lineVM.vms objectAtIndex:idx+1];
                            itemVM.left = head_vm.right + itemVM.leading;
                            itemVM.width = tail_vm.left - tail_vm.leading - (head_vm.right + itemVM.leading);
                        }
                    } else {
                        if ([lineVM.vms lastObject] == itemVM) {
                            itemVM.left = bb_width - itemVM.leading;
                        } else {
                            BBLayoutItemModel *tail_vm = [lineVM.vms objectAtIndex:idx+1];
                            itemVM.left = itemVM.leading;
                            itemVM.width = tail_vm.left - tail_vm.leading - itemVM.leading;
                        }
                    }
                } else {
                    if (nil != head_vm) {
                        itemVM.left = head_vm.right + itemVM.leading;
                    } else {
                        itemVM.left = itemVM.leading;
                    }
                }
                head_vm = itemVM;
            }
        }
    }
    
    // 如果有自动填充宽度的view，自动填充
    if ([lineVM haveFillWidthView]) {
        BBLayoutItemModel *head_vm = nil;
        for (NSInteger idx = 0; idx < lineVM.count; idx ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
            if (itemVM.fillWidth) {
                if (head_vm == nil) {
                    itemVM.left = itemVM.leading;
                    if ([lineVM.vms lastObject] == itemVM) {
                        itemVM.width = bb_width - itemVM.left;
                    } else {
                        BBLayoutItemModel *tail_vm = [lineVM itemVMAtIndex:idx+1];
                        itemVM.width = tail_vm.left - tail_vm.leading - itemVM.left;
                    }
                } else {
                    itemVM.left = head_vm.right + itemVM.leading;
                    if ([lineVM.vms lastObject] == itemVM) {
                        itemVM.width = bb_width - itemVM.left;
                    } else {
                        BBLayoutItemModel *tail_vm = [lineVM itemVMAtIndex:idx+1];
                        itemVM.width = tail_vm.left - tail_vm.leading - itemVM.left;
                    }
                }
            } else {//正常布局
                if (nil != head_vm) {
                    itemVM.left = head_vm.right + itemVM.leading;
                } else {
                    itemVM.left = itemVM.leading;
                }
            }
            
            head_vm = itemVM;
        }
    }
}

- (void)layout_alignCenter:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    CGFloat xPad = 0;
    CGFloat totalWidth = [lineVM totalNeedWidth];
    if (totalWidth < bb_width) {
        xPad = (bb_width - totalWidth) / 2.f;
    } else {
        for (NSInteger li = 0; li < [lineVM count]; li ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
            [itemVM revertWidth];
            if (itemVM.fitWidth) {
                itemVM.width -= (totalWidth - bb_width);
                break;
            }
        }
    }
    
    //按宽度正好布局即可
    BBLayoutItemModel *head_vm = nil;
    for (NSInteger i = 0; i < lineVM.count; i ++) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:i];
        if (nil != head_vm) {
            itemVM.left = head_vm.right + itemVM.leading;
        } else {
            itemVM.left = itemVM.leading + xPad;
        }
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        head_vm = itemVM;
    }
}

- (void)layout_alignEqualSpace:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    CGFloat xPad = 0;
    CGFloat totalWidth = [lineVM totalNeedWidth];
    if (totalWidth < bb_width) {
        xPad = (bb_width - totalWidth) / 2.f;
    } else {
        for (NSInteger li = 0; li < [lineVM count]; li ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
            [itemVM revertWidth];
            if (itemVM.fitWidth) {
                itemVM.width -= (totalWidth - bb_width);
                break;
            }
        }
    }
    
    //等间距
    if (lineVM.count > 1) {
        CGFloat totalWidth = [lineVM totalWidthIgnoreLeading];
        CGFloat space = (bb_width - totalWidth) / (CGFloat)(lineVM.count - 1);
        BBLayoutItemModel *head_vm = nil;
        for (NSInteger i = 0; i < lineVM.count; i ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:i];
            
            if (nil != head_vm) {
                itemVM.left = head_vm.right + space;
            } else {
                itemVM.left = 0;
            }
            if (itemVM.widthBlock) {
                itemVM.width = itemVM.widthBlock();
            }
            
            head_vm = itemVM;
        }
    } else {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:0];
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        itemVM.centerX = bb_width / 2.0;
    }
}

- (void)layout_alignAverage:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    CGFloat totalWidth = [lineVM totalWidthIgnoreLeading];
    if (totalWidth < bb_width) {
    } else {
        for (NSInteger li = 0; li < [lineVM count]; li ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
            [itemVM revertWidth];
            //修正自实行的宽度
            if (itemVM.fitWidth) {
                itemVM.width -= (totalWidth - bb_width);
                break;
            }
        }
    }
    
    //等分
    CGFloat space = (bb_width - totalWidth) / (CGFloat)(lineVM.count + 1);
    BBLayoutItemModel *head_vm = nil;
    for (NSInteger i = 0; i < lineVM.count; i ++) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:i];
        
        if (nil != head_vm) {
            itemVM.left = head_vm.right + space;
        } else {
            itemVM.left = space;
        }
        
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        head_vm = itemVM;
    }
}

- (void)layout_alignJustified:(CGFloat)bb_width {
    //按索引排序
    [self.vms sortUsingComparator:^NSComparisonResult(BBLayoutItemModel  * _Nonnull obj1, BBLayoutItemModel * _Nonnull obj2) {
        if (obj1.index >= 0 && obj2.index >= 0) {
            return obj1.index < obj2.index ? NSOrderedAscending : NSOrderedDescending;
        } else if (obj1.index < 0 && obj2.index < 0) {
            return obj1.index < obj2.index ? NSOrderedAscending : NSOrderedDescending;
        } else {
            return obj1.index > obj2.index ? NSOrderedAscending : NSOrderedDescending;
        }
    }];
    
    BBLayoutItemModel *fillItemModel = nil;
    //从左向右
    BBLayoutItemModel *pre_vm = nil;
    for (BBLayoutItemModel *itemModel in self.vms) {
        if (itemModel.index < 0) {
            break;
        }
        
        if (pre_vm == nil) {
            itemModel.left = itemModel.leading;
        } else {
            itemModel.left = pre_vm.right + itemModel.leading;
        }
        pre_vm = itemModel;
        
        if (itemModel.widthBlock) {
            itemModel.width = itemModel.widthBlock();
        }
        
        if (itemModel.fillWidth)
            fillItemModel = itemModel;
    }
    
    //从右向左
    pre_vm = nil;
    for (NSInteger idx = self.vms.count-1; idx >= 0; idx --) {
        BBLayoutItemModel *itemModel = [self.vms objectAtIndex:idx];
        if (itemModel.index >= 0) {
            break;
        }
        
        if (pre_vm == nil) {
            itemModel.right = bb_width - itemModel.leading;
        } else {
            itemModel.right = pre_vm.left - itemModel.leading;
        }
        pre_vm = itemModel;
        
        if (itemModel.widthBlock) {
            itemModel.width = itemModel.widthBlock();
        }
        
        if (itemModel.fillWidth)
            fillItemModel = itemModel;
    }
    
    
    //如果有fill的model，调整大小
    if (fillItemModel) {
        CGFloat otherLeading = fillItemModel.otherSideLeading;
        if (fillItemModel.index < 0) {
            if ([self.vms firstObject] == fillItemModel) {
                fillItemModel.width = fillItemModel.right - otherLeading;
                fillItemModel.left = otherLeading;
            } else {
                NSInteger idx = [self.vms indexOfObject:fillItemModel];
                BBLayoutItemModel *leftModel = self.vms[idx-1];
                fillItemModel.width = fillItemModel.right - leftModel.right - otherLeading;
                fillItemModel.left = leftModel.right + otherLeading;
            }
        } else {
            if ([self.vms lastObject] == fillItemModel) {
                fillItemModel.width = bb_width - fillItemModel.left;
            } else {
                NSInteger idx = [self.vms indexOfObject:fillItemModel];
                BBLayoutItemModel *rightModel = self.vms[idx+1];
                fillItemModel.width = rightModel.left - fillItemModel.left - otherLeading;
                fillItemModel.right = rightModel.left - otherLeading;
            }
        }
    }
}

- (void)layout_alignEqualSpaceCenter:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    CGFloat xPad = 0;
    CGFloat totalWidth = [lineVM totalNeedWidth];
    if (totalWidth < bb_width) {
        xPad = (bb_width - totalWidth) / 2.f;
    } else {
        for (NSInteger li = 0; li < [lineVM count]; li ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
            [itemVM revertWidth];
            if (itemVM.fitWidth) {
                itemVM.width -= (totalWidth - bb_width);
                break;
            }
        }
    }
    
    //按宽度正好布局即可
    BBLayoutItemModel *head_vm = nil;
    for (NSInteger i = 0; i < lineVM.count; i ++) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:i];
        CGFloat leading = itemVM.leading;
        if (lineVM.alignment == BBLayoutHorizontalAlignmentCenterEqualSpace) {
            leading = lineVM.itemSpace;
        }
        
        if (nil != head_vm) {
            itemVM.left = head_vm.right + leading;
        } else {
            itemVM.left = xPad;
        }
        if (itemVM.widthBlock) {
            itemVM.width = itemVM.widthBlock();
        }
        
        head_vm = itemVM;
    }
}

#pragma mark - Private 计算方法
- (CGFloat)boundingHeightWithLabel:(UILabel *)label lineSpace:(CGFloat)lineSpace {
    CGFloat height = [self boundingSizeWithWidth:label.frame.size.width withTextFont:label.font withLineSpacing:lineSpace text:label.text].height;
    
    if (label.numberOfLines > 0) {
        height = MIN(height, (label.font.lineHeight * label.numberOfLines + (label.numberOfLines - 1) * lineSpace));
    }
    
    return height;
}

/**
 *  根据文字内容动态计算UILabel宽高
 *  @param maxWidth label宽度
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
// #此方法摘抄自 https://www.jianshu.com/p/ec58544a1449
- (CGSize)boundingSizeWithWidth:(CGFloat)maxWidth
                  withTextFont:(UIFont *)font
               withLineSpacing:(CGFloat)lineSpacing
                          text:(NSString *)text{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    
    //计算文字尺寸
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return size;
}

#pragma mark - Getter & Setter
- (CGFloat)bb_centerX {
    BBLayoutItemModel *itemModel = [self.vms firstObject];
    if (itemModel != nil)
        return [itemModel centerX];
    
    return 0.0f;
}

- (void)setBb_centerX:(CGFloat)bb_centerX {
    for (BBLayoutItemModel *itemModel in self.vms) {
        [itemModel setCenterX:bb_centerX];
    }
}

- (CGFloat)bb_centerY {
    BBLayoutItemModel *itemModel = [self.vms firstObject];
    if (itemModel != nil)
        return [itemModel centerY];
    
    return 0.0f;
}

- (void)setBb_centerY:(CGFloat)bb_centerY {
    for (BBLayoutItemModel *itemModel in self.vms) {
        [itemModel setCenterY:bb_centerY];
    }
}

#pragma mark - Extensions
- (void)addToView:(UIView *)superView {
    for (BBLayoutItemModel *itemModel in self.vms) {
        [superView addSubview:itemModel.view];
    }
}

- (BOOL)containsView:(UIView *)theView {
    for (BBLayoutItemModel *itemModel in self.vms) {
        if (itemModel.view == theView) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)maxHeight {
    CGFloat maxHeight = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        CGFloat h = vm.view.frame.size.height;
        if (vm.heightBlock) {
            h = vm.heightBlock();
        }
        
        maxHeight = MAX(maxHeight, h);
    }
    return maxHeight;
}

- (void)layoutWithMaxWidth:(CGFloat)bb_width hAlignment:(BBLayoutHorizontalAlignment)hAlignment {
    BBLayoutHorizontalAlignment align = self.alignment;
    
    NSString *selectStr = [_layoutFuns objectForKey:@(align)];
    if (selectStr.length > 0) {
        SEL sel = NSSelectorFromString(selectStr);
        IMP imp = [self methodForSelector:sel];
        void (*layout_fun)(id, SEL, CGFloat) = (void *)imp;
        layout_fun(self, sel, bb_width);
    }
    
    //处理的高度, 如果设置了高度block，就优先用这个
    for (BBLayoutItemModel *itemVM in self.vms) {
        if (itemVM.heightBlock) {
            itemVM.height = itemVM.heightBlock();
            continue;
        }
        
        if ([itemVM.view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)(itemVM.view);
            if (label.numberOfLines == 0 || label.numberOfLines > 1) {
                itemVM.height = [self boundingHeightWithLabel:label lineSpace:0];
                break;
            }
            
            if (label.frame.size.height <= 0.001) {
                itemVM.height = label.font.lineHeight;
            }
        }
    }
}

@end
