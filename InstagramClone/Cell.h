//
//  Cell.h
//  InstagramClone
//
//  Created by Jake Holdom on 10/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *PostedImage;
@property (strong, nonatomic) IBOutlet UILabel *Username;
@property (strong, nonatomic) IBOutlet UILabel *Message;

@end
