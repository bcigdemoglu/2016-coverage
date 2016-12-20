//
//  EKEventEditViewController+DataSource.m
//  PlanIt
//
//  Created by Naina Rao on 12/20/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

#import "DataSource.h"

@implementation EventoViewController

@synthesize eventDetailTitleLabel, eventDetailDateLabel, eventDetailDescriptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad { [super viewDidLoad]; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (IBAction)closeModalView:(id)sender { [self dismissModalViewControllerAnimated:YES]; }

- (IBAction)addEventToNative:(id)sender {
    NSLog(@"Clicked ");
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            // perform the main thread here to avoid any delay. normally seems to be 10 to 15 sec delay.
            [self performSelectorOnMainThread: @selector(presentEventEditViewControllerWithEventStore:) withObject:eventStore waitUntilDone:NO];
            
            
            
            if (granted){
                NSLog(@"We are granted to access Calendars!");
                //---- codes here when user allow your app to access theirs' calendar.
                
            }
            else {
                //---- code for no permission
                NSLog(@"We have no permission to access calendars!");
            }
        }];
    }
}

- (void)presentEventEditViewControllerWithEventStore:(EKEventStore*)eventStore {
    EKEventEditViewController* eventEditVC = [[EKEventEditViewController alloc] init];
    eventEditVC.eventStore = eventStore;
    
    EKEvent* event = [EKEvent eventWithEventStore:eventStore];
    event.title = self.eventDetailTitleLabel.text;
    event.startDate = [NSDate date];
    event.endDate = [NSDate date];
    event.URL = [NSURL URLWithString:@"http://portalsatuat.plataforma.sat.gob.mx/m/sp/paginas/home.aspx"];
    event.notes = @"Evento SAT";
    event.allDay = YES;
    eventEditVC.event = event;
    
    //eventEditVC.delegate = (id)self;
    [self presentViewController:eventEditVC animated:YES completion:nil];
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    NSLog(@"Clicked Cancel or Done");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action {
    NSLog(@"No se que esta pasando aqui!");
}

- (void)viewDidUnload {
    [self setEventDetailTitleLabel:nil];
    [self setEventDetailDateLabel:nil];
    [self setEventDetailDescriptionLabel:nil];
    [super viewDidUnload];
}


@end
