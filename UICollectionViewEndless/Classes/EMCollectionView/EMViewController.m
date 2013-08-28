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
    NSArray *colors;
}

@end

@implementation EMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    items = [[NSArray alloc] initWithObjects:@"reina", @"maggio", @"albiol", @"britos", @"zuniga", @"inler", @"behrami", @"callejon", @"hamsik", @"pandev", @"higuain", @"rafael", nil];
    
    newItems = [[NSArray alloc] initWithObjects:@"armero", @"fernandez", @"cannavaro", @"mesto", @"dzemaili", @"radosevic", @"insigne", @"zapata", @"calaiò", @"grava", @"sosa", @"de sanctis", @"campagnaro", nil];
    
    colors = [[NSArray alloc] initWithObjects:[UIColor yellowColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor cyanColor], [UIColor greenColor], nil];

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewLayout setItemSize:CGSizeMake(104.0f, 104.0f)];
    [collectionViewLayout setMinimumInteritemSpacing:2.0f];
    [collectionViewLayout setMinimumLineSpacing:2.0f];
    [collectionViewLayout setSectionInset:UIEdgeInsetsMake(20, 2, 20, 2)];

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
    [cell setBackgroundColor:[self chooseAColor:indexPath.row]];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Buh!" message:@"Nothing to do!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [av show];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height > collectionView.frame.size.height && newItems.count > 0) {
        [collectionView performBatchUpdates:^{
            int startIndex = items.count;
            
            [self updateItems];
            [self updateNewItems];
            
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            for (int i = startIndex; i < items.count; i++)
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        } completion:^(BOOL finished){
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(items.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }];
    } else
        NSLog(@"Avoid another operation");
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

- (UIColor *) chooseAColor:(int)row {
    if (row <= 11)
        return [colors objectAtIndex:0];
    else {
        int r = arc4random() % colors.count;
        return [colors objectAtIndex:(r == 0) ? (r + 1) : r];
    }
}

@end