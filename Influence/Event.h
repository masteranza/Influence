//
//  Event.h
//  Influence
//
//  Created by Michal Mandrysz on 09/05/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Log;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * preset;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * impulse;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) NSSet *logs;
@property (nonatomic, retain) NSSet *parent;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addLogsObject:(Log *)value;
- (void)removeLogsObject:(Log *)value;
- (void)addLogs:(NSSet *)values;
- (void)removeLogs:(NSSet *)values;

- (void)addParentObject:(Event *)value;
- (void)removeParentObject:(Event *)value;
- (void)addParent:(NSSet *)values;
- (void)removeParent:(NSSet *)values;

@end
