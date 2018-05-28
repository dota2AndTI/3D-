//
//  AppDelegate.m
//  PictureStereoscopicDisplay
//
//  Created by Ivy on 2018/5/28.
//  Copyright © 2018年 CYL. All rights reserved.
//

#import "LineCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
@implementation LineCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setSubViews];
//        NSLog(@"=============%@",NSStringFromCGRect(frame));
    }
    return self;
}

-(void)setSubViews{
    UIImageView *imageView = [[UIImageView alloc]initWithCornerRadiusAdvance:10 rectCornerType:UIRectCornerAllCorners];
    self.imageView = imageView;
//    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_defaultImage"]];
    UIImage *image = imageView.image;
    CGFloat imageViewH = (image.size.height/image.size.width) * 220;
    if (imageViewH > 300) {
        imageViewH = 300;
    }
//    NSLog(@"imageViewH->%f,image.height->%f,image.width->%f",imageViewH,image.size.height,image.size.width);
    //    self.lineLayout.itemHeightBlock = ^CGFloat{
    //        return imageViewH;
    //    };
    //    imageView.frame = CGRectMake(0, 150 - imageViewH/2.0, 220, imageViewH);
    imageView.frame = self.bounds;
//    [imageView.layer addSublayer:[self setMirrorEffectWith:imageView]];
    
    self.mirrorImageView = [[UIImageView alloc]init];
    CATransform3D turnTrans = CATransform3DMakeRotation(M_PI, 5, 0, 0);
    self.mirrorImageView.layer.transform = turnTrans;
    
    self.mirrorImageView.frame = CGRectMake(0, self.bounds.size.height + 20, self.bounds.size.width, self.bounds.size.height);
    self.mirrorImageView.layer.cornerRadius = 10;
    self.mirrorImageView.layer.masksToBounds = YES;
    
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.bounds = self.mirrorImageView.bounds;
    mask.opacity = .4;
    mask.position = CGPointMake(mask.bounds.size.width/2, mask.bounds.size.height/2);
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor clearColor].CGColor,
                   (__bridge id)[UIColor grayColor].CGColor, nil];
    mask.startPoint = CGPointMake(0, .5);
    mask.endPoint = CGPointMake(0, 1);
    
    self.mirrorImageView.layer.mask = mask;
    
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:self.mirrorImageView];
}

-(CALayer *)setMirrorEffectWith:(UIView *)view{
    CALayer *reflectLayer = [CALayer layer];
    reflectLayer.contents = view.layer.contents;
    reflectLayer.bounds = view.layer.bounds;
    reflectLayer.position = CGPointMake(view.layer.bounds.size.width/2, view.layer.bounds.size.height*1.5 + 20);
    reflectLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    reflectLayer.cornerRadius = 10;
    reflectLayer.masksToBounds = YES;
    
    // 给该reflection加个半透明的layer
    CALayer *blackLayer = [CALayer layer];
    //    blackLayer.backgroundColor = [UIColor blackColor].CGColor;
    blackLayer.bounds = reflectLayer.bounds;
    blackLayer.position = CGPointMake(blackLayer.bounds.size.width/2, blackLayer.bounds.size.height/2);
    blackLayer.opacity = 0.4;
    [reflectLayer addSublayer:blackLayer];
    
    // 给该reflection加个mask
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.bounds = reflectLayer.bounds;
    mask.position = CGPointMake(mask.bounds.size.width/2, mask.bounds.size.height/2);
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor clearColor].CGColor,
                   (__bridge id)[UIColor lightGrayColor].CGColor, nil];
    mask.startPoint = CGPointMake(0, 0);
    mask.endPoint = CGPointMake(0, 1);
    reflectLayer.mask = mask;
    return reflectLayer;
}


@end
