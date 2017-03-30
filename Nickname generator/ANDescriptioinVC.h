//
//  ANDescriptioinVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - ENUM
typedef enum {
    ANNameIterationDirectionNext,
    ANNameIterationDirectionPrevious
} ANNameIterationDirection;

@class ANName;

@interface ANDescriptioinVC : UIViewController

#pragma mark - OUTLETS
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCategoryLabel;
//@property (weak, nonatomic) IBOutlet UILabel* descriptionLabel;

@property (weak, nonatomic) IBOutlet UITextView* descriptionTextView;

@property (weak, nonatomic) IBOutlet UIImageView* nameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UIView *contenView;

@property (weak, nonatomic) IBOutlet UIButton* readMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

#pragma mark - PUBLIC PROPERTIES
@property (strong, nonatomic) NSArray* namesArray;

#pragma mark - ACTIONS
- (IBAction)actionlikeButtonPressed:(UIButton*)sender;

@end
