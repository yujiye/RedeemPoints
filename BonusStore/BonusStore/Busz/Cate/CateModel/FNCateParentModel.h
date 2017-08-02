//
//  FNCateParentModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"

@interface FNCateParentModel : FNBaseArgs

@property(assign,nonatomic)long parentid;

@property(copy,nonatomic)NSString * imageUrl;

@property(assign,nonatomic) float offset;//右边数据源滚动的位置

@property (nonatomic, copy) NSString * code;

@property (nonatomic, copy) NSString * desc;

@property (nonatomic, copy) NSString * subjectNodes;

@property (nonatomic, copy) NSString * subjectId;

@property (nonatomic, copy) NSString * subjectName;

@property (nonatomic, copy) NSString * pid;

@property (nonatomic, copy) NSString * isLeaf;

@end
