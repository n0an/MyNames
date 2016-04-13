//
//  ANCategoryVC.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANCategoryVC.h"

#import "ANCategoryCell.h"

#import "ANNameCategory.h"

@interface ANCategoryVC ()


@end

@implementation ANCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


#pragma mark - Actions

- (void) actionDone:(UIBarButtonItem*) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CategoryCell";
    
    ANCategoryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ANNameCategory* currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    cell.categoryName.text = currentCategory.nameCategoryTitle;
    cell.categoryImageView.image = [UIImage imageNamed:currentCategory.nameCategoryImageName];
    
    
    
//    if ([currentCategory isEqual:self.selectedCategory]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANNameCategory* currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    if (![currentCategory isEqual:self.selectedCategory]) {
        self.selectedCategory = currentCategory;
        [self.delegate categoryDidSelect:self.selectedCategory];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    
}




@end
