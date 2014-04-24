//
//  HostEventOneViewController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/20/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEvent.h"

@interface HostEventOneViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *tableView;
@property IBOutlet UITextView *activeField;
- (IBAction)popToRoot:(id)sender;
- (IBAction)nextClick:(id)sender;
@property IBOutlet UITextField *eventName;
@property IBOutlet UITextField *eventAddress;
@property IBOutlet UITextView *eventDescription;
@property IBOutlet UIDatePicker *eventDate;
@property IBOutlet UIDatePicker *eventTime;

@end
