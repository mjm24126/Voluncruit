//
//  HostEventOneViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/20/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "HostEventOneViewController.h"
#import "HostEventTwoViewController.h"
#import "HostTwoCell.h"

#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     2
#define NAME_TAG 45
#define DATE_TAG 46
#define TIME_TAG 47
#define ADDRESS_TAG 48
#define DESC_TAG 49

@interface HostEventOneViewController ()

@property (nonatomic, strong) NSArray *firstFormDataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@property (nonatomic, strong) IBOutlet UITextField *textField;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;

@end

@implementation HostEventOneViewController{
    NewEvent *newEvent;
}
@synthesize textField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    newEvent = [[NewEvent alloc] init];
    // setup our data source
    NSMutableDictionary *itemOne = [@{ @"title" : @"Name",
                                       @"placeholder" : @"Name Your Mission"} mutableCopy];
    NSMutableDictionary *itemTwo = [@{ @"title" : @"Date",
                                       @"date" : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemThree = [@{ @"title" : @"Time",
                                         @"date" : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemFour = [@{ @"title" : @"Address",
                                        @"placeholder" : @"Where's it happening?"} mutableCopy];
    NSMutableDictionary *itemFive = [@{ @"title" : @"Description"} mutableCopy];
    self.firstFormDataArray = @[itemOne, itemTwo, itemThree, itemFour, itemFive];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateStyle:NSDateFormatterNoStyle];    // show short-style date format
    [self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)


#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.firstFormDataArray.count;
        return ++numRows;
    }
    
    return self.firstFormDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    NSString *cellID = @"TextFieldCell";
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = @"DatePickerCell";     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = @"DateCell";       // the date or time cells
    }
    else if (indexPath.row == 4){
        cellID = @"DescriptionCell";
    }
    
    cell = [atableView dequeueReusableCellWithIdentifier:cellID];
    
    
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = self.firstFormDataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:@"DateCell"])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.textLabel.text = [itemData valueForKey:@"title"];
        if( [cell.textLabel.text isEqualToString:@"Date"] ){
            cell.tag = DATE_TAG;
        }
        if( [cell.textLabel.text isEqualToString:@"Name"] ){
            cell.tag = TIME_TAG;
        }
        if( indexPath.row == 1 ){
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:@"date"]];
        }
        else if( indexPath.row == 2 ){
            cell.detailTextLabel.text = [self.timeFormatter stringFromDate:[itemData valueForKey:@"date"]];
        }
//        cell.detailTextLabel.text = @"";
        
    }
    else if ([cellID isEqualToString:@"TextFieldCell"])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        cell.textLabel.text = [itemData valueForKey:@"title"];
        ((HostTwoCell *)cell).textField.placeholder = [itemData valueForKey:@"placeholder"];
        if( [cell.textLabel.text isEqualToString:@"Name"] ){
            cell.tag = NAME_TAG;
        }
        if( [cell.textLabel.text isEqualToString:@"Address"] ){
            cell.tag = ADDRESS_TAG;
        }
    }
    else{
        if( [cell.textLabel.text isEqualToString:@"Description"] ){
            cell.tag = DESC_TAG;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self indexPathHasPicker:indexPath]){
        return self.pickerCellRowHeight;
    }
    else if( indexPath.row == 4 ){
        return 120;
    }
    return self.tableView.rowHeight;
}


/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if( self.datePickerIndexPath.row == 3){
            [targetedDatePicker setDatePickerMode:UIDatePickerModeTime];
        }else if(self.datePickerIndexPath.row == 2){
            [targetedDatePicker setDatePickerMode:UIDatePickerModeDate];
        }
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.firstFormDataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:@"date"] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}



/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.firstFormDataArray[indexPath.row];
    if( indexPath.row == kDateStartRow ) {
        [self.pickerView setDate:[itemData valueForKey:@"date"] animated:YES];
    }
    else{
        //[self.pickerView setDatePickerMode:UIDatePickerModeTime];
        [self.pickerView setDate:[itemData valueForKey:@"date"] animated:YES];
    }
    
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        if( indexPath.row == 3 ){
            [self.pickerView setDatePickerMode:UIDatePickerModeTime];
        }
        else if ( indexPath.row == 2 ){
            [self.pickerView setDatePickerMode:UIDatePickerModeDate];
        }
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
//                             self.navigationItem.rightBarButtonItem = self.nextButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [atableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier  isEqual: @"DateCell"])
    {
        if (EMBEDDED_DATE_PICKER)
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        else {
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
            NSDictionary *itemData = self.firstFormDataArray[indexPath.row];
        }
    }
    else
    {
        [atableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.firstFormDataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:@"date"];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button, (used only for non-inline date picker), iOS 6.1.x or earlier
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// handling keyboard covering text fields
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (IBAction)popToRoot:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nextClick:(id)sender {
    NSString *name = [(UITextField *)[self.view viewWithTag:NAME_TAG] text];
    NSString *address = [(UITextField *)[self.view viewWithTag:ADDRESS_TAG] text];
    NSString *desc = [(UITextView *)[self.view viewWithTag:DESC_TAG] text];
//    NSDate *date = [(UIDatePicker *)[self.view viewWithTag:DATE_TAG] date];
  //  NSDate *time = [(UIDatePicker *)[self.view viewWithTag:TIME_TAG] date];
    
    // check its all filled out
    if ( !([name isEqual:NULL]) && !([address isEqual:NULL]) && !([desc isEqual:NULL]) ){
        [self performSegueWithIdentifier:@"MoveToHostTwo" sender:sender];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops" message: @"Fill out all the files before continuing." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    newEvent.eventName = name;
    newEvent.eventAddress = address;
    newEvent.eventDescription = desc;
    //newEvent.eventDate = [(UIDatePicker *)[self.view viewWithTag:DATE_TAG] date];
    //newEvent.eventTime = [(UIDatePicker *)[self.view viewWithTag:DATE_TAG] date];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    HostEventTwoViewController *destViewController = segue.destinationViewController;
    //destViewController.newEvent = newEvent;
}


@end
