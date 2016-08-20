//
//  RWSearchViewController.m
//  RACDemo
//
//  Created by huang-kun on 16/8/12.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "RWSearchViewController.h"
#import "UISearchBar+RACSignalSupport.h"
#import "RWFetcher.h"
#import "RWTweet.h"
#import "RWTableViewCell.h"

@interface RWSearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) RWFetcher *fetcher;
@property (nonatomic, strong) NSArray <RWTweet *> *tweets;
@end

@implementation RWSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 76.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RWTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"RWTableViewCell"];
    
    self.fetcher = [RWFetcher new];
    
    [[[[[[[self.fetcher requestAccessToTwitterSignal]
         then:^RACSignal *{
             @strongify(self)
             return self.searchBar.rac_textSignal;
         }]
         filter:^BOOL(NSString *text) {
             return text.length > 0;
         }]
         throttle:0.5]
         flattenMap:^RACSignal *(NSString *text) {
             @strongify(self)
             return [self.fetcher signalForSearchWithText:text];
         }]
         deliverOn:RACScheduler.mainThreadScheduler]
         subscribeNext:^(NSDictionary *json) {
             @strongify(self)
             [self fillInTweetsFromJSON:json];
         } error:^(NSError *error) {
             @strongify(self)
             [self popError:error];
         }/* completed:^{
             @strongify(self)
             [self.tableView reloadData];
         }*/];
}

- (void)fillInTweetsFromJSON:(NSDictionary *)json {
    NSArray *rawTweets = json[@"statuses"];
    self.tweets = [[rawTweets.rac_sequence map:^RWTweet *(NSDictionary *rawTweet) {
        return [RWTweet tweetWithStatus:rawTweet];
    }] array];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (RWTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RWTableViewCell" forIndexPath:indexPath];
    RWTweet *tweet = self.tweets[indexPath.row];
    cell.twitterUsernameText.text = tweet.username;
    cell.twitterStatusText.text = tweet.status;
    [cell loadAvatarImageWithURL:tweet.profileImageUrl];
    return cell;
}

- (void)popError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[error description]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
