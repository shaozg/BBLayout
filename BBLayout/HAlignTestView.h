//
//  HAlignTestView.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBLayoutView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HAlignTestView : UIView

+ (instancetype)hAlignmentViewWithFrame:(CGRect)frame;
+ (instancetype)vAlignmentViewWithFrame:(CGRect)frame;

@property (nonatomic, strong) BBLayoutView *demoLayoutView;

@end

NS_ASSUME_NONNULL_END
