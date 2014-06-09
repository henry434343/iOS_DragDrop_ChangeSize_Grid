//
//  Recorditem.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/9.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recorditem : NSObject <NSCoding> {
    NSString *value;
}

@property(nonatomic, strong)NSString *id;
@property(nonatomic, assign)NSNumber *size;
@property(nonatomic, assign)NSNumber *row;
@property(nonatomic, assign)NSNumber *column;
@end
