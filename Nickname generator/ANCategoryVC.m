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

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;


@end



@implementation ANCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    
    
    //self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ANNameCategory* currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    if (![currentCategory isEqual:self.selectedCategory]) {
        self.selectedCategory = currentCategory;
        
        [self.delegate categoryDidSelect:self.selectedCategory];
    }
    
    if (![self.selectedIndexPath isEqual:indexPath]) {
        
        ANCategoryCell* lastSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             lastSelectedCell.categoryName.alpha = 0;
                             lastSelectedCell.fadeView.alpha = 0.5;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:0.2f
                              delay:0.1f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             CGFloat cellWidth = CGRectGetWidth(lastSelectedCell.frame);
                             lastSelectedCell.whiteBoxLeftConstraint.constant = cellWidth * 2;
                             
                             [lastSelectedCell layoutIfNeeded];
                         } completion:nil];
        
        
        
        ANCategoryCell* newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             newSelectedCell.categoryName.alpha = 1;
                             newSelectedCell.fadeView.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:0.2f
                              delay:0.1f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             newSelectedCell.whiteBoxLeftConstraint.constant = 0;
                             [newSelectedCell layoutIfNeeded];
                         } completion:nil];
        
        self.selectedIndexPath = indexPath;
        
        
    }
    
    
    //[self.tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.f;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.f;
}







@end
