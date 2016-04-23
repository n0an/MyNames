//
//  ANDescriptioinVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ANNameIterationDirectionNext,
    ANNameIterationDirectionPrevious

} ANNameIterationDirection;

@class ANName;

@interface ANDescriptioinVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView* nameImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contenView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* constrPortrImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* constrPortrLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* constrLandImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* constrLandLbl;


@property (weak, nonatomic) IBOutlet UIButton* readMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) NSArray* namesArray;

@property (assign, nonatomic) BOOL isCustomNavigationBar;

- (IBAction)actionlikeButtonPressed:(UIButton*)sender;



@end
