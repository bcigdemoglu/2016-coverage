//
//  DataSource.h
//  PlanIt
//
//  Created by Naina Rao on 12/20/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

#ifndef DataSource_h
#define DataSource_h

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventoViewController : UIViewController <EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *eventDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailDescriptionLabel;


- (IBAction)closeModalView:(id)sender;
- (IBAction)addEventToNative:(id)sender;


@end

#endif /* DataSource_h */
