//
//  FeedTableViewController.m
//  InstagramClone
//
//  Created by Jake Holdom on 10/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "FeedTableViewController.h"
#import "Cell.h"
#import <Parse/Parse.h>

@interface FeedTableViewController ()

@end


NSMutableArray *messages;
NSMutableArray *usernames;
NSMutableArray *imageFiles;
NSMutableDictionary *users;




@implementation FeedTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [messages removeAllObjects];
    [imageFiles removeAllObjects];
    [usernames removeAllObjects];
    [users removeAllObjects];
    
    PFQuery *getFollowedUsers = [PFQuery queryWithClassName:@"followers"];
  
    [getFollowedUsers whereKey:@"follower" equalTo:[[PFUser currentUser] objectId]];
    
    [getFollowedUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects.count > 1) {
            
             NSLog(@"This is called 1");
            
            for (PFObject *object in objects) {
                
                
                NSString *followedUser = [object objectForKey:@"following"];

                PFQuery *query = [PFQuery queryWithClassName:@"Post"];
                
                [query whereKey:@"userId" equalTo:followedUser];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                    if (objects.count > 1) {
                        
                        [messages addObject:@"message"];
                        [imageFiles addObject:@"imageFile"];
                        
                        
                        NSLog(@"This is called 2");
                        
                    }
                    
                }];
                
            }
            
        }
        
        // [self performSelector:@selector(reloadAllData) withObject:nil afterDelay:1.0];
    }];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Cell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    myCell.PostedImage.image = [UIImage imageNamed:@"Man-CWC.png"];
    myCell.Username.text = @"User 123";
    myCell.Message.text = @"Message 123";
    
    
    
    // Configure the cell...
    
    return myCell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
