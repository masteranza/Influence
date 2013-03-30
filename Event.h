//
//  Event.h
//  Influence
//
//  Created by Michal Mandrysz on 09/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Log;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) Event *parent;
@property (nonatomic, retain) Log *logs;

@end
