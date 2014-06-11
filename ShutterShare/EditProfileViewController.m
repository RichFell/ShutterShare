//
//  EditProfileViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/10/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "EditProfileViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "User.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;

@end

@implementation EditProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[PFUser currentUser] objectForKey:@"profilePic"]) {
        PFFile *pffile = [[PFUser currentUser] objectForKey:@"profilePic"];
        [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.imageView.image = [UIImage imageWithData:data];
            self.imageView.layer.cornerRadius = 50.0f;
            self.imageView.clipsToBounds = YES;
        }];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"bear"];
        self.imageView.layer.cornerRadius = 50.0f;
        self.imageView.clipsToBounds = YES;
    }

    self.nameTextField.text = [[PFUser currentUser] objectForKey:@"name"];
    self.emailTextField.text = [[PFUser currentUser] objectForKey:@"email"];
    self.emailTextField.text = [[PFUser currentUser] objectForKey:@"website"];
    self.telephoneTextField.text = [[PFUser currentUser] objectForKey:@"telephone"];

    self.nameTextField.borderStyle = UITextBorderStyleLine;
    self.emailTextField.borderStyle = UITextBorderStyleLine;
    self.websiteTextField.borderStyle = UITextBorderStyleLine;
    self.telephoneTextField.borderStyle = UITextBorderStyleLine;


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)onEditPhotoButtonPressed:(id)sender
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerController.sourceType];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (IBAction)onSaveButtonPressed:(id)sender
{
    [[PFUser currentUser] setObject:self.nameTextField.text forKey:@"name"];
    [[PFUser currentUser] setObject:self.emailTextField.text forKey:@"email"];
    [[PFUser currentUser] setObject:self.websiteTextField.text forKey:@"website"];
    [[PFUser currentUser] setObject:self.telephoneTextField.text forKey:@"telephone"];


    Photo *photo = [Photo objectWithClassName:@"Photo"];
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    PFFile *photoFile = [PFFile fileWithData:imageData];

    [[PFUser currentUser] setObject:photoFile forKey:@"profilePic"];
    [photo setObject:[PFUser currentUser] forKey:@"user"];

    [photo saveInBackground];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
