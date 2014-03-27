//
//  SubModel.m
//  JXDExpandableTableView
//
//  Created by JiangXiaodong on 3/27/14.
//  Copyright (c) 2014 jxdwinter. All rights reserved.
//

#import "SubModel.h"

@implementation SubModel

- (instancetype) initWithTitle : (NSString *) title
{
    self = [super init];
    if (self)
    {
        _title = title;
    }
    return self;
}

@end
