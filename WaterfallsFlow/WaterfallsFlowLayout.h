//
//  WaterfallsFlowLayout.h
//  WaterfallsFlow
//
//  Created by yao on 2017/6/22.
//  Copyright © 2017年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class WaterfallsFlowLayout;
@protocol WaterfallsFlowLayoutDelegate <NSObject>
@required
//item heigh
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallsFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallsFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallsFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface WaterfallsFlowLayout : UICollectionViewLayout
/*
 item缩进
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/*
 瀑布流的列数
 */
@property (nonatomic, assign) NSInteger columnCount;
/*
 cell的最小高度
 */
@property (nonatomic, assign) NSInteger cellMinHeight;
/*
 cell的最大高度
 */
@property (nonatomic, assign) NSInteger cellMaxHeight;
@end
