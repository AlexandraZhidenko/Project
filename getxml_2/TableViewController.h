//
//  TableViewController.h
//  getxml_2
//
//  Created by Александра Жиденко on 17.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "CollectionViewController.h"

@interface TableViewController : UITableViewController <UISearchBarDelegate>
@property (nonatomic) NSMutableArray* arrTableViewCell;
@property (nonatomic) NSMutableArray* arrVendorsAfterSearch;

@property (nonatomic) UISearchBar* searchBar;

@property (nonatomic) NSMutableDictionary* dictColors;
@end
