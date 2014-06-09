//
//  DB.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/9.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "DB.h"
#import "Recorditem.h"
@implementation DB
@synthesize dbName;
- (id)initWithDBName:(NSString *)dbname {
    self = [super init];
    if (self) {
        self.dbName = dbname;
    }
    return self;
}

- (NSArray*)getItem {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:self.dbName];
}

- (void)insertItem:(NSString *)id size:(int)size row:(int)row column:(int)column {

    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = (NSMutableArray*)[userPrefs arrayForKey:self.dbName];
    
    NSMutableArray *record;
    if (array == nil)
        record = [NSMutableArray array];
    else
        record = [NSMutableArray arrayWithArray:array];
    
    
    for (NSData *data in record) {
        Recorditem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([item.id isEqualToString:id]) {
            [record removeObject:data];
            break;
        }
    }
    
    Recorditem *item = [[Recorditem alloc] init];
    item.id = id;
    item.size = [NSNumber numberWithInt:size];
    item.row = [NSNumber numberWithInt:row];
    item.column = [NSNumber numberWithInt:column];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:item];
    [record addObject:encodedObject];

    [userPrefs setObject:record forKey:self.dbName];
    [userPrefs synchronize];
}

- (void)removeItem:(NSString *)id {
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = (NSMutableArray*)[userPrefs arrayForKey:self.dbName];
    NSMutableArray *record = [NSMutableArray arrayWithArray:array];
    
    for (NSData *data in record) {
        Recorditem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([item.id isEqualToString:id]) {
            [record removeObject:data];
            break;
        }
    }
    [userPrefs setObject:record forKey:self.dbName];
    [userPrefs synchronize];
}


@end
