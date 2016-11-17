//
//  ABArticlesController.m
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABArticlesController.h"
#import "ABWebViewController.h"
#import "ABServerManager.h"
#import "ABArticlesCell.h"
#import "ABArticle.h"
#import "ABUtils.h"

@interface ABArticlesController ()

@property (strong, nonatomic) NSArray* articlesArray;

@end

@implementation ABArticlesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNewsFromSource];
    
    self.navigationItem.title = self.source.name;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onBackButtonTapped:)];
    self.navigationItem.leftBarButtonItem= backButton;
}

#pragma mark - Action

-(void) onBackButtonTapped:(UIBarButtonItem *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - API

- (void) getNewsFromSource {
    
    [[ABServerManager sharedManager] getNewsFromSourse:self.source.idSource
                                            WithAPIKey:API_KEY
                                               andSort:@"top"
                                             onSuccess:^(NSArray *articles) {
                                                 
                                                 self.articlesArray = articles;
                                                 
                                                 [self.tableView reloadData];
                                                 
                                             } onFailure:^(NSError *error) {
                                                 
                                                 
                                             }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.articlesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"ABArticlesCell";
    
    ABArticlesCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ABArticle* article = self.articlesArray[indexPath.row];
    
    cell.authorLabel.text = article.author;
    cell.dateLabel.text = article.publishedAt;
    cell.textNewsLabel.text = article.text;
    
    
    NSURL* url = [NSURL URLWithString:article.urlToImage];
    [cell.newsImageView pin_setImageFromURL:url];
    
    //for example
    cell.backgroundColor = (indexPath.row % 2) ? [UIColor whiteColor] : [UIColor colorWithWhite:0.95f alpha:1.f];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ABWebViewController* wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABWebViewController"];
    
    wvc.article = self.articlesArray[indexPath.row];
    
    //[self.navigationController pushViewController:wvc animated:YES];
    
    [self presentViewController:wvc animated:YES completion:nil];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ABArticle* article = self.articlesArray[indexPath.row];
    
    return [ABArticlesCell heightForCellWithText:article.text];
}

@end
