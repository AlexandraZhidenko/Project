//
//  CollectionViewCell.h
//  getxml_2
//
//  Created by Александра Жиденко on 07.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewController.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel * name;
@property (nonatomic) NSDictionary* dictCell;
@property (nonatomic) CAShapeLayer *circle;

@end
