//
//  CommentViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "CommentViewController.h"
#import <Parse/Parse.h>

@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSArray *commentArray;

@end

@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFFile *imageFile = [self.photo objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.imageView.image = [UIImage imageWithData:data];
        }
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *comment = [self.commentArray objectAtIndex:indexPath.row];

    if (!self.commentArray)
    {
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[comment objectForKey:@"user"]objectForKey:@"username"]];
    cell.detailTextLabel.text = [comment objectForKey:@"commentText"];
    }
    else
    {
        cell.textLabel.text = @"Make the first comment";
    }
    return cell;
}

-(void)queryForComments
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"commentPhoto" equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            self.commentArray = [[NSArray alloc]initWithArray:objects];
        }
        [self.tableView reloadData];
    }];
}

- (IBAction)onButtonPressedShareComment:(id)sender
{
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];

    NSString *newComment = self.textView.text;
    [comment setObject:newComment forKey:@"commentText"];
    [comment setObject:[PFUser currentUser] forKey:@"user"];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", error);

        PFRelation *relation = [self.photo relationForKey:@"comments"];
        [relation addObject:comment];
        [self.photo saveInBackground];
    }];
    

    [self.textView resignFirstResponder];
    [self.tableView reloadData];
}

@end
