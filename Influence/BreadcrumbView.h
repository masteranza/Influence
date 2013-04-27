//
//  BreadcrumbView.h
//  Influence
//
//  Created by Blazej Stanek on 27.04.2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol BreadcrumbDelegate <NSObject>

-(void)scrollToPage:(int)page;

@end

@interface BreadcrumbView : UIView

@property (nonatomic, weak) id<BreadcrumbDelegate> delegate;

-(void)showEventStack:(NSArray*)parentStack;

@end
