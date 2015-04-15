//
//  ObserverHelper.m
//
//  Created by RentonTheUncoped on 15/4/8.
//

#import "ObserverHelper.h"
#import "NSObject+ObserveUniqueID.h"

@interface DDKVOHelperItem : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSString* observedPath;
@end

@implementation DDKVOHelperItem

- (instancetype)initWithTarget:(id)target;
{
    if (self = [super init])
    {
        _target = target;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target path:(NSString*)path
{
    if (self = [super init])
    {
        _target = target;
        _observedPath = path;
    }
    return self;
}
@end

@interface ObserverHelper()

+ (instancetype)sharedInstance;
+ (void)destroy;

@property (strong) NSMutableDictionary* dic_id2observer;
@property (strong) NSMutableDictionary* dic_id2object;
@end

static ObserverHelper* singleHelper = nil;

@implementation ObserverHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleHelper = [ObserverHelper new];
    });
    return singleHelper;
}

+ (void)destroy
{
    singleHelper = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.dic_id2observer = [NSMutableDictionary dictionary];
        self.dic_id2object = [NSMutableDictionary dictionary];
    }
    return self;
}


+ (void)addObservedObject:(id)object observer:(id)observer keyPath:(NSString *)path
{
    ObserverHelper* helper = [self sharedInstance];
    if (object && observer)
    {
        {
            //id2observer;
            NSString* key_observer = [object observeUniqueID];
            NSMutableArray* arr_observers = [helper.dic_id2observer valueForKey:key_observer];
            if (!arr_observers)
            {
                arr_observers = [NSMutableArray array];
                [helper.dic_id2observer setValue:arr_observers forKey:key_observer];
            }
            DDKVOHelperItem* item = [[DDKVOHelperItem alloc]initWithTarget:observer path:path];
            [arr_observers addObject:item];
            [(NSObject*)object addObserver:observer forKeyPath:path options:NSKeyValueObservingOptionNew context:nil];
        }
        
        {
            //id2object
            NSString* key_object = [observer observeUniqueID];
            NSMutableArray* arr_object = [helper.dic_id2object valueForKey:key_object];
            if (!arr_object)
            {
                arr_object = [NSMutableArray array];
                [helper.dic_id2object setValue:arr_object forKey:key_object];
            }
            DDKVOHelperItem* item = [[DDKVOHelperItem alloc]initWithTarget:object path:path];
            [arr_object addObject:item];
        }
    }
}

+ (void)removeObserverForObject:(id)object
{
    ObserverHelper* helper = [self sharedInstance];
    if (object)
    {
        NSString* key = [object observeUniqueID];
        NSArray* arr_observer = [helper.dic_id2observer valueForKey:key];
        for (DDKVOHelperItem* item in arr_observer)
        {
            if (item.target && item.observedPath)
            {
                [(NSObject*)object removeObserver:item.target forKeyPath:item.observedPath];
            }
        }
        [helper.dic_id2observer removeObjectForKey:key];
    }
}

+ (void)removeObservedObjectForObserver:(id)observer
{
    ObserverHelper* helper = [self sharedInstance];
    if (observer)
    {
        NSString* key = [observer observeUniqueID];
        NSArray* arr_observer = [helper.dic_id2object valueForKey:key];
        for (DDKVOHelperItem* item in arr_observer)
        {
            if (item.target && item.observedPath)
            {
                [item.target removeObserver:observer forKeyPath:item.observedPath];
            }
        }
        [helper.dic_id2object removeObjectForKey:key];
    }
}
@end
