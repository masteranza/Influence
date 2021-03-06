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

-(BOOL) isUnique:(NSString*) taskName andParent:(Event*) parent;
-(Event*) getIfExists:(NSString*)name forParent:(Event*) parent;

-(void) incrementUsedRecursivelyIn:(Event*) event;
-(Event*) createEventForParent:(Event*) parent;
-(Event*) getOrCreateEventNamed:(NSString*)name forParent:(Event*) parent;

-(Log*) log:(int) value withNote:(NSString*) note For:(Event*)event atTime:(NSDate*)date;
-(void) createDefaultList;
-(Event*) createRoot;
@end
