//
//  EventDetailViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/19/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "EventDetailViewController.h"
#import "com_citywhiskAppDelegate.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController {
    com_citywhiskAppDelegate *appDelegate;
}

@synthesize eventName;
@synthesize eventNameLabel;
@synthesize eventDescriptionView;
@synthesize descriptionText;
@synthesize eventAttendees;
@synthesize eventAttendeesLabel;
@synthesize eventType;
@synthesize eventDate;
@synthesize eventDateLabel;
@synthesize eventTypeLabel;
@synthesize eventAddress;
@synthesize eventAddressLabel;
@synthesize detailPic;
@synthesize eventID;

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
    eventNameLabel.text = eventName;
    eventAttendeesLabel.text = [NSString stringWithFormat:@"%@ RSVPS",eventAttendees];
    eventDateLabel.text = eventDate;
    eventTypeLabel.text = eventType;
    eventAddressLabel.text = eventAddress;
    eventDescriptionView.text = descriptionText;
    if([eventType isEqualToString:@"Advocacy"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Advocacy.png"];
    } else if([eventType isEqualToString:@"Awareness"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Awareness.png"];
    } else if([eventType isEqualToString:@"Clean Up"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_CleanUp.png"];
    } else if([eventType isEqualToString:@"Collection"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Collection.png"];
    } else if([eventType isEqualToString:@"Emergency"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Emergency.png"];
    } else if([eventType isEqualToString:@"Environment"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Environment.png"];
    } else if([eventType isEqualToString:@"Homeless"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Homeless.png"];
    } else if([eventType isEqualToString:@"Hungry"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Hungry.png"];
    } else if([eventType isEqualToString:@"Interpret"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Interpret.png"];
    } else if([eventType isEqualToString:@"Manpower"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Manpower.png"];
    } else if([eventType isEqualToString:@"Military"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Military.png"];
    } else if([eventType isEqualToString:@"Support"]){
        detailPic.image =  [UIImage imageNamed: @"DetailDefault_Support.png"];
    }
    detailPic.alpha = .4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (IBAction)openInMaps:(id)sender {
   
    NSString *formattedAddress = [eventAddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    formattedAddress = [@"http://maps.apple.com/?q=" stringByAppendingString:formattedAddress];
    
    NSURL *url = [NSURL URLWithString:formattedAddress];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)saveEvent:(id)sender {
    // server request
    UIButton *saveBtn = (UIButton*) sender;
    NSString *url = [@"http://www.citywhisk.com/scripts/voluncruitSaveEvent.php" stringByAppendingString:@"?userid="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",appDelegate.userID]];
    url = [url stringByAppendingString:@"&eventid="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",eventID]];
    NSLog(@"this is url: %@",url);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Saved it!" message: @"" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if ([data length] >0 && error == nil && [httpResponse statusCode] == 200)
         {
             NSMutableArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"first: %@",dictionary);
             NSDictionary *dict = (NSDictionary*)dictionary;
             NSString *saved = [dict objectForKey:@"savedsuccess"];
             NSLog(@"saved success %@",saved);
         }
         
     }];
}

- (IBAction)rsvpEvent:(id)sender {
    // server request
    UIButton *rsvpBtn = (UIButton*) sender;
    NSString *url = [@"http://www.citywhisk.com/scripts/voluncruitRSVPEvent.php" stringByAppendingString:@"?userid="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",appDelegate.userID]];
    url = [url stringByAppendingString:@"&eventid="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",eventID]];
    NSLog(@"this is url: %@",url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirmation" message: @"You successfully RSVP'ed for this event!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if ([data length] >0 && error == nil && [httpResponse statusCode] == 200)
         {
             NSMutableArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"first: %@",dictionary);
             NSDictionary *dict = (NSDictionary*)dictionary;
             NSString *saved = [dict objectForKey:@"savedsuccess"];
             NSLog(@"saved success %@",saved);
         }
         
     }];
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

@end
