//
//  BBLayoutLineModel.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/2.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLayoutDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBLayoutLineModel : NSObject

//对齐方式，如果不设置，默认使用全局的布局方式
@property (nonatomic, assign) BBLayoutHorizontalAlignment alignment;

//当前行与上一行的行间距
@property (nonatomic, assign) CGFloat lineSpace;

+ (instancetype)lineModel;
+ (instancetype)lineModelWithSpace:(CGFloat)space;

- (void)addItemModelWithView:(UIView *)theView;
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading;
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading fitWidth:(BOOL)fitSize;
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading fillWidth:(BOOL)fillWidth;

// 只有 alignment == BBLayoutHorizontalAlignmentJustified 的时候，才需要调用这个方法。否则忽略index
- (void)addItemModelWithView:(UIView *)theView leading:(CGFloat)leading index:(int)index;

- (void)removeItemModelWithView:(UIView *)theView;

- (NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
