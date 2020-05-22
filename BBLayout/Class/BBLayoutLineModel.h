//
//  BBLayoutLineModel.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/2.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBLayoutDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBLayoutLineModel : NSObject

//对齐方式，如果不设置，默认使用全局的布局方式
@property (nonatomic, assign) BBLayoutHorizontalAlignment alignment;

//当前行与上一行的行间距
@property (nonatomic, assign) CGFloat lineSpace;

//item之间的间距, 只有当 alignment == BBLayoutHorizontalAlignmentCenterEqualSpace 的时候才用到这个值, 默认是0
@property (nonatomic, assign) CGFloat itemSpace;

+ (instancetype)lineModel;
+ (instancetype)lineModelWithAlignment:(BBLayoutHorizontalAlignment)alignment;
+ (instancetype)lineModelWithSpace:(CGFloat)space;

- (void)addView:(UIView *)theView;
- (void)addView:(UIView *)theView leading:(CGFloat)leading;
- (void)addView:(UIView *)theView leading:(CGFloat)leading fitWidth:(BOOL)fitWidth;
- (void)addView:(UIView *)theView leading:(CGFloat)leading fillWidth:(BOOL)fillWidth;

// 只有 alignment == BBLayoutHorizontalAlignmentJustified 的时候，才需要调用这个方法。否则忽略index
- (void)addView:(UIView *)theView leading:(CGFloat)leading index:(int)index;

- (void)insertView:(UIView *)theView leading:(CGFloat)leading atIndex:(NSInteger)index;

- (void)removeView:(UIView *)theView;
- (void)removeAllViews;

// count of views
- (NSUInteger)count;

// Update
- (void)updateLeading:(CGFloat)leading forView:(UIView *)view;
- (void)updateYPad:(CGFloat)yPad forView:(UIView *)view;
- (void)updateOtherSideLeading:(CGFloat)leading forView:(UIView *)view;
- (void)updateIndex:(int)index forView:(UIView *)view;
- (void)updateLineSpace:(CGFloat)space;
- (void)updateWidthBlock:(CGFloat (^)(void))widthBlock forView:(UIView *)view;
- (void)updateHeightBlock:(CGFloat (^)(void))heightBlock forView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
