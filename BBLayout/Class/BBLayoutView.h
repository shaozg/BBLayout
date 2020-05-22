//
//  BBLayoutView.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/1.
//  Copyright © 2020 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBLayoutDefine.h"
#import "BBLayoutLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBLayoutView : UIView

//水平对齐方式,默认是 BBLayoutHorizontalAlignmentLeft
@property (nonatomic, assign) BBLayoutHorizontalAlignment horizontalAlignment;

//垂直对齐方式，默认是居中对齐 BBLayoutVerticalAlignmentCenter
@property (nonatomic, assign) BBLayoutVerticalAlignment verticalAlignment;

/// 构造函数
/// @param frame frame
+ (instancetype)layoutWithFrame:(CGRect)frame;
/// @param frame frame
/// @param hAlignment 水平对齐方式，默认是 BBLayoutHorizontalAlignmentLeft
+ (instancetype)layoutWithFrame:(CGRect)frame horizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment;
/// @param frame frame
/// @param hAlignment 水平对齐方式，默认是 BBLayoutHorizontalAlignmentLeft
/// @param vAlignment 垂直对齐方式，默认是 BBLayoutVerticalAlignmentCenter
+ (instancetype)layoutWithFrame:(CGRect)frame horizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment verticalAlignment:(BBLayoutVerticalAlignment)vAlignment;


/// 添加一个将要布局的子view
/// @param view 要布局的view
- (void)addView:(UIView *)view;
/// @param view 要布局的view
/// @param leading 要布局view与前面边或者view的间距
- (void)addView:(UIView *)view leading:(CGFloat)leading;
/// @param view 要布局的view
/// @param leading 要布局view与前面边或者view的间距
/// @param lineNumber 对应的行
- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber;
- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber fitWidth:(BOOL)fitWidth;
- (void)addView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber fillWidth:(BOOL)fillWidth;
- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index;
- (void)addView:(UIView *)view leading:(CGFloat)leading index:(int)index lineNumber:(NSInteger)lineNumber;

/// 插入一个view，通常是删除的view，又要加回来
/// @param view 要添加的view
/// @param leading view与前面边或者view的间距
/// @param lineNumber 行号
/// @param index 插入的位置
- (void)insertView:(UIView *)view leading:(CGFloat)leading lineNumber:(NSInteger)lineNumber atIndex:(NSInteger)index;

/// 删除指定的子view
/// @param view 要删除的view
- (void)removeView:(UIView *)view;
/// @param view 要删除的view
/// @param index 具体哪一行的view，便于快速定位
- (void)removeView:(UIView *)view lineIndex:(NSInteger)index;


/// 直接添加一行
- (void)addLineModel:(BBLayoutLineModel *)lineModel;
- (void)addLineWithSpace:(CGFloat)lineSpace;

/// 删除一行
/// @param index 行索引
- (void)removeLineModelAtIndex:(NSInteger)index;
- (void)removeLineModel:(BBLayoutLineModel *)lineModel;

/// 修改leading等方法
/// @param leading 前置偏移量
/// @param view 要修改属性的view
- (void)updateLeading:(CGFloat)leading forView:(UIView *)view;
- (void)updateYPad:(CGFloat)yPad forView:(UIView *)view;
- (void)updateOtherLeading:(CGFloat)leading forView:(UIView *)view;
- (void)updateIndex:(int)index forView:(UIView *)view;

/// 修改对齐方式和lineSpace
- (void)updateHorizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment;
- (void)updateHorizontalAlignment:(BBLayoutHorizontalAlignment)hAlignment lineNumber:(NSInteger)lineNumber;
- (void)updateLineSpace:(CGFloat)lineSpace;
- (void)updateLineSpace:(CGFloat)lineSpace lineNumber:(NSInteger)lineNumber;
- (void)updateLineItemSpace:(CGFloat)itemSpace;
- (void)updateLineItemSpace:(CGFloat)itemSpace lineNumber:(NSInteger)lineNumber;
- (void)updateWidthBlock:(CGFloat (^)(void))widthBlock forView:(UIView *)view;
- (void)updateWidthBlock:(CGFloat (^)(void))widthBlock forView:(UIView *)view lineNumber:(NSInteger)lineNumber;
- (void)updateHeightBlock:(CGFloat (^)(void))heightBlock forView:(UIView *)view;
- (void)updateHeightBlock:(CGFloat (^)(void))heightBlock forView:(UIView *)view lineNumber:(NSInteger)lineNumber;

/// 改方法需要在子view的frame发生变化后手动调用
- (void)layout;


/// 当前一共有多少行，外面绝大部分场景都用不着
- (NSUInteger)numberOfLines;


/// Debug Method
- (void)showBorder;
- (void)showBorderWithColor:(UIColor *)color;
- (void)showBorderWithColor:(UIColor *)color width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
