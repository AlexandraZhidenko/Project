//
//  TableViewController.m
//  getxml_2
//
//  Created by Александра Жиденко on 17.05.18.
//  Copyright © 2018 Александра Жиденко. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    self.arrVendorsAfterSearch = [NSMutableArray arrayWithCapacity:0];
    self.arrVendorsAfterSearch = self.arrTableViewCell;
    
    self.dictColors = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray* alphabet = [NSMutableArray arrayWithCapacity:0];
    NSString* str = @"АБГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
    for (int i = 0; i < 32; i++) // (char a = 'A'; a <= 'Z'; a++)
    {
        NSString* tmp = [str substringWithRange:NSMakeRange(i, 1)];
        [alphabet addObject:tmp];
    }
    for(int i = 0; i < 32; i++)
    {
        [self.dictColors setObject:[UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1].CGColor forKey:alphabet[i]];
        NSLog(@"alphabet[i] = %@", alphabet[i]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrVendorsAfterSearch.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    tableCell.dictTableCell = [self.arrVendorsAfterSearch objectAtIndex:indexPath.row];
    tableCell.dict = self.dictColors;
    return tableCell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText.length)
    {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchText];
        NSMutableArray* filteredArray = [NSMutableArray arrayWithCapacity:0];
        
        for(int i = 0; i < self.arrTableViewCell.count; i++)
        {
            [filteredArray addObject:[[[self.arrTableViewCell objectAtIndex:i] valueForKey:@"title"] valueForKey:@"text"]];
        }
        filteredArray = (NSMutableArray*)[filteredArray filteredArrayUsingPredicate:pred];
        
        NSMutableArray* tmp = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0; i < self.arrVendorsAfterSearch.count; i++) // self.arrTableViewCell.count
        {
            for(int j = 0; j < filteredArray.count; j++)
            {
                if([[[[self.arrVendorsAfterSearch objectAtIndex:i] valueForKey:@"title"] valueForKey:@"text"] isEqualToString:[filteredArray objectAtIndex:j]])
                {
                    [tmp addObject:[self.arrVendorsAfterSearch objectAtIndex:i]];
                }
            }
        }
        
        self.arrVendorsAfterSearch = tmp;
    }
    else if(searchText.length == 0)
    {
        self.arrVendorsAfterSearch = self.arrTableViewCell;
    }
    [self.tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
