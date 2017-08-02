//
//  FNDBManager.m
//  RcsIntegral
//
//  Created by Nemo on 16/3/25.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDBManager.h"

NSString *const FNSystemNotification    =   @"FNSystemNotification";

NSString *const FNCampaignNotification  =   @"FNCampaignNotification";

@implementation FNDBManager

+ (instancetype)shared
{
    static FNDBManager *manager = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
    
        manager = [[self alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator *coodinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSURL *document = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storURL = [document URLByAppendingPathComponent:@"Model.sqlite"];
        
        NSError *erro = nil;
        
        [coodinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storURL options:nil error:&erro];
        
        self.bc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        self.bc.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        
        [self.bc setPersistentStoreCoordinator:coodinator];
        
        self.fc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        self.fc.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        
        [self.fc setPersistentStoreCoordinator:coodinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    
    return self;
}

- (void)save:(NSNotification *)noti
{
    [self.fc performBlock:^{
        
        [_fc mergeChangesFromContextDidSaveNotification:noti];
       
        NSSet *insert = [noti userInfo][@"inserted"];
        
        NSSet *delete = [noti userInfo][@"delete"];
        
        NSMutableSet *systemNotiSet = [NSMutableSet set];
        
        NSMutableSet *campaignNotiSet = [NSMutableSet set];
        
        if ([insert count])
        {
            for (NSManagedObject *ins in insert)
            {
                if ([ins isKindOfClass:NSClassFromString(@"")])
                {
                    [systemNotiSet addObject:ins];
                }
                else if ([ins isKindOfClass:NSClassFromString(@"")])
                {
                    [campaignNotiSet addObject:ins];
                }
            }
            
            if ([systemNotiSet count])
            {
                [self update:[NSNotification notificationWithName:FNSystemNotification object:systemNotiSet]];
            }
            else if ([campaignNotiSet count])
            {
                [self update:[NSNotification notificationWithName:FNCampaignNotification object:campaignNotiSet]];
            }
        }
        
        if ([delete count])
        {
            [self update:noti];
        }
        
    }];
}

- (void)update:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[noti name] object:[noti object]];
}

+ (void)addNotificationWithObserver:(id)observer name:(NSString *)name sel:(SEL)sel
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:name object:nil];
}

+ (void)removeNotificationFromObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

+ (void)fetch
{
    
}

+ (void)del
{
    
}

@end
