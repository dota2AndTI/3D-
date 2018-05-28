//
//  AppDelegate.m
//  PictureStereoscopicDisplay
//
//  Created by Ivy on 2018/5/28.
//  Copyright © 2018年 CYL. All rights reserved.
//

#import "LineLayout.h"
#import "LineCollectionViewCell.h"
#define ItemSize 220.0
#define ItemHeight 300.0
#define LineSpacing 10.0
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define InteritemSpace (-80.0)
//#define FLT_RADIX ItemSize + InteritemSpace
@interface LineLayout()
@property (nonatomic,assign)CGFloat besideDis;//旁边两个cell距离中心点的距离
//保存每一个item的attributes
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic,assign) CGFloat rectX;
@end

@implementation LineLayout

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}


- (instancetype)init{
    if (self = [super init]) {
        self.rectX = 0;
        self.itemSize = CGSizeMake(ItemSize, ItemHeight);
        self.minimumLineSpacing = InteritemSpace;
        self.minimumInteritemSpacing = InteritemSpace;
        self.sectionInset = UIEdgeInsetsMake((FUll_VIEW_HEIGHT - ItemHeight)/2 , (FUll_VIEW_WIDTH - ItemSize)/2.0 , ItemSize, (FUll_VIEW_WIDTH - ItemSize)/2.0);
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;//速率
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //水平方向
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
}

-(CGRect)layoutAttributesForItemWithIndexPath:(NSIndexPath *)indexPath{
    //根据indexPath获取item的attributes
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
    CGFloat imageViewH = (image.size.height/image.size.width) * ItemSize;
    CGFloat originY = (FUll_VIEW_HEIGHT - ItemHeight)/2.0 - 64;
    CGFloat originX = (FUll_VIEW_WIDTH - ItemSize)/2 + (ItemSize + InteritemSpace) * indexPath.row;
    CGFloat width = ItemSize;
    if (imageViewH > ItemHeight) {
        imageViewH = ItemHeight;
    }else if(imageViewH < ItemSize){
        imageViewH = ItemSize;
        originY = originY + (ItemHeight - imageViewH)/2;
    }else{
        originY = originY + (ItemHeight - imageViewH)/2;
    }
    return CGRectMake(originX, originY, width, imageViewH);
}
//计算collectionView的contentSize
- (CGSize)collectionViewContentSize {
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(9 *(ItemSize + InteritemSpace) + FUll_VIEW_WIDTH , 0);
}

#pragma mark - 返回滚动停止的点 自动对齐中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGFloat  offSetAdjustment = MAXFLOAT;
    //预期停止水平中心点
    CGFloat horizotalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;

    //预期滚动停止时的屏幕区域
    CGRect targetRect = CGRectMake(proposedContentOffset.x , 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    if (self.collectionView.contentOffset.x < 0) {
        return CGPointMake(0, 0);
    }
    //找出最接近中心点的item
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes * attributes in array) {
        attributes.frame = [self layoutAttributesForItemWithIndexPath:attributes.indexPath];
        CGFloat currentCenterX = attributes.center.x;
//        NSLog(@"自动distance->%f",currentCenterX);
        if (ABS(currentCenterX - horizotalCenter) < ABS(offSetAdjustment)) {
            offSetAdjustment = currentCenterX - horizotalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    self.rectX = rect.origin.x;
//    NSLog(@"rect.origin.x->%f",rect.origin.x);
//    NSLog(@"self.collectionView.contentOffset.x->%f",self.collectionView.contentOffset.x);

    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (int i = 0; i < array.count ; i++) {
        UICollectionViewLayoutAttributes *attributes = array[i];
        attributes.frame = [self layoutAttributesForItemWithIndexPath:attributes.indexPath];
        //判断相交
        if (CGRectIntersectsRect(visibleRect, rect)) {
            //当前视图中心点 距离item中心点距离
            CGFloat  distance  =  CGRectGetMidX(self.collectionView.bounds) - attributes.center.x;
            //            NSLog(@"distance->%f",attributes.center.x);
            CATransform3D transfrom = attributes.transform3D;
            if (ABS(distance) == 0) {//在中点
                //                CGFloat m34 = 400.0;
                transfrom.m34 = -0.0025;
                attributes.transform3D = CATransform3DRotate(transfrom, 0, 0, 1, 0);
                //                attributes.transform3D = CATransform3DScale(attributes.transform3D, 1.2, 1.2, 1);
                //                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, 0);
                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, 40);//沿Z轴平移
            }else{
                if(ABS(distance) > 0 && ABS(distance) < (ItemSize + InteritemSpace)){
                    //                    CGFloat m34 = 400.0;
                    //                    CATransform3D transfrom = attributes.transform3D;
                    transfrom.m34 = - 0.0025;
                    //                    NSInteger count = (ItemSize + InteritemSpace);
                    CGFloat radiants = M_PI/3 * (distance/(ItemSize + InteritemSpace));
                    attributes.transform3D = CATransform3DRotate(transfrom, radiants, 0, 1, 0);//旋转
                    attributes.transform3D = CATransform3DTranslate(attributes.transform3D, -70*(distance/(ItemSize + InteritemSpace)*1.0), 0, 40*(1-(ABS(distance)/(ItemSize + InteritemSpace))));//沿X轴平移
                    //                    attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, );//沿Z轴平移
                    attributes.transform3D = CATransform3DScale(attributes.transform3D, 1 -(0.2 * ABS(distance)/(ItemSize + InteritemSpace)), 1 -(0.2 *ABS(distance)/(ItemSize + InteritemSpace)), 1);//缩小
                }else{
                    if (distance < -(ItemSize + InteritemSpace)) {
                        distance = -(ItemSize + InteritemSpace);
                    }else if (distance > (ItemSize + InteritemSpace)){
                        distance = (ItemSize + InteritemSpace);
                    }
                    //                    CGFloat m34 = 400.0;
                    //                    CATransform3D transfrom = attributes.transform3D;
                    transfrom.m34 = -0.0025;
                    CGFloat radiants = M_PI/3*(distance/(ItemSize + InteritemSpace));
                    attributes.transform3D = CATransform3DRotate(transfrom, radiants, 0, 1, 0);
                    attributes.transform3D = CATransform3DTranslate(attributes.transform3D, -70*distance/(ItemSize + InteritemSpace), 0, 0);
                    //                    attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0, 0, 0);
                    attributes.transform3D = CATransform3DScale(attributes.transform3D, 1 -(0.2 * ABS(distance)/(ItemSize + InteritemSpace)), 1 -(0.2 * ABS(distance)/(ItemSize + InteritemSpace)), 1);
                }
            }
        }else{
            attributes.frame = CGRectMake(0, 0, 0, 0);
//            CGFloat  distance  =  CGRectGetMidX(self.collectionView.bounds) - attributes.center.x;
//            CGFloat m34 = 400.0;
//            CATransform3D transfrom = attributes.transform3D;
//            transfrom.m34 = -1.0 / m34;
//            attributes.transform3D = CATransform3DRotate(transfrom, 0, 0, 0, 0);
//            NSLog(@"没有香蕉，distance-》%f",distance);
        }
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}









@end
