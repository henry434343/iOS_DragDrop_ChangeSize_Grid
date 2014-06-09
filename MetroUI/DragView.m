//
//  DragView.m
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import "DragView.h"
#import "Setting.h"
@implementation DragView

- (id)initWithFrame:(CGRect)frame itemWidth:(int)itemWidth itemHeight:(int)itemHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor grayColor];
        
        for (int i = 0; i < rowCount; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0+(i*itemWidth), 0, 1, frame.size.height)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self addSubview:lineView];
        }
    	
    	for (int i = 0; i < columnCount; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (topBarHeight)+(i*itemHeight), frame.size.width, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self addSubview:lineView];
        }
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
