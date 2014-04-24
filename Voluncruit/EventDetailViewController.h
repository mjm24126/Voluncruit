//
//  EventDetailViewController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/19/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventDateLabel;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) IBOutlet UILabel *eventTypeLabel;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) IBOutlet UILabel *eventAttendeesLabel;
@property (nonatomic, strong) NSString *eventAttendees;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) IBOutlet UITextView *eventDescriptionView;
@property (nonatomic, strong) NSString *eventAddress;
@property (nonatomic, strong) IBOutlet UILabel *eventAddressLabel;
@property (nonatomic, strong) IBOutlet UIImageView *detailPic;
@property (nonatomic, assign) int eventID;
- (IBAction)openInMaps:(id)sender;
- (IBAction)saveEvent:(id)sender;
@end
