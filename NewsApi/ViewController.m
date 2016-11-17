//
//  ViewController.m
//  NewsApi
//
//  Created by Alexandr Bondar on 15.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ViewController.h"
#import "ABServerManager.h"
#import "ABSourceCell.h"
#import "ABSource.h"
#import "ABArticlesController.h"



@interface ViewController ()

@property (strong, nonatomic) NSArray* sourcesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getSoursesFromServer];
    
}

#pragma mark - API

- (void) getSoursesFromServer {
    
    [[ABServerManager sharedManager] getSoursesFromServerForCategory:@"entertainment"
                                                        withLanguage:@"en"
                                                          andCountry:@""
                                                           onSuccess:^(NSArray *sourses) {
                                                               
                                                               self.sourcesArray = sourses;
                                                               
                                                               [self.tableView reloadData];
                                                               
                                                           }
                                                           onFailure:^(NSError *error) {
                                                               
                                                               NSLog(@"Error - getSoursesFromServer - %@", [error localizedDescription]);
                                                           }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.sourcesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"ABSourceCell";
    
    ABSourceCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ABSource* source = self.sourcesArray[indexPath.row];
    
    cell.nameSourceLabel.text = source.name;
        
    NSURL* url = [NSURL URLWithString:source.urlsToLogos.small];
    [cell.logoImageView pin_setImageFromURL:url];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ABArticlesController* articlesController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABArticlesController"];
    
    articlesController.source = self.sourcesArray[indexPath.row];
    
    [self.navigationController pushViewController:articlesController animated:YES];
    
        
    }
    



@end
