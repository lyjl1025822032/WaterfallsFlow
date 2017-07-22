//
//  ViewController.m
//  WaterfallsFlow
//
//  Created by yao on 2017/6/22.
//  Copyright © 2017年 yao. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallsFlowLayout.h"
#import "ImageCollectionViewCell.h"
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WaterfallsFlowLayoutDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

#pragma mark WaterfallsFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterfallsFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WaterfallsFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 20);
}

#pragma mark UICollectionViewDelegte/DataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor cyanColor];
        return footerView;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"00%ld.jpg", arc4random() % 10];
    cell.lineNum.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    return cell;
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        WaterfallsFlowLayout *flowLayout = [[WaterfallsFlowLayout alloc] init];
        flowLayout.columnCount = 3;
        flowLayout.cellMinHeight = 50;
        flowLayout.cellMaxHeight = 200;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imagecell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _collectionView.backgroundColor = [UIColor greenColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
