//
//  ViewController.m
//  InstagramClone
//
//  Created by Jake Holdom on 03/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *Username;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UILabel *registered;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;

@end

BOOL signupActive = true;
UIActivityIndicatorView *activity;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)signUp:(id)sender {
    
    if (self.Username.text.length == 0 || self.Password.text.length == 0) {
        [self displayAlert:@"Error" : @"Please enter a username and password"];
   
    }
    else {
        UIView *view = self.view;
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = CGRectMake(0, 0, 50, 50);
        activity.frame = frame;
        activity.center = self.view.center;
        [view addSubview:activity];
        [activity startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        
        PFUser *user = [PFUser user];
        user.username = self.Username.text;
        user.password = self.Password.text;
        
        if (signupActive == true) {
            
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [activity stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (!error) {
                

                // Hooray! Let them use the app now.
            } else {
                
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                [self displayAlert:@"Failed SignUp" : errorString];
                
            }
        
        }];
        }
        else{
            
            [PFUser logInWithUsernameInBackground:self.Username.text password:self.Password.text
                                            block:^(PFUser *user, NSError *error) {
                                                [activity stopAnimating];
                                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                                if (user) {
                                                    
                                                    [self performSegueWithIdentifier:@"login" sender:self];

                                                    NSLog(@"Logged in");
                                                } else {
                                                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                                                    [self displayAlert:@"Failed SignUp" : errorString];// The login failed. Check error to see why.
                                                }
                                            }];
        }
    }
    
}

- (void) displayAlert:(NSString *)title :(NSString *)message{
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([PFUser currentUser] != nil) {
        
        [self performSegueWithIdentifier:@"login" sender:self];
        
    }
    
}
- (IBAction)logIn:(id)sender {
    
    if (signupActive == true) {
        [self.signUpButton setTitle:@"Log In" forState:UIControlStateNormal];
        
        self.registered.text = @"Not Registered?";
        
        [self.logInButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        
        signupActive = false;
        
        
    }
    else{
        [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        
        self.registered.text = @"Already Registered?";
        
        [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
        
        signupActive = true;
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
