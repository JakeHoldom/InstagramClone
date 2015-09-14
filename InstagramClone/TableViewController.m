//
//  TableViewController.m
//  InstagramClone
//
//  Created by Jake Holdom on 05/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "TableViewController.h"


@interface TableViewController ()

@end

NSMutableArray *Username;
NSMutableArray *userIDs;
NSMutableDictionary *isFollowing;
UIRefreshControl *refresher;

@implementation TableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
  
    userIDs = [[NSMutableArray alloc]init];
    Username = [[NSMutableArray alloc]init];
    isFollowing = [[NSMutableDictionary alloc]init];
    refresher = [[UIRefreshControl alloc]init];
    
    
    refresher.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refresher addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresher];
    [self refreshData];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)refreshData{
    
    [userIDs removeAllObjects];
    [Username removeAllObjects];
    [isFollowing removeAllObjects];
    
    NSLog(@"refreshed");
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (!error) {
            
            for (PFObject *object in objects) {
                
                if (object.objectId != currentUser.objectId) {
                    
                    NSString *userid = object.objectId;
                    NSString *usernames = [object objectForKey:@"username"];
                    NSLog(@"%@", usernames);
                    [userIDs addObject:userid];
                    [Username addObject:usernames];
                    
                    
                    PFQuery *query2 = [PFQuery queryWithClassName:@"followers"];
                    
                    [query2 whereKey:@"follower" equalTo:currentUser.objectId];
                    [query2 whereKey:@"following" equalTo:object.objectId];
                    
                    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                        if (objects.count == 0) {
                            NSLog(@"%@", isFollowing);
                            
                            [isFollowing setValue:[NSNumber numberWithBool:YES] forKey:object.objectId];
                            // isFollowing[object.objectId] = YES;
                            // The find succeeded.
                            // Do something with the found objects
                            NSLog(@"array is %@", isFollowing);
                        }
                        else {
                            [isFollowing setValue:[NSNumber numberWithBool:NO] forKey:object.objectId];
                            
                            NSLog(@"YES is called");
                            
                        }
                        
                        if (isFollowing.count == Username.count) {

                        }
                        [self.tableView reloadData];

                        [refresher endRefreshing];

                        // [self performSelector:@selector(reloadAllData) withObject:nil afterDelay:1.0];
                    }];
                }
                
                
                
            }
        }
        
        // NSLog(@"userIDs = %@", userIDs);
        // NSLog(@"usernames = %@", Username);
        
        
        
    }];
    
    
    
}

-(void)reloadAllData{
    
    [self.tableView reloadData];

    NSLog(@"isFollowing = %@", isFollowing);

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
    return Username.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = Username[indexPath.row];
    // Configure the cell...
    
   // BOOL showCheckmark = [[isFollowing objectAtIndex:indexPath.row] boolValue];

    
    NSMutableArray *followedObjectId = userIDs[indexPath.row];
    

    NSLog(@"isfollow followed object id = %@", isFollowing[followedObjectId]);
   // NSLog(@"the checkmark value is %d", showCheckmark);
    if ([isFollowing[followedObjectId] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        
        NSLog(@"checkmark called");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSMutableArray *followedObjectId = userIDs[indexPath.row];

    if ([isFollowing[followedObjectId] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        
        isFollowing[followedObjectId] = [NSNumber numberWithBool:NO];
    
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    PFObject *following = [PFObject objectWithClassName:@"followers"];
    
    following[@"following"] = userIDs[indexPath.row];
    
    following[@"follower"] = [[PFUser currentUser] objectId];
    
    [following saveInBackground];
    }
    
    else{
        
        isFollowing[followedObjectId] = [NSNumber numberWithBool:YES];

        
        cell.accessoryType = UITableViewCellAccessoryNone;
        PFQuery *query2 = [PFQuery queryWithClassName:@"followers"];
        
        [query2 whereKey:@"follower" equalTo:[[PFUser currentUser]objectId]];
        [query2 whereKey:@"following" equalTo:userIDs[indexPath.row]];
        
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            NSLog(@"the count on deleted is %lu", (unsigned long)objects.count);
            if (objects.count == 1) {
                
                for (PFObject *object in objects) {
                    
                    
                    [object deleteInBackground];
                    
                }
                
            }

            // [self performSelector:@selector(reloadAllData) withObject:nil afterDelay:1.0];
        }];


        
        
    }
    
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
