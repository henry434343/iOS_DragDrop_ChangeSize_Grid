//
//  PointItem.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "PointItem.h"

@implementation PointItem
@synthesize X,Y,check;

- (id)initWithPoint:(int)x andY:(int)y{
    self = [super init];
    if (self) {
        self.X = x;
        self.Y = y;
    }
    return self;
}

-(BOOL)isEqual:(PointItem *)p {
    return (self.X == p.X && self.Y == p.Y);
}

@end
