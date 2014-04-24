//
//  com_citywhiskSecondViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/18/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

// segmented control index defs
#define DATE_SORT 0
#define LOC_SORT 1

#import "com_citywhiskSecondViewController.h"
#import "Event.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#import "HostEventOneViewController.h"
#import "ProfileViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface com_citywhiskSecondViewController ()

@end

@implementation com_citywhiskSecondViewController

@synthesize eventsList;
@synthesize eventsTableView;
@synthesize fbuser;
@synthesize locationManager;
@synthesize currentLatitude;
@synthesize currentLongitude;
@synthesize responseData;
@synthesize segControl;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    eventsList = [[NSMutableArray alloc] init];
    
    // location listening
    // user location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    
    // server request
    NSString *post = [NSString stringWithFormat:@"lat=%f&lon=%f&fbid=%@",currentLatitude, currentLongitude ,fbuser];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.citywhisk.com/scripts/voluncruit.php"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if ([data length] >0 && error == nil && [httpResponse statusCode] == 200)
         {
             NSMutableArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"%@",[NSNumber numberWithInt:[dictionary count]]);
             NSDictionary *dict = (NSDictionary*)dictionary;
             //NSLog(@"%@",[[dict objectForKey:@"events"] objectAtIndex:0]); --- gets one event entry
             NSLog(@"%@",[[[dict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"Address"]);
             for( int i=0; i<[dictionary count]+1; i++){
                 Event *event = [[Event alloc] init];
                 NSDictionary *anEvent = [[dict objectForKey:@"events"] objectAtIndex:i];
                 NSLog(@"%d",anEvent.count);
                 event.eid = [[anEvent objectForKey:@"EventID"] intValue];
                 event.name = [anEvent objectForKey:@"Name"];
                 event.address = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"events"] objectAtIndex:i] objectForKey:@"Address"]];
                 event.date = [anEvent objectForKey:@"Date"];
                 event.description = [anEvent objectForKey:@"Description"];
                 event.time = [anEvent objectForKey:@"Start"];
                 event.serviceType = [anEvent objectForKey:@"TypeName"];
                 event.servicetypeid =[anEvent objectForKey:@"TypeID"];
                 event.latitude = [[anEvent objectForKey:@"Latitude"] floatValue];
                 event.longitude = [[anEvent objectForKey:@"Longitude"] floatValue];
                 [self.eventsList addObject:event];
             }
             [self sortEvents:eventsList by:@"date"];
             eventsTableView.dataSource = self;
             eventsTableView.delegate = self;
             [eventsTableView reloadData];
             
             
             [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
             self.segControl.selectedSegmentIndex = 0;
         }
         
     }];
    
    
    
    
    // ui related
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkTextColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // no searching yet
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
    self.navigationItem.backBarButtonItem.enabled = NO;
    
    
    eventsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImage *image = [UIImage imageNamed:@"logoheader.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    btnAdd.frame = CGRectMake(0, 0, 22, 22);
    btnAdd.showsTouchWhenHighlighted=YES;
    [btnAdd addTarget:self action:@selector(onHostEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    
    UIButton *btnProf = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnProf setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    btnProf.frame = CGRectMake(0, 0, 22, 22);
    btnProf.showsTouchWhenHighlighted=YES;
    [btnProf addTarget:self action:@selector(onShowProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnProf];

    [arrRightBarItems addObject:barButtonItem1];
    [arrRightBarItems addObject:barButtonItem2];
    self.navigationItem.rightBarButtonItems=arrRightBarItems;

    [self sortEvents:eventsList by:@"date"];
}

-(void)updateTable{
    [self.eventsTableView reloadData];
}

-(IBAction)onHostEvent:(id)sender
{
    [self performSegueWithIdentifier:@"GoToHost" sender:sender];
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HostEventOneViewController *viewController = (HostEventOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HostNavController"];
    [self presentViewController:viewController animated:YES completion:nil];*/
}

-(IBAction)onShowProfile:(id)sender
{
    [self performSegueWithIdentifier:@"GoToProfile" sender:sender];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDataSource protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row called");
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolunteerEventCell"];
    
    // Configure the cell...
    Event *event = (self.eventsList)[indexPath.row];
    
    cell.nameLabel.text = event.name;
    cell.dateLabel.text = event.date;
    cell.locationLabel.text = event.address;
    cell.eventIcon.image = [UIImage imageNamed:@"32icon"];
    NSLog(@"%@",event.servicetypeid);
    if([event.serviceType isEqualToString:@"Advocacy"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Advocacy.png"];
    } else if([event.serviceType isEqualToString:@"Awareness"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Awareness.png"];
    } else if([event.serviceType isEqualToString:@"Clean Up"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_CleanUp.png"];
    } else if([event.serviceType isEqualToString:@"Collection"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Collection.png"];
    } else if([event.serviceType isEqualToString:@"Emergency"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Emergency.png"];
    } else if([event.serviceType isEqualToString:@"Environment"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Environment.png"];
    } else if([event.serviceType isEqualToString:@"Homeless"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Homeless.png"];
    } else if([event.serviceType isEqualToString:@"Hungry"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Hungry.png"];
    } else if([event.serviceType isEqualToString:@"Interpret"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Interpret.png"];
    } else if([event.serviceType isEqualToString:@"Manpower"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Manpower.png"];
    } else if([event.serviceType isEqualToString:@"Military"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Military.png"];
    } else if([event.serviceType isEqualToString:@"Support"]){
        cell.eventIcon.image =  [UIImage imageNamed: @"Icon_Support.png"];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showEventDetail"]){
        
        NSIndexPath *indexPath = [self.eventsTableView indexPathForSelectedRow];
        EventDetailViewController *destViewController = segue.destinationViewController;
        Event *e = [eventsList objectAtIndex:indexPath.row];
        destViewController.eventName = e.name;
        destViewController.eventDate = e.date;
        destViewController.eventAddress = e.address;
        //destViewController.eventDate = @"April 20, 5:30 PM";
        destViewController.eventType = e.serviceType;
        destViewController.eventAttendees = [NSString stringWithFormat:@"%d",e.attendees];
        destViewController.descriptionText = e.description;
        destViewController.eventID = e.eid;
    }
    if([segue.identifier isEqualToString:@"GoToProfile"]){
        ProfileViewController *destViewController = segue.destinationViewController;
        destViewController.fbuser = fbuser;
    }
}

/*
 * Sorts an array by date or by location based on parameter passed
 */
-(void)sortEvents:(NSMutableArray *)list by:(NSString *)criteria{
    for( int i=0; i<eventsList.count; i++){
        Event *e = list[i];
        NSLog(@"%@ is %f from you",[e name],e.distance);
    }
    NSSortDescriptor *sortDescriptor;
    if( [criteria  isEqual: @"date"] ){
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                     ascending:YES];
        [list sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [eventsTableView reloadData];
        NSLog(@"date sort...");
    }
    else if( [criteria  isEqual: @"location"] ){
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              currentLatitude,
              currentLongitude);
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongitude];
        NSMutableArray *newArrayWithDists = [[NSMutableArray alloc] init];
        for( int i=0; i<list.count; i++ ){
            Event *e = list[i];
            CLLocation *eventLoc = [[CLLocation alloc] initWithLatitude:e.latitude longitude:e.longitude];
            e.distance = [currentLocation distanceFromLocation:eventLoc];
            [newArrayWithDists addObject:e];
        }
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                     ascending:YES];
        [list sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//        [locationManager stopUpdatingLocation];
        NSLog(@"loc sort...");
    }
    for( int i=0; i<eventsList.count; i++){
        Event *e = list[i];
        NSLog(@"%@ lat: %f lon: %f",[e name],e.latitude,e.longitude);
    }
}


// Delegate method from the CLLocationManagerDelegate protocol.
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitudeString = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    currentLatitude = newLocation.coordinate.latitude;
    
    NSString *currentLongitudeString = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    currentLongitude = newLocation.coordinate.longitude;
    
    NSLog(@"lat: %@, lon: %@",currentLatitudeString,currentLongitudeString);
}

-(IBAction)segmentChangeAction:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    if( seg.selectedSegmentIndex == DATE_SORT ){
        [self sortEvents:eventsList by:@"date"];
        [self.eventsTableView reloadData];
    }
    if( seg.selectedSegmentIndex == LOC_SORT ){
        [self sortEvents:eventsList by:@"location"];
        [self.eventsTableView reloadData];
    }
}

@end
