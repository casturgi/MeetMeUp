//
//  DetailViewController.m
//  MeetMeUp
//
//  Created by cory Sturgis on 10/12/15.
//  Copyright © 2015 CorySturgis. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCount;
@property (weak, nonatomic) IBOutlet UILabel *hostingGroupInfo;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.eventName.text = [self.event objectForKey:@"name"];
    self.rsvpCount.text = [NSString stringWithFormat:@"%@",[self.event objectForKey:@"yes_rsvp_count"]];

    self.hostingGroupInfo.text = [[self.event objectForKey:@"group"] objectForKey:@"name"];

    self.eventDescription.text = [self.event objectForKey:@"description"];
    self.eventDescription.userInteractionEnabled = NO;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *dvc = segue.destinationViewController;
    dvc.event = self.event;
}
@end
