//
//  ObserverHelper.h
//
//  Created by RentonTheUncoped on 15/4/8.
//

#import <Foundation/Foundation.h>

@interface ObserverHelper : NSObject

+ (void)addObservedObject:(id)object observer:(id)observer keyPath:(NSString*)path;
+ (void)removeObserverForObject:(id)object;
+ (void)removeObservedObjectForObserver:(id)observer;
@end
