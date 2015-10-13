//
//  ViewController.m
//  MeetMeUp
//
//  Created by cory Sturgis on 10/12/15.
//  Copyright © 2015 CorySturgis. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;


@property NSDictionary *events;
@property NSArray *eventArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=477d1928246a4e162252547b766d3c6d"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.events = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.eventArray = [self.events objectForKey:@"results"];
        NSLog(@"%@",self.eventArray);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.eventTableView reloadData];
        });
    }];
    [task resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *event = [self.eventArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [event objectForKey:@"name"];
    cell.detailTextLabel.text = [[event objectForKey:@"venue"] objectForKey:@"address_1"];
    cell.imageView.image = [UIImage imageNamed:@"Meetup_Logo_2015.png"];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController *dvc = segue.destinationViewController;
    NSIndexPath *indexpath = [self.eventTableView indexPathForSelectedRow];
    NSDictionary *event = [self.eventArray objectAtIndex:indexpath.row];
    dvc.event = event;

}

@end
