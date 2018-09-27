//
//  Copyright © 2018 ZhiweiSun. All rights reserved.
//
//  File name: SWaterFallFlowLayout.m
//  Author:    ZhiweiSun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2018/9/22: Created by Cyrex on 2018/9/22
//

#import "SWaterFallFlowLayout.h"

@interface SWaterFallFlowLayout ()

@property (nonatomic, strong) NSMutableArray *dimensionsArray;
@property (nonatomic, strong) NSMutableArray *itemsAttributes;

@end

@implementation SWaterFallFlowLayout
#pragma mark - Override
- (void)prepareLayout {
    [super prepareLayout];

    [self.dimensionsArray removeAllObjects];
    [self.itemsAttributes removeAllObjects];

    for (NSInteger i = 0; i < self.numberOfRowColumns; i++) {
        if (SWaterFallDirectionHorizontal == self.scrollDirection) {
            [self.dimensionsArray addObject:@(self.sectionInset.left)];
        } else {
            [self.dimensionsArray addObject:@(self.sectionInset.top)];
        }
    }

    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [self.itemsAttributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathWithIndex:i]]];
    }

    [self.collectionView reloadData];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes * attr in self.itemsAttributes) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [result addObject:attr];
        }
    }

    return [result copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat dimensions = [self.delegate waterFallFlowLayout:self
                                     dimensionsForDirection:self.scrollDirection
                                                atIndexPath:indexPath];
    if (SWaterFallDirectionVertical == self.scrollDirection) {
        CGFloat totalWidth = self.collectionView.frame.size.width;
        // 有效的高度 (出去间隔及边界)
        CGFloat validWidth = totalWidth - self.sectionInset.left - self.self.sectionInset.right - (self.numberOfRowColumns - 1) * self.minimumLineSpacing;
        // 每一个item的高度
        CGFloat itemWidth = validWidth / self.numberOfRowColumns;

        NSInteger index = [self indexOfShortestRowColumns];
        CGFloat originY = self.sectionInset.top + index * (itemWidth + self.minimumLineSpacing);
        CGFloat originX = [[self.dimensionsArray objectAtIndex:index] floatValue];

        attrs.frame = CGRectMake(originX, originY, dimensions, itemWidth);
        [self.itemsAttributes addObject:attrs];
        self.dimensionsArray[index] = @(originX + dimensions + self.minimumInteritemSpacing);
    } else {
        CGFloat totalHeight = self.collectionView.frame.size.height;
        // 有效的高度 (出去间隔及边界)
        CGFloat validHeight = totalHeight - self.sectionInset.top - self.self.sectionInset.bottom - (self.numberOfRowColumns - 1) * self.minimumInteritemSpacing;
        // 每一个item的高度
        CGFloat itemHeight = validHeight / self.numberOfRowColumns;

        NSInteger index = [self indexOfShortestRowColumns];
        CGFloat originY = self.sectionInset.top + index * (itemHeight + self.minimumInteritemSpacing);
        CGFloat originX = [[self.dimensionsArray objectAtIndex:index] floatValue];

        attrs.frame = CGRectMake(originX, originY, dimensions, itemHeight);
        [self.itemsAttributes addObject:attrs];
        self.dimensionsArray[index] = @(originX + dimensions + self.minimumLineSpacing);
    }

    return attrs;
}

- (CGSize)collectionViewContentSize {
    if (SWaterFallDirectionVertical == self.scrollDirection) {
        CGFloat width = self.collectionView.frame.size.width;
        NSInteger index = [self indexOfLongestRowColumns];
        CGFloat height = [self.dimensionsArray[index] floatValue] + self.sectionInset.bottom - self.minimumInteritemSpacing;

        return CGSizeMake(width, height);
    } else {
        CGFloat height = self.collectionView.frame.size.height;
        NSInteger index = [self indexOfLongestRowColumns];
        CGFloat width = [self.dimensionsArray[index] floatValue] + self.sectionInset.right - self.minimumLineSpacing;

        return CGSizeMake(width, height);
    }

    return CGSizeZero;
}


#pragma mark - Private Methods
- (NSInteger)indexOfShortestRowColumns {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.numberOfRowColumns; i++) {
        if ([self.dimensionsArray[i] floatValue] < [self.dimensionsArray[index] floatValue]) {
            index = i;
        }
    }

    return index;
}

- (NSInteger)indexOfLongestRowColumns {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.numberOfRowColumns; i++) {
        if ([self.dimensionsArray[i] floatValue] > [self.dimensionsArray[index] floatValue]) {
            index = i;
        }
    }

    return index;
}


#pragma mark - Setters
- (void)setScrollDirection:(SWaterFallDirection)scrollDirection {
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        [self invalidateLayout];
    }
}

- (void)setNumberOfRowColumns:(NSInteger)numberOfRowColumns {
    if (_numberOfRowColumns != numberOfRowColumns) {
        _numberOfRowColumns = numberOfRowColumns;
        [self invalidateLayout];
    }
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    if (_minimumLineSpacing != minimumLineSpacing) {
        _minimumLineSpacing = minimumLineSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}


#pragma mark - Getters
- (NSMutableArray *)dimensionsArray {
    if (!_dimensionsArray) {
        _dimensionsArray = [NSMutableArray array];
    }

    return _dimensionsArray;
}

- (NSMutableArray *)itemsAttributes {
    if (!_itemsAttributes) {
        _itemsAttributes = [NSMutableArray array];
    }

    return _itemsAttributes;
}

@end
