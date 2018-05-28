//
//  AppDelegate.m
//  PictureStereoscopicDisplay
//
//  Created by Ivy on 2018/5/28.
//  Copyright © 2018年 CYL. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class LineLayout;
//@protocol LineLayoutDelegate <NSObject>
//
////计算item高度的代理方法，将item的高度与indexPath传递给外界
//- (UIImage *)waterfallLayout:(LineLayout *)layout;
//
//@end

//typedef CGFloat(^BLOCK)(void);

@interface LineLayout : UICollectionViewFlowLayout

//总共多少列，默认是2
@property (nonatomic, assign) NSInteger columnCount;

//列间距，默认是0
@property (nonatomic, assign) NSInteger columnSpacing;

//行间距，默认是0
@property (nonatomic, assign) NSInteger rowSpacing;

//section与collectionView的间距，默认是（0，0，0，0）
@property (nonatomic, assign) UIEdgeInsets sectionInset;

//同时设置列间距，行间距，sectionInset
//- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;
//@property (nonatomic,weak)id<LineLayoutDelegate> delegate;

//计算item高度的block，将item的高度与indexPath传递给外界
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(void);


@end
