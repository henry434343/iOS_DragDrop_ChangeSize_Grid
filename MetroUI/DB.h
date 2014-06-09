//
//  DB.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/9.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DB : NSObject
@property(nonatomic, strong)NSString *dbName;

- (id)initWithDBName:(NSString*)dbName;

- (NSArray*)getItem;
- (void)removeItem:(NSString*)id;
- (void)insertItem:(NSString*)id size:(int)size row:(int)row column:(int)column;
@end
