//
//  ViewFactory.h
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SCREEN_WIDTH    MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT   MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

CGFloat naviBarHeight(void);

@interface ViewFactory : NSObject

+ (UILabel *)lableWithTitle:(NSString *)title;

+ (UIButton *)btnWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action tag:(NSInteger)tag;
+ (UIButton *)bigBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag;

+ (UIView *)viewWithSize:(CGSize)size;
+ (UIView *)viewWithSize:(CGSize)size color:(UIColor *)color;

+ (UIView *)imageViewWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
