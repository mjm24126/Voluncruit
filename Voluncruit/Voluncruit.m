//
//  HostEventFourViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/23/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "HostEventFourViewController.h"

@interface HostEventFourViewController ()

@end

@implementation HostEventFourViewController

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
- (IBAction)createClick:(id)sender {
    // server request
    UIButton *rsvpBtn = (UIButton*) sender;
    NSString *url = [@"http://www.citywhisk.com/scripts/voluncruitHostEvent.php" stringByAppendingString:@"?userid="];
    //url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",appDelegate.userID]];
    //url = [url stringByAppendingString:@"&eventid="];
    //url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",eventID]];
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

@end
