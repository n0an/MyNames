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


#pragma mark - Helper Methods



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
    
    cell.categoryName.alpha = 0;
    
    CGFloat translation = CGRectGetMaxX(cell.frame);
    
    cell.whiteTransparentView.transform = CGAffineTransformMakeTranslation(translation, 0);
    
    
    
    
    if ([currentCategory isEqual:self.selectedCategory]) {

        
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             cell.categoryName.alpha = 1;
                             cell.fadeView.alpha = 0;
                         } completion:^(BOOL finished) {

                         }];
        
        [UIView animateWithDuration:0.2f
                              delay:0.1f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.whiteTransparentView.transform = CGAffineTransformMakeTranslation(0, 0);
                         } completion:nil];
        

        cell.whiteBoxLeftConstraint.constant = 0;

        
    } else {
        
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             cell.categoryName.alpha = 0;
                             cell.fadeView.alpha = 0.5;

                         } completion:^(BOOL finished) {
                             
                         }];
        
        CGFloat cellWidth = CGRectGetWidth(cell.bounds);
        cell.whiteBoxLeftConstraint.constant = cellWidth;

    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ANNameCategory* currentCategory = [self.categories objectAtIndex:indexPath.row];
    
    if (![currentCategory isEqual:self.selectedCategory]) {
        self.selectedCategory = currentCategory;
 
        [self.delegate categoryDidSelect:self.selectedCategory];
    }
    
    [self.tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.f;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.f; // Auto Layout elements in the cell
}







@end
