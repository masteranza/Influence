//
//  NewCell.h
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface Cell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic,assign) Event* event;
@property (nonatomic, retain) UITextField *txtField;
@property (nonatomic, assign) BOOL editMode;

@end
