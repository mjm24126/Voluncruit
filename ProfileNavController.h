//
//  ProfileNavController.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileNavController : UINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withName:(NSString *)name  andPicture:(FBProfilePictureView *)pic;

@property NSString *name;
@property (strong, nonatomic) FBProfilePictureView *profilePictureView;

@end
