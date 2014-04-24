//
//  HostEventTwoViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "HostEventTwoViewController.h"
#import "HostEventThreeViewController.h"
#import "HostTwoCell.h"
#import "NewEvent.h"

#define NAME_TAG 55
#define PHONE_TAG 56
#define EMAIL_TAG 57

@interface HostEventTwoViewController ()

@end

@implementation HostEventTwoViewController{
    NewEvent *newEvent;
}
@synthesize tableView;
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDataSource protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HostTwoCell *cell = [atableView dequeueReusableCellWithIdentifier:@"HostFormCell"];
    cell.textField.placeholder = @"testing";
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Host Name";
            cell.tag = NAME_TAG;
            break;
        case 1:
            cell.textLabel.text = @"Phone Number";
            cell.tag = PHONE_TAG;
            break;
        case 2:
            cell.textLabel.text = @"Host Email";
            cell.tag = EMAIL_TAG;
            break;
        default:
            break;
    }
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    HostEventThreeViewController *destViewController = segue.destinationViewController;
    //destViewController.newEvent = newEvent;
}

- (IBAction)nextClick:(id)sender {
    NSString *name = [(UITextField *)[self.view viewWithTag:NAME_TAG] text];
    NSString *phone = [(UITextField *)[self.view viewWithTag:PHONE_TAG] text];
    NSString *email = [(UITextView *)[self.view viewWithTag:EMAIL_TAG] text];
    
    // check its all filled out
    if ( !([name isEqual:@""]) && !([phone isEqual:@""]) && !([email isEqual:@""]) ){
        [self performSegueWithIdentifier:@"MoveToHostThree" sender:sender];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops" message: @"Fill out all the files before continuing." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    newEvent.hostEmail = email;
    newEvent.hostName = name;
    newEvent.eventPhone = phone;
}

@end
