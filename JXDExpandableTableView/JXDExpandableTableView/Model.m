//
//  Model.m
//  JXDExpandableTableView
//
//  Created by JiangXiaodong on 3/27/14.
//  Copyright (c) 2014 jxdwinter. All rights reserved.
//

#import "Model.h"

@implementation Model

- (instancetype) initWithTitle : (NSString *) title withSubModels : (NSMutableArray *) subModels
{
    self = [super init];
    if (self)
    {
        _title = title;
        _subModels = [[NSMutableArray alloc] initWithCapacity:50];
        _subModels = subModels;

    }
    return self;
}

@end
