//
//  CameraViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "CameraViewController.h"
#import "Photo.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *imagePickerController;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        NSLog(@"camera");
    }
    else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSLog(@"photo library");
    }
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerController.sourceType];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (IBAction)onButtonPressedSaveImage:(id)sender
{
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    Photo *photo = [Photo objectWithClassName:@"Photo"];
    PFFile *photoFile = [PFFile fileWithData:imageData];
    NSString *caption = self.textView.text;
    [photo setObject:photoFile forKey:@"image"];
    [photo setObject:[PFUser currentUser] forKey:@"user"];
    [photo setObject:caption forKey:@"caption"];
    [photo saveInBackground];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}



@end
