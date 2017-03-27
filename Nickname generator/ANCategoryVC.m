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

#pragma mark - PROPERTIES
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation ANCategoryVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}




#pragma mark - ACTIONS
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
    cell.categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([currentCategory isEqual:self.selectedCategory]) {
        self.selectedIndexPath = indexPath;
        cell.categoryName.alpha = 1;
        cell.fadeView.alpha = 0;
        cell.whiteBoxLeftConstraint.constant = 0;
    
    } else {
        cell.categoryName.alpha = 0;
        cell.fadeView.alpha = 0.5;
        CGFloat cellWidth = CGRectGetWidth(cell.frame);
        cell.whiteBoxLeftConstraint.constant = cellWidth * 2;
    }
    
    [cell configureCellWithNameCategory:currentCategory];
    
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ANNameCategory* currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    if (![currentCategory isEqual:self.selectedCategory]) {
        self.selectedCategory = currentCategory;
        [self.delegate categoryDidSelect:self.selectedCategory];
        
        ANCategoryCell* lastSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        [lastSelectedCell animateDeselection];
        
        ANCategoryCell* newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [newSelectedCell animateSelection];
        
        self.selectedIndexPath = indexPath;
    }
}


@end
