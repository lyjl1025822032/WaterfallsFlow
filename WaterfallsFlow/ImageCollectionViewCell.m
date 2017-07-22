//
//  ImageCollectionViewCell.m
//  WaterfallsFlow
//
//  Created by yao on 2017/6/22.
//  Copyright © 2017年 yao. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.lineNum];
    }
    return self;
}

- (UILabel *)lineNum {
    if (_lineNum == nil) {
        self.lineNum = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 25)];
        _lineNum.textColor = [UIColor blackColor];
        _lineNum.font = [UIFont systemFontOfSize:15];
    }
    return _lineNum;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.contentMode =  UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds  = YES;
    }
    return _imageView;
}
@end
