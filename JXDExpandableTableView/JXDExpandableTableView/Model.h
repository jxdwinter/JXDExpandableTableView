//
//  Model.h
//  JXDExpandableTableView
//
//  Created by JiangXiaodong on 3/27/14.
//  Copyright (c) 2014 jxdwinter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSMutableArray *subModels;

- (instancetype) initWithTitle : (NSString *) title withSubModels : (NSMutableArray *) subModels;

@end
