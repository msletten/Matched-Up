//
//  MSSettingsViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/9/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSSettingsViewController.h"

@interface MSSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;



@end

@implementation MSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ageSlider.value =[[NSUserDefaults standardUserDefaults] integerForKey:kMSAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMSMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMSWomenEnabledKey];
    self.singleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMSSingleEnabledKey];
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
}
- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
}

#pragma mark - Helper Methods
//When the value of our slider or switch changes we need to make the proper updates in NSUserDefaults. This method finds which object is being updated (among the switches and slider), then makes the appropriate update in NSUserDefaults.
- (void)valueChanged:(id)sender
{
    if (sender == self.ageSlider)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.ageSlider.value forKey:kMSAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
    }
    else if (sender == self.menSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMSMenEnabledKey];
    }
    else if (sender == self.womenSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kMSWomenEnabledKey];
    }
    else if (sender == self.singleSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.singleSwitch.isOn forKey:kMSSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
