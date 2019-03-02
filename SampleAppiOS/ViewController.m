//
//  ViewController.m
//  SampleAppiOS
//
//  Created by Omar Abdelwahed on 3/1/19.
//  Copyright © 2019 Omar Abdelwahed. All rights reserved.
//

#import "ViewController.h"
#import "ServerRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak ViewController *_self = self;
    [[ServerRequest sharedServer] getPerson:^(PersonModel *person) {
        
        NSLog(@"UserID: %ld Title: %@", [person.userID integerValue], person.title);
        
        // update UI labels
        // See: Main.storyboard for view
        _self.userID.text = [person.userID stringValue];
        _self.userTitle.text = person.title;
        
    }];
    
}


@end
