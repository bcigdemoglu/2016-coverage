//
//  EventoViewController.h
//  PlanIt
//
//  Created by Naina Rao on 12/20/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventoViewController : UIViewController <EKEventEditViewDelegate>

//@property (strong, nonatomic) IBOutlet UILabel *eventDetailTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventDetailDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventDetailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventDetailTitleLabel;


- (IBAction)closeModalView:(id)sender;
- (IBAction)addEventToNative:(id)sender;


@end

