//
//  ANPageViewController.m
//  Nickname generator
//
//  Created by Anton Novoselov on 25/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANPageViewController.h"
#import "ANContentPageViewController.h"

@interface ANPageViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray* pageHeaders;
@property (strong, nonatomic) NSArray* pageSubHeaders;
@property (strong, nonatomic) NSArray* pageImageContents;

@end

@implementation ANPageViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    
    self.pageHeaders = @[NSLocalizedString(@"PAGEHEADERS01", nil),
                         NSLocalizedString(@"PAGEHEADERS02", nil),
                         NSLocalizedString(@"PAGEHEADERS03", nil),
                         NSLocalizedString(@"PAGEHEADERS04", nil),
                         NSLocalizedString(@"PAGEHEADERS05", nil)];
    
    self.pageSubHeaders = @[NSLocalizedString(@"PAGESUBHEADERS01", nil),
                            NSLocalizedString(@"PAGESUBHEADERS02", nil),
                            NSLocalizedString(@"PAGESUBHEADERS03", nil),
                            NSLocalizedString(@"PAGESUBHEADERS04", nil),
                            NSLocalizedString(@"PAGESUBHEADERS05", nil)];
    
    self.pageImageContents = @[NSLocalizedString(@"PAGEIMAGECONTENTS01", nil),
                               NSLocalizedString(@"PAGEIMAGECONTENTS02", nil),
                               NSLocalizedString(@"PAGEIMAGECONTENTS03", nil),
                               NSLocalizedString(@"PAGEIMAGECONTENTS04", nil),
                               NSLocalizedString(@"PAGEIMAGECONTENTS05", nil)];

    ANContentPageViewController* firstVC = [self showViewControllerAtIndex:0];
    
    [self setViewControllers:@[firstVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - HELPER METHODS
- (ANContentPageViewController*) showViewControllerAtIndex:(NSInteger) index {
    if ((index >= 0) && (index < [self.pageHeaders count])) {
        
        ANContentPageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ANContentPageViewController"];
        
        vc.imageFile    = [self.pageImageContents objectAtIndex:index];
        vc.header       = [self.pageHeaders objectAtIndex:index];
        vc.subHeader    = [self.pageSubHeaders objectAtIndex:index];
        vc.index        = index;
        return vc;
    }
    
    return nil;
}

- (void) nextPage:(NSInteger) index {
    ANContentPageViewController* nextVC = [self showViewControllerAtIndex:++index];
    
    [self setViewControllers:@[nextVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ANContentPageViewController* vc = (ANContentPageViewController*) viewController;
    NSInteger index = vc.index;
    return [self showViewControllerAtIndex:--index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ANContentPageViewController* vc = (ANContentPageViewController*) viewController;
    NSInteger index = vc.index;
    return [self showViewControllerAtIndex:++index];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

