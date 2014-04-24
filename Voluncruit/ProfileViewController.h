//
//  ProfileViewController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property IBOutlet UILabel *nameLabel;
@property id<FBGraphUser> fbuser;
- (IBAction)popToRoot:(id)sender;

@end
