//
//  ViewController.m
//  gesture
//
//  Created by Александра Жиденко on 31.01.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGFloat red, green, blue;
    float tmpRotation;
    NSMutableArray *colors;
    int count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    red = 1.0; // arc4random() % 255 / 255.0
    green = 1.0;
    blue = 0.0;
    
    tmpRotation = 0;
    count = 0;
    
    colors = [[NSMutableArray alloc] initWithCapacity:0];
    
    float INCREMENT = 0.05;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT)
    {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapGesture:(id)sender
{
    CGFloat red = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue = arc4random() % 255 / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.view.backgroundColor = color;
}

- (IBAction)rotationGesture:(id)sender
{
    float rotation = self.rotationGestureObject.rotation; // 57.2958
    
    //self.color = [UIColor colorWithRed:red * rotation green:green * rotation blue:blue * rotation alpha:1.0];
    if(count != 0 && colors[count - 1] == self.view.backgroundColor)
    {
        self.view.backgroundColor = colors[count];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithRed:rotation*rotation - red green:rotation*rotation + green*rotation blue:rotation*rotation - blue alpha:1.0]; // green + rotation blue - rotation/2
    }
    
    
    //NSLog(@"= %lf", rotation - tmpRotation);
    //NSLog(@"i = %d", count);
    if(rotation - tmpRotation > 1 && count < 19)
    {
        count++;
        tmpRotation = rotation;
    }
    else if(rotation - tmpRotation < -1 && count > 0)
    {
        count--;
        tmpRotation = rotation;
    }
}
@end
