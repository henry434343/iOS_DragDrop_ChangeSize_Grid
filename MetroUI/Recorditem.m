//
//  Recorditem.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/9.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "Recorditem.h"

@implementation Recorditem
@synthesize id,size,row,column;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.size forKey:@"size"];
    [encoder encodeObject:self.row forKey:@"row"];
    [encoder encodeObject:self.column forKey:@"column"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        self.id = [decoder decodeObjectForKey:@"id"];
        self.size = [decoder decodeObjectForKey:@"size"];
        self.row = [decoder decodeObjectForKey:@"row"];
        self.column = [decoder decodeObjectForKey:@"column"];
    }
    return self;
}
@end
