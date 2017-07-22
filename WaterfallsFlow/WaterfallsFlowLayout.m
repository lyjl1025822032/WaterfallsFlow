//
//  WaterfallsFlowLayout.m
//  WaterfallsFlow
//
//  Created by yao on 2017/6/22.
//  Copyright © 2017年 yao. All rights reserved.
//

#import "WaterfallsFlowLayout.h"
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

static CGFloat cellMinHeight = 50;

@interface WaterfallsFlowLayout()
//section的数量
@property (nonatomic, assign)NSInteger numberOfSections;
//每个section中cell的数量
@property (nonatomic, assign)NSInteger numberOfCellsInSections;
//存储每列cell的X坐标
@property (nonatomic, strong)NSMutableArray *cellXArray;
//记录每列cell的Y坐标
@property (nonatomic, strong)NSMutableDictionary *cellYDic;
//存储每个cell的随机高度，避免每次加载的随机高度都不同
@property (nonatomic, strong)NSMutableArray *cellHeightArray;
//cell的宽度
@property (nonatomic, assign)CGFloat cellWidth;
@end

@implementation WaterfallsFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    _numberOfSections = [self.collectionView numberOfSections];
    _numberOfCellsInSections = [self.collectionView numberOfItemsInSection:0];
    self.cellYDic = [NSMutableDictionary dictionary];
    [self initCellWidth];
    [self initCellHeight];
}

/** 重写ContentSize方法 */
- (CGSize)collectionViewContentSize {
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.cellYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.cellYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    return CGSizeMake(kScreenW, [self.cellYDic[maxCol] floatValue]);
}

/** 重写rect区域中所有元素Layout */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    for(NSInteger i = 0;i < self.columnCount; i++) {
        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
        self.cellYDic[col] = @0;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [array addObject:headerAttrs];
        
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [array addObject:attrs];
        }
        
        //获取footer的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [array addObject:footerAttrs];
    }

    return array;
}

/** 重写indexPath位置supplementaryView */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.cellYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.cellYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    UICollectionViewLayoutAttributes *attributes = nil;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        //size
        CGSize size = CGSizeMake(kScreenW, cellMinHeight);
        CGFloat x = 0;
        CGFloat y = [[self.cellYDic objectForKey:maxCol] floatValue];
        //更新所有对应列的高度
        for(NSString *key in self.cellYDic.allKeys) {
            self.cellYDic[key] = @(y + size.height + self.sectionInset.top);
        }
        attributes.frame = CGRectMake(x , y, size.width, size.height);
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        //size
        CGSize size = CGSizeMake(kScreenW, cellMinHeight);
        CGFloat x = 0;
        CGFloat y = [[self.cellYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
        //更新所有对应列的高度
        for(NSString *key in self.cellYDic.allKeys) {
            self.cellYDic[key] = @(y + size.height + self.sectionInset.top);
        }
        attributes.frame = CGRectMake(x, y, size.width, size.height);
    }
    return attributes;
}

/** 重写indexPath位置cell的Layout */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    __block NSString * minCol = @"0";
    //遍历找出最短的列
    [self.cellYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.cellYDic[minCol] floatValue]) {
            minCol = column;
        }
    }];
    
    //宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.sectionInset.right) / self.columnCount;
    //高度
    CGFloat height = [_cellHeightArray[indexPath.row] floatValue];
    
    CGFloat x = self.sectionInset.left + (width + self.sectionInset.right) * [minCol intValue];
    
    CGFloat space = indexPath.item < self.columnCount ? 0.0 : self.sectionInset.right;

    CGFloat y = [self.cellYDic[minCol] floatValue] + space;
    
    //更新对应列的高度
    self.cellYDic[minCol] = @(y + height);
    
    //计算每个cell的位置
    attributes.frame = CGRectMake(x, y, width, height);
    return attributes;
}

#pragma mark privateAction
/** 根据列数求出cell的宽度 */
- (void)initCellWidth {
    //计算每个Cell的宽度
    _cellWidth = (kScreenW - (_columnCount -1) * self.sectionInset.left) / _columnCount;
    
    //为每个Cell计算X坐标
    _cellXArray = [[NSMutableArray alloc] initWithCapacity:_columnCount];
    for (int i = 0; i < _columnCount; i ++) {
        CGFloat tempX = i * (_cellWidth + self.sectionInset.left);
        [_cellXArray addObject:@(tempX)];
    }
}

/** 随机cell的高度 */
- (void)initCellHeight {
    //随机生成Cell的高度
    _cellHeightArray = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSections];
    for (int i = 0; i < _numberOfCellsInSections; i ++) {
        CGFloat cellHeight = arc4random() % _cellMaxHeight + _cellMinHeight;
        [_cellHeightArray addObject:@(cellHeight)];
    }
}

/** 得到cellY数组中最大值 */
- (CGFloat)getMaxCellYWithArray:(NSMutableArray *)array {
    if (array.count == 0) {
        return 0;
    }
    __block CGFloat maxY = [array.firstObject floatValue];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempY = [obj floatValue];
        maxY = maxY > tempY ? maxY : tempY;
    }];
    return maxY;
}

/** 得到cellY数组中最小值的索引 */
- (CGFloat)getMinCellYWithArray:(NSMutableArray *)array {
    if (array.count == 0) {
        return 0;
    }
    __block NSInteger minIndex = 0;
    __block CGFloat minY = [array.firstObject floatValue];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempY = [obj floatValue];
        if (tempY < minY) {
            minY = tempY;
            minIndex = idx;
        }
    }];
    return minIndex;
}
@end
