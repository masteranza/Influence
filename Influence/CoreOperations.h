//
//  CoreOperations.h
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Log.h"
@interface CoreOperations : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;

+ (id)sharedManager;
- (void)saveContext;

-(void) removeEvent:(Event*)event;

-(Event*) createEventForParent:(Event*) parent;
-(Log*) log:(int) value withNote:(NSString*) note For:(Event*)event atTime:(NSDate*)date;
@end
