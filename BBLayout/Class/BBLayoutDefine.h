//
//  BBLayoutDefine.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/1.
//  Copyright © 2020 Kuwo Beijing Co., Ltd. All rights reserved.
//

#ifndef BBLayoutDefine_h
#define BBLayoutDefine_h

/*
 * layout的对齐方式
 */
typedef NS_ENUM(NSInteger, BBLayoutHorizontalAlignment) {
    BBLayoutHorizontalAlignmentLeft      = 0, //左对齐
    BBLayoutHorizontalAlignmentCenter    = 1, //居中对齐
    BBLayoutHorizontalAlignmentRight     = 2, //右边对齐
    BBLayoutHorizontalAlignmentEqualSpace= 3, //item之间等间距，如果只有一个item，居中显示。
    BBLayoutHorizontalAlignmentAverage   = 4, //等分水平距离，每一个view左右两边的距离都是相等的
    BBLayoutHorizontalAlignmentJustified = 5, //两端对齐
    BBLayoutHorizontalAlignmentCenterEqualSpace = 6, //居中对齐，item之间是等间距，不设置是0
    
    BBLayoutHorizontalAlignmentMax
};

/*
 * 垂直方向上对齐方式
 */
typedef NS_ENUM(NSInteger, BBLayoutVerticalAlignment) {
    BBLayoutVerticalAlignmentCenter        = 0,
    BBLayoutVerticalAlignmentTop           = 1,
    BBLayoutVerticalAlignmentBottom        = 2,
    BBLayoutVerticalAlignmentEqualSpace    = 3, //等行间距，如果只有一行，居中显示。否则，首行和尾行贴边
    BBLayoutVerticalAlignmentAverage       = 4, //等分垂直距离
};


#endif /* BBLayoutDefine_h */
