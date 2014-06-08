//
//  Setting.h
//  MetroUI
//
//  Created by Henry Kung on 2014/6/6.
//  Copyright (c) 2014年 Henry Kung. All rights reserved.
//

#import <Foundation/Foundation.h>

#define statusBar 20
#define navigationBar 44
#define rowCount 4
#define columnCount 6

typedef enum {
    min,
    mid_width,
    mid_height,
    max
}ItemSize;

typedef enum {
    reSizeItem,
    moveItem
}ItemOperator;

typedef enum {
    switchMode,
    editMode
}ItemActionMode;

@interface Setting : NSObject

@end
