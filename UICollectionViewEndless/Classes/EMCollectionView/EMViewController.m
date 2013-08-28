//
//  EMViewController.m
//  UICollectionViewEndless
//
//  Created by Ennio Masi on 8/27/13.
//  Copyright (c) 2013 Ennio Masi. All rights reserved.
//

#import "EMViewController.h"
#import "EMCollectionViewCell.h"

@interface EMViewController () {
    UICollectionView *collectionView;
    
    NSArray *items;
    NSArray *newItems;
    
    BOOL updateCompleted;
}

@end

@implementation EMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    updateCompleted = YES;
    
    items = [[NSArray alloc] initWithObjects:@"reina", @"maggio", @"albiol", @"britos", @"zuniga", @"inler", @"behrami", @"callejon", @"hamsik", @"pandev", @"higuain", @"rafael", nil];
    
    newItems = [[NSArray alloc] initWithObjects:@"armero", @"fernandez", @"cannavaro", @"mesto", @"dzemaili", @"radosevic", @"insigne", @"zapata", @"calaiò", @"grava", @"sosa", @"de sanctis", @"campagnaro", nil];

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewLayout setItemSize:CGSizeMake(104.0f, 107.0f)];
    [collectionViewLayout setMinimumInteritemSpacing:2.0f];
    [collectionViewLayout setMinimumLineSpacing:2.0f];

    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:collectionViewLayout];
    [collectionView registerClass:[EMCollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];

    [self.view addSubview:collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [items count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Updating cell at [%d]", indexPath.row);
    EMCollectionViewCell *cell = (EMCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    [cell setTitle: [items objectAtIndex:indexPath.row]];
    if (indexPath.row <= 11)
        [cell setBackgroundColor:[UIColor yellowColor]];
    else if (indexPath.row <= 18)
        [cell setBackgroundColor:[UIColor redColor]];
    else
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Buh!" message:@"Nothing to do!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [av show];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(104, 107);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 2, 20, 2);
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *visibleItems = [collectionView indexPathsForVisibleItems];
    
    int maxIndex = [self findMaxIndex:visibleItems];

    if (maxIndex == (items.count - 1) && newItems.count > 0) {
        if (updateCompleted) {
            updateCompleted = NO;
            [collectionView performBatchUpdates:^{
                int startIndex = items.count;
                
                [self updateItems];
                [self updateNewItems];
                
                NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                for (int i = startIndex; i < items.count; i++)
                    [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
            } completion:^(BOOL finished){
                updateCompleted = YES;
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(items.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            }];
        } else
            NSLog(@"Avoid another operation");
    } else
        NSLog(@"Nothing to load");
}

- (int) findMaxIndex:(NSArray *)indexes {
    int maxIndex = 0;
    for (NSIndexPath *indexPath in indexes)
        if (indexPath.row > maxIndex)
            maxIndex = indexPath.row;
    
    return maxIndex;
}

- (void) updateItems {
    NSMutableArray *data = [items mutableCopy];
    
    for (int i = 0; i < MIN(3, newItems.count); i++)
        [data addObject:[newItems objectAtIndex:i]];
    items = [NSArray arrayWithArray:data];
}

- (void) updateNewItems {
    NSMutableArray *data = [newItems mutableCopy];
    for (int i = 0; i < MIN(3, newItems.count); i++)
        [data removeObjectAtIndex:0];

    newItems = [NSArray arrayWithArray:data];
}

@end