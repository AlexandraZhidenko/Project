//
//  ViewController.h
//  gesture
//
//  Created by Александра Жиденко on 31.01.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//- (IBAction)tapGesture:(id)sender;
//@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureObject;
- (IBAction)tapGesture:(id)sender;
- (IBAction)rotationGesture:(id)sender;
@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *rotationGestureObject;
@property (nonatomic) UIColor *color;
@end

