//
//  SongCell.m
//  BBLayout
//
//  Created by shaozengguang on 2020/3/14.
//  Copyright © 2020 shaozengguang. All rights reserved.
//

#import "SongCell.h"
#import "ViewFactory.h"
#import "BBLayoutView.h"

@interface SongCell ()

@property (nonatomic, strong) UILabel *sortLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *memLabel; // 会员标记
@property (nonatomic, strong) UILabel *qualitLabel; //无损标记
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *mvView;
@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) BBLayoutView *hLayoutView;
@property (nonatomic, strong) BBLayoutView *vTitleLayoutView;

@end

@implementation SongCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.hLayoutView];
    }
    return self;
}


- (BBLayoutView *)hLayoutView {
    if (nil == _hLayoutView) {
        _hLayoutView = [BBLayoutView layoutWithFrame:CGRectMake(0, naviBarHeight(), SCREEN_WIDTH, 66) horizontalAlignment:BBLayoutHorizontalAlignmentJustified];
        
        [_hLayoutView addView:self.sortLabel leading:10 index:0];
        
        [_hLayoutView addView:self.vTitleLayoutView leading:10 lineNumber:0 fillWidth:YES];
        [_hLayoutView updateIndex:1 forView:self.vTitleLayoutView];
        
        [_hLayoutView addView:self.moreView leading:5 index:-1];
        [_hLayoutView addView:self.mvView leading:0 index:-2];
        
        [_hLayoutView updateOtherLeading:10 forView:self.vTitleLayoutView];
    }
    
    return _hLayoutView;
}

- (BBLayoutView *)vTitleLayoutView {
    if (nil == _vTitleLayoutView) {
        _vTitleLayoutView = [BBLayoutView layoutWithFrame:CGRectMake(0, 0, 100, 66)];
        
        [_vTitleLayoutView addView:self.titleLabel leading:0 lineNumber:0 fitWidth:YES];
        
        [_vTitleLayoutView addLineWithSpace:12];
        [_vTitleLayoutView addView:self.descLabel leading:5 lineNumber:1 fillWidth:YES];
        
        [_vTitleLayoutView showBorder];
    }
    return _vTitleLayoutView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.hLayoutView.frame = self.contentView.bounds;
}

#pragma mark - Getter
- (UILabel *)sortLabel {
    if (nil == _sortLabel) {
        _sortLabel = [ViewFactory lableWithTitle:@" "];
        _sortLabel.textAlignment = NSTextAlignmentCenter;
        _sortLabel.frame = CGRectMake(0, 0, 40, 30);
    }
    return _sortLabel;
}

- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [ViewFactory lableWithTitle:@""];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)memLabel {
    if (nil == _memLabel) {
        _memLabel = [ViewFactory lableWithTitle2:@"会员"];
        _memLabel.textColor = [UIColor redColor];
    }
    return _memLabel;
}

- (UILabel *)qualitLabel {
    if (nil == _qualitLabel) {
        _qualitLabel = [ViewFactory lableWithTitle2:@"无损"];
    }
    return _qualitLabel;
}

- (UILabel *)descLabel {
    if (nil == _descLabel) {
        _descLabel = [ViewFactory lableWithTitle:@""];
        _descLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}

- (UIView *)mvView {
    if (nil == _mvView) {
        CGSize s = CGSizeMake(30, 30);
        _mvView = [ViewFactory imageViewWithSize:s];
    }
    _mvView.backgroundColor = [UIColor orangeColor];
    return _mvView;
}

- (UIView *)moreView {
    if (nil == _moreView) {
        CGSize s = CGSizeMake(30, 30);
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"...";
        label.frame = CGRectMake(0, 0, s.width, s.height);
        _moreView = label;
    }
    _moreView.backgroundColor = [UIColor yellowColor];
    return _moreView;
}

- (void)updateWithDict:(NSDictionary *)dict {
    self.sortLabel.text = [dict objectForKey:@"sort"];
    
    self.titleLabel.text = [dict objectForKey:@"title"];
    self.descLabel.text = [dict objectForKey:@"desc"];
    
    NSString *qualitFlag = [dict objectForKey:@"qualit"];
    NSString *memFlag = [dict objectForKey:@"member"];
    int index = 0;
    if (qualitFlag.length > 0) {
        self.qualitLabel.text = qualitFlag;
        [self.vTitleLayoutView insertView:self.qualitLabel leading:0 lineNumber:1 atIndex:index++];
    } else {
        [self.vTitleLayoutView removeView:self.qualitLabel lineIndex:1];
    }
    
    if (memFlag.length > 0) {
        self.memLabel.text = memFlag;
        [self.vTitleLayoutView insertView:self.memLabel leading:index>0?5:0 lineNumber:1 atIndex:index];
        index++;
    } else {
        [self.vTitleLayoutView removeView:self.memLabel lineIndex:1];
    }
    
    [self.vTitleLayoutView updateLeading:index>0?5:0 forView:self.descLabel];
    
    //MV
    if ([[dict objectForKey:@"mv"] boolValue]) {
        [self.hLayoutView insertView:self.mvView leading:5 lineNumber:0 atIndex:2];
        [self.hLayoutView updateIndex:-2 forView:self.mvView];
    } else {
        [self.hLayoutView removeView:self.mvView];
    }
    
    [self.hLayoutView layout];
}
@end
