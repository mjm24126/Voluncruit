//
//  HostEventTwoViewController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEvent.h"


@interface HostEventTwoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)nextClick:(id)sender;
@property IBOutlet UITextField *name;
@property IBOutlet UITextField *phone;
@property IBOutlet UITextField *email;


@end
