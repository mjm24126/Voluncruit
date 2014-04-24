//
//  EventCell.h
//  Voluncruit
//
//  Created by Marissa McDowell on 4/18/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *eventIcon;

@end
