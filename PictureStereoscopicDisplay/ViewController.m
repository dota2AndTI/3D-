//
//  AppDelegate.m
//  PictureStereoscopicDisplay
//
//  Created by Ivy on 2018/5/28.
//  Copyright © 2018年 CYL. All rights reserved.
//

#import "ViewController.h"
#import "LineLayout.h"
#import "LineCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDataSource>
{
    UIView *shadeNAvView;
    UIView *maskingView1;
}

@property (nonatomic, strong) UICollectionView *lineCollectionView;
@property (nonatomic,strong) LineLayout *lineLayout;
@end

static NSString  * const cellID = @"cellid";

@implementation ViewController

- (UICollectionView *)lineCollectionView{
    if (_lineCollectionView == nil) {
        LineLayout *layout = [[LineLayout alloc] init];
        self.lineLayout = layout;
        //        layout.delegate = self;
        //        layout.columnSpacing = 10;
        NSLog(@">>>>>>>>>>%f,%f",W,W - (W - 220)/2);
        layout.sectionInset = UIEdgeInsetsMake((H - 300)/2 , (W - 110)/2.0 , 200, W/2.0 - 110);
        _lineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, H) collectionViewLayout:layout];
        _lineCollectionView.backgroundColor = [UIColor clearColor];
        _lineCollectionView.dataSource = self;
        [_lineCollectionView registerClass:[LineCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _lineCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"new_defaultImage"];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
    effectView.frame = backgroundView.bounds;
    [backgroundView addSubview:effectView];
    [self.view addSubview:backgroundView];
    
    [self.view addSubview:self.lineCollectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    //    for (UIView *view in cell.contentView.subviews) {
    //        [view removeFromSuperview];
    //    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
    cell.mirrorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
    //    [self setSubViewsWith:indexPath AndCell:cell];
    //    [cell setSemanticContentAttribute:[self.lineLayout layoutAttributesForItemAtIndexPath:indexPath]];
    return cell;
}

-(void)setSubViewsWith:(NSIndexPath *)indexPath AndCell:(LineCollectionViewCell *)cell{
    UIImageView *imageView = [[UIImageView alloc]initWithCornerRadiusAdvance:10 rectCornerType:UIRectCornerAllCorners];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
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
    imageView.frame = cell.bounds;
    [cell.contentView addSubview:imageView];
    [imageView.layer addSublayer:[self setMirrorEffectWith:imageView]];
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
    blackLayer.opacity = 0.7;
    [reflectLayer addSublayer:blackLayer];
    
    // 给该reflection加个mask
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.bounds = reflectLayer.bounds;
    mask.opacity = .4;
    mask.position = CGPointMake(mask.bounds.size.width/2, mask.bounds.size.height/2);
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor clearColor].CGColor,
                   (__bridge id)[UIColor grayColor].CGColor, nil];
    mask.startPoint = CGPointMake(0, .5);
    mask.endPoint = CGPointMake(0, 1);
    reflectLayer.mask = mask;
    return reflectLayer;
}


@end
