//
//  CameraViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
}

@end
