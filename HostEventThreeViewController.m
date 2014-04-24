//
//  HostEventThreeViewController.m
//  Voluncruit
//
//  Created by Marissa McDowell on 4/21/14.
//  Copyright (c) 2014 CityWhisk. All rights reserved.
//

#import "HostEventThreeViewController.h"
#import "SwitchCell.h"

#define GENERAL_ROW         0
#define AGE_ROW             1
#define BACKGROUND_ROW      2
#define PHYSICAL_ROW        3
#define LANGUAGE_ROW        4
#define SKILLS_ROW          5

@interface HostEventThreeViewController ()

@property (nonatomic, strong) NSArray *switchDataArray;
@property (nonatomic, strong) NSMutableArray *switches;
@property (nonatomic, assign) int tagNum;

@end

@implementation HostEventThreeViewController

@synthesize tableView;
@synthesize switches;
@synthesize switchDataArray;
@synthesize tagNum;

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
    switches = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1], nil];
    
    // set up requirements data
    NSMutableArray *gen = [NSMutableArray arrayWithObjects:@"General Requirements",@"Valid Driver's License",@"First Aid Certification", nil];
    NSMutableArray *age = [NSMutableArray arrayWithObjects:@"Age Requirements",@"18 and over",@"13 and over",@"Guardian Required", nil];
    NSMutableArray *bground = [NSMutableArray arrayWithObjects:@"Background Requirements",@"No Criminal Background", nil];
    NSMutableArray *phys = [NSMutableArray arrayWithObjects:@"Physical Requirements",@"Light Lifting",@"Heavy Lifting",@"Low Physical Exertiion", @"High Physical Exertion",@"Uncorrected Eyesignt",@"Unaided Hearing", nil];
    NSMutableArray *language = [NSMutableArray arrayWithObjects:@"Language Requirements",
                                @"Arabic",
                                @"Chinese",
                                @"French",
                                @"French Creole",
                                @"German",
                                @"Hindi",
                                @"Italian",
                                @"Japanese",
                                @"Korean",
                                @"Polish",
                                @"Portuguese",
                                @"Russian",
                                @"Sign Language",
                                @"Spanish",
                                @"Tagalog",
                                @"Vietnamese",
                                nil];
    NSMutableArray *skill = [NSMutableArray arrayWithObjects:@"Skills Requirements",
                                @"Accounting",
                                @"Advocacy/Lobbying",
                                @"Beautician/ Cosmetology",
                                @"Blogging",
                                @"Carpentry",
                                @"Clerical",
                                @"Coaching/Sports",
                                @"Communications",
                                @"Community Organizing",
                                @"Computer Programming",
                                @"Cooking/Nutrition",
                                @"Copywriting/Web Text",
                                @"Crafting",
                                @"Creative Writing",
                                @"Dance",
                                @"Data Analysis/ Statistics",
                                @"Database Design/Mgmt",
                                @"Docent/Leading Tours",
                                @"Editing",
                                @"Electrical",
                                @"Engineering",
                                @"Event Planning",
                                @"Financial Planning/ Mgmt",
                                @"Foreign Languages",
                                @"Fundraising",
                                @"Gardening",
                                @"Grant Writing",
                                @"Graphic Design",
                                @"Hand/Power Tools",
                                @"Health/Medical Experience",
                                @"Illustration",
                                @"IT Experience",
                                @"Journalism",
                                @"Landscaping",
                                @"Leadership/Mgmt",
                                @"Legal/Law Experience",
                                @"Legislation/Policy",
                                @"Library Science",
                                @"Map Reading",
                                @"Marketing/Public Relations",
                                @"Masonry",
                                @"Mediation/Conflict Resolution",
                                @"Mentoring/Tutoring",
                                @"Musical Arts",
                                @"Outdoor Activities",
                                @"Photography",
                                @"Plumbing",
                                @"Podcasting",
                                @"Problem Solving",
                                @"Public Speaking",
                                @"Research",
                                @"Sales/Retail Experience",
                                @"Sign Language",
                                @"Social Media/ Networking",
                                @"Software Development",
                                @"Strategic Planning",
                                @"Teaching",
                                @"Telephone Skills",
                                @"Theater Arts",
                                @"Translation",
                                @"Videography",
                                @"Visual Arts (Drawing, painting, etc.)",
                                @"Volunteer Management",
                                @"Web Development",
                                nil];
    self.switchDataArray = @[gen,age, bground, phys, language, skill];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDataSource protocol methods



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[switches objectAtIndex:section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *cell = [atableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    [cell.headerSwitch addTarget:self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
    cell.textLabel.text = switchDataArray[indexPath.section][indexPath.row];
    
    // set tags
    if( indexPath.row == 0 ){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        switch( indexPath.section ){
            case GENERAL_ROW:
                cell.headerSwitch.tag = GENERAL_ROW;
                break;
            case AGE_ROW:
                cell.headerSwitch.tag = AGE_ROW;
                break;
            case BACKGROUND_ROW:
                cell.headerSwitch.tag = BACKGROUND_ROW;
                break;
            case PHYSICAL_ROW:
                cell.headerSwitch.tag = PHYSICAL_ROW;
                break;
            case LANGUAGE_ROW:
                cell.headerSwitch.tag = LANGUAGE_ROW;
                break;
            case SKILLS_ROW:
                cell.headerSwitch.tag = SKILLS_ROW;
                break;
        }
    }
    
    return cell;
}

- (IBAction)flip:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    switch( onoff.tag ){
        case GENERAL_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:3] atIndexedSubscript:GENERAL_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:GENERAL_ROW];
            break;
        case AGE_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:4] atIndexedSubscript:AGE_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:AGE_ROW];
            break;
        case BACKGROUND_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:2] atIndexedSubscript:BACKGROUND_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:BACKGROUND_ROW];
            break;
        case PHYSICAL_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:7] atIndexedSubscript:PHYSICAL_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:PHYSICAL_ROW];
            break;
        case LANGUAGE_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:17] atIndexedSubscript:LANGUAGE_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:LANGUAGE_ROW];
            break;
        case SKILLS_ROW:
            if( onoff.on)
                [switches setObject:[NSNumber numberWithInteger:65] atIndexedSubscript:SKILLS_ROW];
            else
                [switches setObject:[NSNumber numberWithInteger:1] atIndexedSubscript:SKILLS_ROW];
            break;
    }
    [tableView reloadData];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    Region *region = [regions objectAtIndex:section];
    return [region name];
}*/


// Delegate methods for table
- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)nextClick:(id)sender {
    NSMutableArray *reqs = [[NSMutableArray alloc] init];
    NSArray *cells = [tableView visibleCells];
    for( int i=0;i<cells.count; i++){
        SwitchCell *sc = [cells objectAtIndex:i];
        if( sc.headerSwitch.isEnabled ){
            [reqs addObject:sc.headerLabel.text];
        }
    }
    
}

@end
