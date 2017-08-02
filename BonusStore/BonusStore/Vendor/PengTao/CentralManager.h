//
//  CentralManager.h
//  PengTao
//
//  Created by szt on 2017/3/13.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol CentralManagerDelegate<NSObject>
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end
@interface CentralManager : NSObject<CBCentralManagerDelegate>
@property (weak, nonatomic) id<CentralManagerDelegate> delegate;

@property(nonatomic,strong) CBCentralManager *cbcm;

+ (CentralManager *)sharedManager;

@end
