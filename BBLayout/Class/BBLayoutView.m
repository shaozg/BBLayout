//
//  BBLayoutView.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/1.
//  Copyright © 2020 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "BBLayoutView.h"

@interface BBLayoutItemModel : NSObject

//与前面的view或者左边的距离
@property (nonatomic, assign) CGFloat leading;

// 自动适应大小
@property (nonatomic, assign) BOOL fitSize;

@property (nonatomic, assign) BOOL fillWidth;

@property (nonatomic, strong) UIView *view;

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
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BBLayoutLineModel ()

@property (nonatomic, strong) NSMutableArray <BBLayoutItemModel *> *vms;

//行高，如果不设置，默认是当前行的最高的一个view 的高度
@property (nonatomic, assign) CGFloat lineHeight;

@end

@implementation BBLayoutLineModel
+ (instancetype)lineModel {
    return [BBLayoutLineModel lineModelWithSpace:0];
}

+ (instancetype)lineModelWithSpace:(CGFloat)space {
    BBLayoutLineModel *line = [[BBLayoutLineModel alloc] init];
    line.lineSpace = space;
    line.alignment = BBLayoutHorizontalAlignmentMax; //未初始化标记
    return line;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineSpace = 0;
    }
    return self;
}

- (void)addItemModelWithView:(UIView *)theView {
    [self addItemModelWithView:theView leading:0];
}

- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading {
    [self addItemModelWithView:theView leading:leading fitSize:NO];
}

- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading fitSize:(BOOL)fitSize {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.fitSize = fitSize;
    [self addItemModel:itemModel];
}
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading fillWidth:(BOOL)fillWidth {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.fillWidth = fillWidth;
    itemModel.orignalWidth = fillWidth ? theView.frame.size.width : 0;
    [self addItemModel:itemModel];
}

// 只有 alignment == BBLayoutHorizontalAlignmentJustified 的时候，才需要调用这个方法。否则忽略index
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading index:(int)index {
    [self addItemModelWithView:theView leading:leading index:index fillWidth:NO];
}

- (BBLayoutItemModel *)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading index:(int)index fillWidth:(BOOL)fillWidth {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    itemModel.index = index;
    itemModel.fillWidth = fillWidth;
    if (index >= 0) {
        [self.vms insertObject:itemModel atIndex:index];
    } else {
        [self.vms addObject:itemModel];
    }
    return itemModel;
}

- (BBLayoutItemModel *)insertItemModelWithView:(UIView *)theView leading:(CGFloat)leading atIndex:(NSInteger)index {
    BBLayoutItemModel *itemModel = [BBLayoutItemModel defaultItemWithView:theView];
    itemModel.leading = leading;
    [self.vms insertObject:itemModel atIndex:index];
    return itemModel;
}

- (void)removeItemModelWithView:(UIView *)theView {
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

- (void)addItemModel:(BBLayoutItemModel *)itemModel {
    [self.vms addObject:itemModel];
}

- (NSMutableArray<BBLayoutItemModel *> *)vms {
    if (nil == _vms) {
        _vms = [NSMutableArray array];
    }
    return _vms;
}

- (void)addItemVM:(BBLayoutItemModel *)vm {
    [self.vms addObject:vm];
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

- (CGFloat)maxHeight {
    CGFloat maxHeight = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        maxHeight = MAX(maxHeight, vm.view.frame.size.height);
    }
    return maxHeight;
}

//这行的总宽度
- (CGFloat)totalNeedWidth {
    CGFloat width = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.view.hidden) {
            continue;
        }
        width += vm.leading + vm.width;
    }
    return width;
}

- (CGFloat)totalWidthIgnoreLeading {
    CGFloat width = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.view.hidden) {
            continue;
        }
        width += vm.width;
    }
    return width;
}

- (BOOL)haveFitSizeView {
    for (BBLayoutItemModel *vm in self.vms) {
        if (vm.fitSize && !vm.view.hidden) {
            return vm.fitSize;
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

- (NSUInteger)count {
    NSInteger count = 0;
    for (BBLayoutItemModel *vm in self.vms) {
        count += vm.view.hidden ? 0 : 1;
    }
    return count;
}

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

- (void)layout_align:(CGFloat)bb_width hAlignment:(BBLayoutHorizontalAlignment)hAlignment {
    BBLayoutHorizontalAlignment align = hAlignment;
    if (self.alignment >= BBLayoutHorizontalAlignmentLeft && self.alignment < BBLayoutHorizontalAlignmentMax) {
        align = self.alignment;
    }
    
    if (BBLayoutHorizontalAlignmentLeft == align) {
        [self layout_alignLeft:bb_width];
    } else if (BBLayoutHorizontalAlignmentRight == align) {
        [self layout_alignRight:bb_width];
    } else if (BBLayoutHorizontalAlignmentCenter == align) {
        [self layout_alignCenter:bb_width];
    } else if (BBLayoutHorizontalAlignmentAverage == align) {
        [self layout_alignAverage:bb_width];
    } else if (BBLayoutHorizontalAlignmentEqualSpace == align) {
        [self layout_alignEqualSpace:bb_width];
    } else if (BBLayoutHorizontalAlignmentJustified == align) {
        [self layout_alignJustified:bb_width];
    }
}

- (void)layout_alignLeft:(CGFloat)bb_width {
    BBLayoutLineModel *lineVM = self;
    UIView *leading_view = nil;
    for (NSInteger li = 0; li < [lineVM count]; li ++) {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
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
        if ([lineVM haveFitSizeView]) {
            BBLayoutItemModel *tail_vm = nil;
            for (NSInteger idx = lineVM.count-1; idx >= 0; idx --) {
                BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
                if (itemVM.fitSize) {
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
        if (nil != tail_vm) {
            itemVM.right = tail_vm.left - tail_vm.leading;
        } else {
            itemVM.right = bb_width;
        }
        tail_vm = itemVM;
    }
    
    //如果已经越界了，就要检查是否有可压缩的view,如果有，倒着布局后面的，然后剩余的分给压缩的view
    //如果没有可压缩的view，那么继续布局完后面的
    if (tail_vm.left < tail_vm.leading) {
        if ([lineVM haveFitSizeView]) {
            BBLayoutItemModel *head_vm = nil;
            for (NSInteger idx = 0; idx < lineVM.count; idx ++) {
                BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:idx];
                if (itemVM.fitSize) {
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
            if (itemVM.fitSize) {
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
            if (itemVM.fitSize) {
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
            head_vm = itemVM;
        }
    } else {
        BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:0];
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
            if (itemVM.fitSize) {
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
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BBLayoutView ()

//将要布局的子view
@property (nonatomic, strong) NSMutableArray <BBLayoutLineModel *> *lineVMs;

@end


@implementation BBLayoutView
- (instancetype)init {
    if (self = [super init]) {
        self.horizontalAlignment = BBLayoutHorizontalAlignmentLeft;
        self.verticalAlignment = BBLayoutVerticalAlignmentCenter;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalAlignment = BBLayoutHorizontalAlignmentLeft;
        self.verticalAlignment = BBLayoutVerticalAlignmentCenter;
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
        if (nil != [lineVM itemVMWithView:view]) {
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

- (CGFloat)bb_height {
    return self.frame.size.height;
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
        [lineModel addItemModelWithView:view leading:leading fitSize:fitWidth];
    } else if (fillWidth) {
        [lineModel addItemModelWithView:view leading:leading fillWidth:fillWidth];
    } else {
        [lineModel addItemModelWithView:view leading:leading];
    }
    
    [self addSubview:view];
}

- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index {
    [self addView:view leading:leading index:index lineNumber:0];
}
- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index lineNumber:(NSInteger)lineNumber {
    [self addView:view leading:leading index:index lineNumber:lineNumber fillWidth:NO];
}
- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index lineNumber:(NSInteger)lineNumber fillWidth:(BOOL)fillWidth {
    [self addView:view leading:leading index:index lineNumber:lineNumber fitWidth:NO fillWidth:(BOOL)fillWidth];
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
    BBLayoutItemModel *layoutItem = [lineModel addItemModelWithView:view leading:leading index:index fillWidth:fillWidth];
    layoutItem.fitSize = fitWidth;
    
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
    
    [lineModel insertItemModelWithView:view leading:leading atIndex:index];
    
    [self addSubview:view];
}

- (void)addLineModel:(BBLayoutLineModel *)lineModel {
    [self.lineVMs addObject:lineModel];
    for (BBLayoutItemModel *item in lineModel.vms) {
        [self addSubview:item.view];
    }
}

- (void)addLineWithSpace:(CGFloat)lineSpace {
    BBLayoutLineModel *lineModel = [BBLayoutLineModel lineModelWithSpace:lineSpace];
    [self.lineVMs addObject:lineModel];
}

- (void)updateLeading:(CGFloat)leading forView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self lineVMWithView:view];
    if (lineVM) {
        BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
        itemVM.leading = leading;
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
        BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
        itemVM.yPad = yPad;
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
        BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
        itemVM.otherSideLeading = leading;
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
        BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
        itemVM.index = index;
        [lineVM adjustIndex];
        [self layout];
    }
}

- (void)removeView:(UIView *)view {
    if (nil == view) {
        NSAssert(0, @"View is nil, pls check.");
        return;
    }
    
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
        if (nil != itemVM) {
            [itemVM.view removeFromSuperview];
            [lineVM removeItemVM:itemVM];
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
    BBLayoutItemModel *itemVM = [lineVM itemVMWithView:view];
    if (itemVM) {
        [lineVM removeItemVM:itemVM];
        if (lineVM.count == 0) {
            [self.lineVMs removeObject:lineVM];
        }
        [self layout];
    }
}

- (void)removeLineModelAtIndex:(NSInteger)index {
    if (self.lineVMs.count <= index) {
        NSAssert(0, @"index beyonds self.lineVMs.count");
        return;
    }
    
    BBLayoutLineModel *lineVM = [self.lineVMs objectAtIndex:index];
    for (BBLayoutItemModel *vm in lineVM.vms) {
        [vm.view removeFromSuperview];
    }
    
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

- (CGFloat)lineSpaceWithIndex:(NSInteger)lineIndex {
    if (self.lineVMs.count <= lineIndex) {
        NSAssert(0, @"index beyonds self.lineVMs.count");
        return CGFLOAT_MIN;
    }
    
    BBLayoutLineModel *lineVM = [self.lineVMs objectAtIndex:lineIndex];
    return lineVM.lineSpace;
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
    CGFloat yPad = [self p_getYPad];
    CGFloat lineCenterY = yPad;
    for (BBLayoutLineModel *lineVM in self.lineVMs) {
        lineCenterY = [self calc_lineCenterYWithLineVM:lineVM preLineBottom:lineCenterY];
        for (NSInteger li = 0; li < [lineVM count]; li ++) {
            BBLayoutItemModel *itemVM = [lineVM itemVMAtIndex:li];
            itemVM.centerY = lineCenterY;
        }
        
        lineCenterY += [lineVM maxHeight] / 2.f;
        
        [lineVM layout_align:self.frame.size.width hAlignment:self.horizontalAlignment];
    }
}

- (void)layoutSubviews {
    [self layout];
}

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
