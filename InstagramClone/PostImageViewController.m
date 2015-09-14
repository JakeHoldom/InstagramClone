//
//  PostImageViewController.m
//  InstagramClone
//
//  Created by Jake Holdom on 07/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "PostImageViewController.h"
#import <Parse/Parse.h>

@interface PostImageViewController ()
@property (strong, nonatomic) IBOutlet UITextField *ImageText;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

UIActivityIndicatorView *Activity;


@implementation PostImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)ChooseImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"image did finish picking");
    
    self.imageView.image = image;
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)PostImage:(id)sender {
    
    if (self.ImageText.text == nil || self.imageView.image == nil) {
        NSLog(@"no Image chosen");
    }
    else
    {
    UIView *view = self.view;

    Activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    Activity.backgroundColor = [UIColor blackColor];
    CGRect frame = Activity.frame;
    frame.origin.x = view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = view.frame.size.height / 2 - frame.size.height / 2;
    Activity.frame = frame;
    Activity.hidesWhenStopped = YES;
    [view addSubview:Activity];
    [Activity startAnimating];
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    PFObject *post = [PFObject objectWithClassName:@"Post"];
    
    
    post[@"message"] = self.ImageText.text;
    post[@"userId"] = [[PFUser currentUser] objectId];
    
    NSData *imagetoPost = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    
    PFFile *imagePost = [PFFile fileWithName:@"image.png" data:imagetoPost];
    post[@"imageFile"] = imagePost;
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        
        [Activity stopAnimating];
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        if (error == nil) {
            
            [self displayAlert:@"Image Posted" :@"Your image has been posted successfully"];
            self.imageView.image = [UIImage imageNamed:@"Man-CWC.png"];
          
            self.ImageText.text = @"";
        }
        else{
            
            [self displayAlert:@"Could not post image" :@"Please try again later"];

        }
    }];
}
}

-(void)displayAlert:(NSString *)alerttitle :(NSString *)message{
    
    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:alerttitle message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [Alert show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
