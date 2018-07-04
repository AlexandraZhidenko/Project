//
//  TableViewCell.h
//  getxml_2
//
//  Created by Александра Жиденко on 17.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic) NSDictionary* dictTableCell;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) CAShapeLayer *circle;

@property (nonatomic) NSMutableDictionary* dict;
//@property (nonatomic) NSMutableArray* colors;

@end
