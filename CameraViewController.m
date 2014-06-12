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
@property UIImage *originalImage;
@property UIImage *newsFeedImage;
@property UIImage *thumbnailImage;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonOutlet;

@property UIImagePickerController *imagePickerController;

@end

@implementation CameraViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.shareButtonOutlet.layer.cornerRadius = 5.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    self.originalImage = image;
    [self createSizedImages:self.originalImage Imagesize:64.0];
}

- (IBAction)onButtonPressedSaveImage:(id)sender
{
    NSData *imageData = UIImagePNGRepresentation(self.originalImage);
    Photo *photo = [Photo objectWithClassName:@"Photo"];
    PFFile *photoFile = [PFFile fileWithData:imageData];
    NSString *caption = self.textView.text;
    [photo setObject:photoFile forKey:@"image"];
    [photo setObject:[PFUser currentUser] forKey:@"user"];
    [photo setObject:caption forKey:@"caption"];
    [photo saveInBackground];

    NSData *imageData1 = UIImagePNGRepresentation(self.thumbnailImage);
    Photo *photo1 = [Photo objectWithClassName:@"Photo"];
    PFFile *photoFile1 = [PFFile fileWithData:imageData1];
    [photo1 setObject:[PFUser currentUser] forKey:@"user"];
    [photo1 setObject:photoFile1 forKey:@"thumbnail"];
    [photo1 saveInBackground];

    self.imageView.image = nil;
    self.textView.text = nil;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)createSizedImages:(UIImage *)image Imagesize:(CGFloat)imagesize
{
    CGFloat thumbnailsize = imagesize;
    CGSize size = image.size;
    CGSize croppedSize;

    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;

    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension.
    // So clip the extra portion from x or y coordinate
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }

    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping

    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, thumbnailsize, thumbnailsize);

    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    self.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing

    NSLog(@"I ran");
}




@end
