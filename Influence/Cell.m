//
//  NewCell.m
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "Cell.h"
#import "CoreOperations.h"
@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
		int margin =10;
        self.nameField=[[UITextField alloc]initWithFrame:CGRectMake(margin, 10, self.frame.size.width-margin*2, self.frame.size.height-10)];
        self.nameField.autoresizesSubviews=YES;
        self.nameField.placeholder =@"Type name here";
        self.nameField.delegate = self;
        self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.contentView addSubview:self.nameField];
		//txtField.layer.cornerRadius=10.0;
        //[self.txtField setBorderStyle:UITextBorderStyleLine];
		
		self.usedLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width -60, 10, 50, 20)];
		self.usedLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:self.usedLabel];
		
		self.impulse =[[UISegmentedControl alloc] initWithFrame:CGRectMake(self.frame.size.width -60, 30, 50, 20)];

		
        [self setEditMode:NO];
    }
    return self;
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    self.nameField.enabled = editMode;
    if(editMode) [self.nameField becomeFirstResponder];
    else [self.nameField resignFirstResponder];
//    NSLog(@"Set editing on %@ to %@", self.event.name, editMode?@"YES":@"NO");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.event.name  =textField.text;
    [self setEditMode:NO];
    [[CoreOperations sharedManager] saveContext];
    return NO;
}

-(void) setEvent:(Event *)event
{
    _event = event;
    self.nameField.text = event.name;
	self.usedLabel.text = [NSString stringWithFormat:@"(%d)", event.used.intValue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
