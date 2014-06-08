//
//  PointItem.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointItem : NSObject

@property(nonatomic, assign)int X;
@property(nonatomic, assign)int Y;
@property(nonatomic, assign)BOOL check;

- (id)initWithPoint:(int)X andY:(int)Y;
-(BOOL) isEqual:(PointItem*)p;
@end
