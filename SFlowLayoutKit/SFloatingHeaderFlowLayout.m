//
//  Copyright © 2018 ZhiweiSun. All rights reserved.
//
//  File name: SFloatingHeaderFlowLayout.m
//  Author:    ZhiweiSun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2018/9/23: Created by Cyrex on 2018/9/23
//

#import "SFloatingHeaderFlowLayout.h"

@implementation SFloatingHeaderFlowLayout
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    UICollectionView *collectionView = [self collectionView];
    UIEdgeInsets insets = [collectionView contentInset];
    CGPoint offset = [collectionView contentOffset];
    CGFloat minY = -insets.top;

    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributesCopy = [[NSArray alloc] initWithArray:attributes copyItems:YES];

    if (offset.y < minY) {
        CGSize  headerSize = [self headerReferenceSize];
        CGFloat deltaY = fabs(offset.y - minY);
        for (UICollectionViewLayoutAttributes *attrs in attributesCopy) {
            if ([attrs representedElementKind] == UICollectionElementKindSectionHeader) {
                CGRect headerRect = [attrs frame];
                headerRect.size.height = MAX(minY, headerSize.height + deltaY);
                headerRect.origin.y = headerRect.origin.y - deltaY;
                [attrs setFrame:headerRect];
                break;
            }
        }
    }

    return attributesCopy;
}

@end