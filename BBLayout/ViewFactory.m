//
//  ViewFactory.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/3.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "ViewFactory.h"
#import "AppDelegate.h"

CGFloat naviBarHeight() {
    UINavigationController *rootVC = (UINavigationController *)((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController;
    CGFloat navigationBarAndStatusBarHeight = rootVC.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    return navigationBarAndStatusBarHeight;
}
@implementation ViewFactory
+ (UILabel *)lableWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor redColor];
    label.layer.borderColor = [UIColor darkTextColor].CGColor;
    label.layer.borderWidth = 1;
    [label sizeToFit];
    return label;
}

+ (UIButton *)btnWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.tag = tag;
    return btn;
}
+ (UIButton *)bigBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag {
    CGSize maxSize = [UIScreen mainScreen].bounds.size;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, maxSize.width - 2 * 30, 40);
    btn.tag = tag;
    return btn;
}

+ (UIView *)viewWithSize:(CGSize)size {
    NSArray *list = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor brownColor], [UIColor orangeColor], [UIColor blackColor]];
    static NSInteger idx = 0;
    return [ViewFactory viewWithSize:size color:list[idx++ % list.count]];
}
+ (UIView *)viewWithSize:(CGSize)size color:(UIColor *)color {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    v.backgroundColor = color;
    return v;
}

+ (UIView *)imageViewWithSize:(CGSize)size {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boy"]];
    imgView.frame = CGRectMake(0, 0, size.width, size.height);
    return imgView;
}
@end
