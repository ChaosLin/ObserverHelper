//
//  NSObject+ObserveUniqueID.m
//  test_kvo
//
//  Created by RentonTheUncoped on 15/4/9.
//  Copyright (c) 2015年 Uncoped Studio. All rights reserved.
//

#import "NSObject+ObserveUniqueID.h"
#import "UniqueID.h"
#import <objc/runtime.h>

NSString* str_uniqueID = @"STRUniqueIDKey";

@implementation NSObject (ObserveUniqueID)

- (NSString*)observeUniqueID
{
    id uniqueID = objc_getAssociatedObject(self, (__bridge const void *)(str_uniqueID));
    if (!uniqueID)
    {
        //生成一个
        uniqueID = [UniqueID getUniqueID];
        //赋值
        objc_setAssociatedObject(self, (__bridge const void *)(str_uniqueID), uniqueID, OBJC_ASSOCIATION_COPY);
    }
    return uniqueID;
}

@end
