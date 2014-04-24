//
//  com_citywhiskSecondViewController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/18/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@interface com_citywhiskSecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *eventsList;
@property(nonatomic, strong) IBOutlet UITableView *eventsTableView;
@property id<FBGraphUser> fbuser;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) double currentLatitude;
@property (nonatomic, assign) double currentLongitude;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

// for server data
@property (nonatomic, strong) NSMutableData *responseData;

-(IBAction)segmentChangeAction:(id)sender;

@end
