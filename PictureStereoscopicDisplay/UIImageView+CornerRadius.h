//
//  AppDelegate.m
//  PictureStereoscopicDisplay
//
//  Created by Ivy on 2018/5/28.
//  Copyright © 2018年 CYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (CornerRadius)


- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;
///创建圆形的ImageView
- (instancetype)initWithRoundingRectImageView;
///创建圆形的ImageView
- (void)zy_cornerRadiusRoundingRect;
///可为的UIImageView的图片附加边框
- (void)zy_attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
