//
//  EMCollectionViewCell.m
//  UICollectionViewEndless
//
//  Created by Ennio Masi on 8/27/13.
//  Copyright (c) 2013 Ennio Masi. All rights reserved.
//

#import "EMCollectionViewCell.h"

@implementation EMCollectionViewCell {
    UILabel *lbl;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, (frame.size.height / 2.0f) - 30.0f, frame.size.width, 30.0f)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [[self contentView] addSubview:lbl];
    }
    return self;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [[self contentView] setBackgroundColor:backgroundColor];
}

- (void) setTitle:(NSString *)title {
    [lbl setText:title];
}

@end
