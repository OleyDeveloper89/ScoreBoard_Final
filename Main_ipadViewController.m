//
//  VollyballMainViewController.m
//  Scoreboard
//
//  Created by Kata on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Main_ipadViewController.h"
#import "BasketballMainViewController.h"
#import "BasketballSettingsViewController.h"
#import "VollyballSettingsViewController.h"
#import "TutorialViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioServices.h>
#import "Theme1SettingsViewController.h"
#import "CountdownTimerTheme1_iPad.h"
#import "Theme2SettingsViewcontroller.h"
#import "Theme2SettingsViewController_iPhone.h"
#import "Theme3SettingsViewController_iPhone.h"
#import "Theme1SettingViewController_iPhone.h"
#import "Theme3NocolorchooserViewController.h"
#import "BluetoothViewController.h"
#import "global.h"
#import "JDFlipNumberView.h"
#import "JDFlipClockView.h"
#import "JDFlipImageView.h"
#import "JDDateCountdownFlipView.h"
#import "UIView+JDFlipImageView.h"


//#import "UIFont+FlipNumberViewExample.h"
#define ACTION_SHEET_TAG 1000
#define GUESTSCORE_LABLE_XPOSITION 194
#define GUESTSCORE_LABLE_YPOSITION -103
#define GUESTSCORE_LABLE_WIDTH 135
#define GUESTSCORE_LABLE_HEIGHT 175
#define HIDDEN_GUESTSCORE_LABLE_XPOSITION 1174
#define HOMESCORE_LABLE_XPOSITION 385
#define HOMESCORE_LABLE_YPOSITION -103
#define HOMESCORE_LABLE_WIDTH 135
#define HOMESCORE_LABLE_HEIGHT 175
#define MOVE_RANGE 250
#define HIDDEN_HOMESCORE_LABLE_XPOSITION 10
#define LABLE_FONTSIZE 130
///////////** add **///////////
static CGFloat kFlipAnimationMinimumAnimationDuration = 0.05;
static CGFloat kFlipAnimationMaximumAnimationDuration = 0.70;

//typedef NS_OPTIONS(NSUInteger, JDFlipAnimationState) {
//	JDFlipAnimationStateFirstHalf,
//	JDFlipAnimationStateSecondHalf
//};
///////////////////////////////
@implementation Main_ipadViewController

@synthesize m_pMainBluetoothButton;
@synthesize preiodLabel;
@synthesize scrollView;

//keyBrdDoneBtnView;
@synthesize backHomeScoreLable,frontHomeScoreLable,backGuestScoreLable,frontGuestScoreLable,suspendedLableName;
@synthesize presentLable,frontHomeLableName,frontGuestLableName;
@synthesize upSwipe;
@synthesize guestLableImageName,homeLableImageName;
@synthesize hiddenHomeTextField,hiddenGuestTextField,homeTextField,guestTextField;
@synthesize hiddenBackHomeScoreLable,hiddenFrontHomeScoreLable,hiddenBackGuestScoreLable,hiddenFrontGuestScoreLable;
#pragma mark hans
@synthesize delegate = _delegate;
@synthesize game = _game;
@synthesize isControl;
@synthesize dfpInterstitial = dfpInterstitial_;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Sent when an interstitial ad request completed without an interstitial to
// show.
- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad {
    NSLog(@"Received ad successfully");
    [self.dfpInterstitial presentFromRootViewController:self];
    
    // Enable the show button.
    //    self.showInterstitialButton.enabled = YES;
    //    [self.showInterstitialButton setTitle:@"Show Interstitial"
    //                                 forState:UIControlStateNormal];
}

// Sent when an interstitial ad request completed without an interstitial to
// show.
- (void)interstitial:(DFPInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
    
    // Disable the show button.
    //    self.showInterstitialButton.enabled = NO;
    //    [self.showInterstitialButton setTitle:@"Failed to Receive Ad"
    //                                 forState:UIControlStateDisabled];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view sendSubviewToBack:Background];
    
    scoreboardWidthRate = 1024.0f / 480.0f;
    scoreboardHeightRate = 768.0f / 320.0f;
    volleyballFirstTime = NO;


    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    NSLog(@"View will appear");
	
    int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutesTheme1"];
    int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"secondsTheme1"];
    if (mins==0&&secs==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutesTheme1"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"secondsTheme1"];
    }
    int mins1=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutes"];
    int secs1=[[NSUserDefaults standardUserDefaults]integerForKey:@"seconds"];
    
    if (mins1==0&&secs1==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"seconds"];
    }
    if (countdownTimerView!=nil) {
		
		countdownTimerView.timerFlag= YES;
        int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutes"];
        int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"seconds"];
        
		[countdownTimerView settime:mins seconds:secs];
		
	}
    else{
        countdownTimerView.timerFlag = NO;
        
    }
    if (countdownTimerViewTheme1!=nil) {
		
		countdownTimerViewTheme1.timerFlagTheme1= YES;
        int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutesTheme1"];
        int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"secondsTheme1"];
        
		[countdownTimerViewTheme1 settime:mins seconds:secs];
		
	}
    else{
        countdownTimerViewTheme1.timerFlagTheme1=NO;
        
    }
    
    [self ChangeColor];
    [self Theme1ColorChange];
    [self Theme2ColorChange];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:SmallButtonDigital];
    [self.view bringSubviewToFront:SmallButtonTheme1];
    [self.view bringSubviewToFront:LeftShadow];
    [self.view bringSubviewToFront:RightShadow];
    [self.view bringSubviewToFront:Tutorial];
    [self.view bringSubviewToFront:LeftSideViewForTap];
    [self.view bringSubviewToFront:RightsideViewForTap];
    [self.view bringSubviewToFront:adView];
    
    
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    // banner is invisible now and moved out of the screen on 50 px
    banner.frame = CGRectMake(0, 288 * scoreboardHeightRate, 480 * scoreboardWidthRate, 50 * scoreboardHeightRate);
    //[UIView commitAnimations];
    self.bannerIsVisible = YES;
    //    [backButton setFrame:CGRectMake(backButton.frame.origin.x, 285-30, backButton.frame.size.width, backButton.frame.size.height)];
    //    SmallButtonDigital.frame = CGRectMake(7,7, 30, 30);
    //    SmallButtonTheme1.frame = CGRectMake(208,255, 65, 35);
    //    SmallButtonTheme2.frame=CGRectMake(208,255, 65, 35);
    //    SmallButtonTheme3.frame=CGRectMake(208, 255, 65, 35);
    
    
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    // banner is visible and we move it out of the screen, due to connection issue
    banner.frame = CGRectMake(0, 350 * scoreboardHeightRate, 480 * scoreboardWidthRate, 50 * scoreboardHeightRate);
    [UIView commitAnimations];
    self.bannerIsVisible = NO;
    //    [backButton setFrame:CGRectMake(backButton.frame.origin.x, 285, backButton.frame.size.width, backButton.frame.size.height)];
    //    SmallButtonDigital.frame = CGRectMake(7,7, 30, 30);
    //    SmallButtonTheme1.frame = CGRectMake(208,285, 65, 35);
    //    SmallButtonTheme2.frame=CGRectMake(208,285, 65, 35);
    //    SmallButtonTheme3.frame=CGRectMake(208,285, 65, 35);
    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(IBAction)tutorialButtonBackClick:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [Tutorial setFrame:CGRectMake(0, 340 * scoreboardHeightRate, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    [self.view bringSubviewToFront:Tutorial];
    [UIView commitAnimations];
    
}
- (IBAction)Dismiss:(id)sender {
    
    [StartingInstructionsView removeFromSuperview];
    
}
#pragma mark Fullscreen




-(IBAction)startBluetooth:(id)sender
{
    if (isBluetooth) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!!" message:@"Disconnect from bluetooth?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag: 903];
        
        [alert show];
        [alert release];
    } else
    {
        
        [self dismissModalViewControllerAnimated:YES];
        [self startBluetooth];
    }
}

- (void) selectorSwitcher: (NSTimer *) timer {
    //  NSLog(@"===========schedule===============");
    
    if (!self.isServer && isBluetooth) {
        
        [homeTextField setUserInteractionEnabled:NO];
        [guestTextField setUserInteractionEnabled:NO];
        [hiddenHomeTextField setUserInteractionEnabled:NO];
        [hiddenGuestTextField setUserInteractionEnabled:NO];
        [hiddenHomeTextFieldDigital setUserInteractionEnabled:NO];
        [guestTextFieldDigital setUserInteractionEnabled:NO];
        [homeTextFieldDigital setUserInteractionEnabled:NO];
        [hiddenGuestTextFieldDigital setUserInteractionEnabled:NO];
        [hiddenHomeTextFieldTheme1 setUserInteractionEnabled:NO];
        [guestTextFieldTheme1 setUserInteractionEnabled:NO];
        [homeTextFieldTheme1 setUserInteractionEnabled:NO];
        [hiddenGuestTextFieldTheme1 setUserInteractionEnabled:NO];
        [guestTextFieldTheme2 setUserInteractionEnabled:NO];
        [homeTextFieldTheme2 setUserInteractionEnabled:NO];
        [guestTextFieldTheme3 setUserInteractionEnabled:NO];
        [homeTextFieldTheme3 setUserInteractionEnabled:NO];
        
    } else {
        
        [homeTextField setUserInteractionEnabled:YES];
        [guestTextField setUserInteractionEnabled:YES];
        [hiddenHomeTextField setUserInteractionEnabled:YES];
        [hiddenGuestTextField setUserInteractionEnabled:YES];
        [hiddenHomeTextFieldDigital setUserInteractionEnabled:YES];
        [guestTextFieldDigital setUserInteractionEnabled:YES];
        [homeTextFieldDigital setUserInteractionEnabled:YES];
        [hiddenGuestTextFieldDigital setUserInteractionEnabled:YES];
        [hiddenHomeTextFieldTheme1 setUserInteractionEnabled:YES];
        [guestTextFieldTheme1 setUserInteractionEnabled:YES];
        [homeTextFieldTheme1 setUserInteractionEnabled:YES];
        [hiddenGuestTextFieldTheme1 setUserInteractionEnabled:YES];
        [guestTextFieldTheme2 setUserInteractionEnabled:YES];
        [homeTextFieldTheme2 setUserInteractionEnabled:YES];
        [guestTextFieldTheme3 setUserInteractionEnabled:YES];
        [homeTextFieldTheme3 setUserInteractionEnabled:YES];
        
    }
    
    if (isBluetooth) {
        [m_pMainBluetoothButton setImage:[UIImage imageNamed:@"bluetoothCancel.png"] forState: UIControlStateNormal];
        
    } else {
        [m_pMainBluetoothButton setImage:[UIImage imageNamed:@"mainBluetooth_button.png"] forState: UIControlStateNormal];
    }
    
    if (isBluetooth && self.isServer) {
        if (!countdownTimerView.timerFlag) {
            
            NSString *minStr, *secStr, *timeStr1, *timeStr2;
            
            if (countdownTimerView.minutes > 9)
                minStr = [NSString stringWithFormat:@"%d", countdownTimerView.minutes];
            else
                minStr = [NSString stringWithFormat:@"0%d", countdownTimerView.minutes];
            if (countdownTimerView.seconds > 9)
                secStr = [NSString stringWithFormat:@"%d", countdownTimerView.seconds];
            else
                secStr = [NSString stringWithFormat:@"0%d", countdownTimerView.seconds];
            
            timeStr1 = [NSString stringWithFormat:@"%@%@", minStr, secStr];
            
            [self.game timeChangeServer: timeStr1];
        }
        
        
        
        if (!countdownTimerViewTheme1.timerFlagTheme1) {
            NSString *minStr, *secStr, *timeStr1, *timeStr2;
            
            if (countdownTimerViewTheme1.minutesTheme1 > 9)
                minStr = [NSString stringWithFormat:@"%d", countdownTimerViewTheme1.minutesTheme1];
            else
                minStr = [NSString stringWithFormat:@"0%d", countdownTimerViewTheme1.minutesTheme1];
            
            if (countdownTimerViewTheme1.secondsTheme1 > 9)
                secStr = [NSString stringWithFormat:@"%d", countdownTimerViewTheme1.secondsTheme1];
            else
                secStr = [NSString stringWithFormat:@"0%d", countdownTimerViewTheme1.secondsTheme1];
            
            timeStr2 = [NSString stringWithFormat:@"%@%@", minStr, secStr];
            
            [self.game time2ChangeServer: timeStr2];
            
        }
    }
    
}

- (void)viewDidLoad {
    float height = 768;
    float width = 1024;
    
    NSLog(@"%f,%f",height,width);
    
    [super viewDidLoad];
//    interstitial_ = [[GADInterstitial alloc] init];
//    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
//    [interstitial_ loadRequest:[GADRequest request]];
    UIImageView *bgt=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ipad.jpg"]];
    
    [self.view addSubview:bgt];
    [bgt setFrame:CGRectMake(0, 0, 1024, 768)];

    //    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    self.isServer = YES;
    gCurrentViewNum = 0;
    
    thisDevice = [UIDevice currentDevice];
    scoreboardWidthRate = 1024.0f / 480.0f;
    scoreboardHeightRate = 768.0f / 320.0f;
    
    isBluetooth = NO;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(selectorSwitcher:) userInfo:nil repeats: YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode: NSDefaultRunLoopMode];
    
    //////////// huodong
    _wrap = YES;
    
    frontAndBackButtonValue=1;
    adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape,nil];
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectMake(0, 350 * scoreboardHeightRate, 480 * scoreboardWidthRate, 50 * scoreboardHeightRate);
    //adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    //  [self.view addSubview:adView];
    adView.delegate=self;
    self.bannerIsVisible=NO;
   // [adView setHidden:YES];
    
    
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitID with your
    // interstitial ad unit id.
    
    self.dfpInterstitial = [[[GADInterstitial alloc] init] autorelease];
    self.dfpInterstitial.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitID with your
    // interstitial ad unit id.
    self.dfpInterstitial.adUnitID = @"ca-app-pub-2827613882829649/2406163157";
    
    // Load the interstitial with an ad request.
    //[self.dfpInterstitial loadRequest:[GADRequest request]];
    
    BiggerModeDigitalActivated=NO;
    PageNumber = 1;
    VolleyBallViewBigger = NO;
    globalVolleyBallViewBigger = NO;
    
    DigitalViewBigger = NO;
    globalDigitalViewBigger = NO;
    
    Theme1Bigger = NO;
    globalTheme1Bigger = NO;
    
    Theme2ViewBigger = NO;
    globalTheme2ViewBigger = NO;
    Theme3ViewBigger = NO;
    globalTheme3ViewBigger = NO;
    
    Theme2Bigger = NO;
    
    VolleyBallCourtChanged=NO;
    DigitalScoreboardCourtChnage=NO;
    Theme1CourtChange=NO;
    Theme2CourtChange=NO;
    Theme3CourtChange=NO;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.items = [NSMutableArray array];
    
    VolleyBallView=[[UIView alloc] initWithFrame: CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    VolleyBallView.backgroundColor=[UIColor redColor];
    [_items addObject:VolleyBallView];
    
    DigitalScoreboard=[[UIView alloc] initWithFrame: CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    DigitalScoreboard.backgroundColor=[UIColor orangeColor];
    [_items addObject:DigitalScoreboard];
    
    DigitalScoreboardNewtheme1=[[UIView alloc] initWithFrame: CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    DigitalScoreboardNewtheme1.backgroundColor=[UIColor blackColor];
    [_items addObject:DigitalScoreboardNewtheme1];
    
    DigitalScoreBordNewTheme2=[[UIView alloc] initWithFrame: CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    DigitalScoreBordNewTheme2.backgroundColor=[UIColor yellowColor];
    [_items addObject:DigitalScoreBordNewTheme2];
    
    DigitalScoreBordNewTheme3=[[UIView alloc] initWithFrame: CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    DigitalScoreBordNewTheme3.backgroundColor=[UIColor yellowColor];
    [_items addObject:DigitalScoreBordNewTheme3];
    
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:VolleyBallView.bounds];
    VolleyBallView.layer.masksToBounds = NO;
    VolleyBallView.layer.shadowColor = [UIColor blackColor].CGColor;
    VolleyBallView.layer.shadowOffset = CGSizeMake(0, 5);
    VolleyBallView.layer.shadowOpacity = 1.5f;
    VolleyBallView.layer.shadowPath = shadowPath.CGPath;
    VolleyBallView.layer.shadowRadius = 15.0f;

    
    
    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:DigitalScoreboard.bounds];
    DigitalScoreboard.layer.masksToBounds = NO;
    DigitalScoreboard.layer.shadowColor = [UIColor blackColor].CGColor;
    DigitalScoreboard.layer.shadowOffset = CGSizeMake(0.0f, 05.0f);
    DigitalScoreboard.layer.shadowOpacity = 1.5f;
    DigitalScoreboard.layer.shadowPath = shadowPath1.CGPath;
    DigitalScoreboard.layer.shadowRadius = 15.0f;

    
    UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRect:DigitalScoreboardNewtheme1.bounds];
    DigitalScoreboardNewtheme1.layer.masksToBounds = NO;
    DigitalScoreboardNewtheme1.layer.shadowColor = [UIColor blackColor].CGColor;
    DigitalScoreboardNewtheme1.layer.shadowOffset = CGSizeMake(0.0f, 05.0f);
    DigitalScoreboardNewtheme1.layer.shadowOpacity = 1.5f;
    DigitalScoreboardNewtheme1.layer.shadowPath = shadowPath2.CGPath;
    DigitalScoreboardNewtheme1.layer.shadowRadius = 15.0f;

    
    UIBezierPath *shadowPath3 = [UIBezierPath bezierPathWithRect:DigitalScoreBordNewTheme2.bounds];
    DigitalScoreBordNewTheme2.layer.masksToBounds = NO;
    DigitalScoreBordNewTheme2.layer.shadowColor = [UIColor blackColor].CGColor;
    DigitalScoreBordNewTheme2.layer.shadowOffset = CGSizeMake(0.0f, 05.0f);
    DigitalScoreBordNewTheme2.layer.shadowOpacity = 1.5f;
    DigitalScoreBordNewTheme2.layer.shadowPath = shadowPath3.CGPath;
    DigitalScoreBordNewTheme2.layer.shadowRadius = 15.0f;

    
    UIBezierPath *shadowPath4 = [UIBezierPath bezierPathWithRect:DigitalScoreBordNewTheme3.bounds];
    DigitalScoreBordNewTheme3.layer.masksToBounds = NO;
    DigitalScoreBordNewTheme3.layer.shadowColor = [UIColor blackColor].CGColor;
    DigitalScoreBordNewTheme3.layer.shadowOffset = CGSizeMake(0.0f, 05.0f);
    DigitalScoreBordNewTheme3.layer.shadowOpacity = 1.5f;
    DigitalScoreBordNewTheme3.layer.shadowPath = shadowPath4.CGPath;
    DigitalScoreBordNewTheme3.layer.shadowRadius = 15.0f;

    
    
    
    
    Background=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]]; //huodong
    Background.frame=CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    [self.view addSubview:Background];
    
    ////////////////////////////////-->insert huo
    //create carousel
	_carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	_carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeCylinder;
	_carousel.delegate = self;
	_carousel.dataSource = self;
    
    ////////////////////// main carousel ///////////////insert huo/////////
    [self.view addSubview: _carousel];
    ////////////////////////////////<-----
    
    //  huodong
    UISwipeGestureRecognizer *leftSwipeUpMain = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveMainScrollViewLeft)] autorelease];
	leftSwipeUpMain.direction = UISwipeGestureRecognizerDirectionLeft;
	[BackGroundScroll addGestureRecognizer:leftSwipeUpMain];
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *rightSwipeDownMain = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveMainScrollViewRight)] autorelease];
	rightSwipeDownMain.direction = UISwipeGestureRecognizerDirectionRight;
	[BackGroundScroll addGestureRecognizer:rightSwipeDownMain];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    CGRect DigitalBackGround = CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate);
    DigitalscoreboardBackground = [[UIImageView alloc]initWithFrame:DigitalBackGround];
    [DigitalscoreboardBackground setImage:[UIImage imageNamed:@"2ndSBborder-5.png"]];
    [DigitalScoreboard addSubview:DigitalscoreboardBackground];
    [DigitalScoreboard setBackgroundColor:[UIColor blackColor]];
    
    CGRect DigitalScoreBoardTheme1=CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate);
    DigitalScoreBoardBackGroundTheme1=[[UIImageView alloc]initWithFrame:DigitalScoreBoardTheme1];
    [DigitalScoreBoardBackGroundTheme1 setImage:[UIImage imageNamed:@"digitalBG-4.png"]];
    [DigitalScoreboardNewtheme1 addSubview:DigitalScoreBoardBackGroundTheme1];
    
    CGRect DigitalScoreBoardTheme2=CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate);
    DigitalScoreBoardBackGroundTheme2=[[UIImageView alloc]initWithFrame:DigitalScoreBoardTheme2];
    [DigitalScoreBoardBackGroundTheme2 setImage:[UIImage imageNamed:@"SquareBackground-5.jpg"]];
    [DigitalScoreBordNewTheme2 addSubview:DigitalScoreBoardBackGroundTheme2];
    
    CGRect DigitalScoreBoardTheme3=CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate);            //added
    DigitalScoreBoardBackGroundTheme3 = [[UIImageView alloc]initWithFrame:DigitalScoreBoardTheme3];
    [DigitalScoreBoardBackGroundTheme3 setImage:[UIImage imageNamed:@"XLwurBackgroundadd-4.jpg"]];
    [DigitalScoreBordNewTheme3 addSubview:DigitalScoreBoardBackGroundTheme3];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    CGRect Boders = CGRectMake(228 * scoreboardWidthRate, 205 * scoreboardHeightRate, 130 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    HomeBorder = [[UIImageView alloc]initWithFrame:Boders];
    [HomeBorder setImage:[UIImage imageNamed:@"VballLabels.png"]];
    [VolleyBallView addSubview:HomeBorder];
    
    //    CGRect GuestBorderImage = CGRectMake(12, 139.5, 93, 17);
    CGRect GuestBorderImage = CGRectMake(12 * scoreboardWidthRate, 205 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    GuestBorder = [[UIImageView alloc]initWithFrame:GuestBorderImage];
    [GuestBorder setImage:[UIImage imageNamed:@"VballLabels.png"]];
    [VolleyBallView addSubview:GuestBorder];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    scrollView.contentSize = CGSizeMake(480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = YES;
    [VolleyBallView addSubview:scrollView];
    
    preiodLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168 * scoreboardWidthRate, scoreboardHeightRate+6.5, 44 * scoreboardWidthRate, 53.0 * scoreboardHeightRate)] autorelease];  //
    preiodLabel.backgroundColor = [UIColor darkGrayColor];
    preiodLabel.text = @"1";
    preiodLabel.textAlignment=UITextAlignmentCenter;
    preiodLabel.textColor=[UIColor orangeColor];
    preiodLabel.userInteractionEnabled=YES;
    [preiodLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:45.0 * scoreboardHeightRate]];
    [VolleyBallView addSubview:preiodLabel];
    preiodLabel.font=[UIFont systemFontOfSize:35 * scoreboardHeightRate] ;
    // preiodLabel.alpha=0.1;
    
    //    CGRect myImageRect = CGRectMake( 0, 0, 265.3,177);
    CGRect myImageRect = CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate);
    VolleyBallBackGroundImageView = [[UIImageView alloc]initWithFrame:myImageRect];
    
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    //        CGSize screenSize = screenBound.size;
    
    //  CGFloat screenWidth = screenBound.width;
    //        CGFloat screenHeight = screenSize.height;
    // iPhone
    // if (screenWidth!=568) {
    
    
    [VolleyBallBackGroundImageView setImage:[UIImage imageNamed:@"VballBackgroundadd-4.jpg"]];
    [VolleyBallView addSubview:VolleyBallBackGroundImageView];
    
    homeTextField = [[UITextField alloc] initWithFrame:CGRectMake(229 * scoreboardWidthRate, 202.5* scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
    //  homeTextField.borderStyle = UITextBorderStyleBezel;
    homeTextField.textColor = [UIColor blackColor];
    homeTextField.font = [UIFont systemFontOfSize:14 * scoreboardHeightRate];
    homeTextField.text = @"Home";  //place holder
    homeTextField.textAlignment=UITextAlignmentCenter;
    homeTextField.backgroundColor = [UIColor clearColor];
    homeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    homeTextField.keyboardType = UIKeyboardTypeDefault;
    homeTextField.returnKeyType = UIReturnKeyDone;
    homeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    homeTextField.tag = 10001;
    
    [VolleyBallView addSubview:homeTextField];
    HomeBorder.frame=homeTextField.frame;
    
    guestTextField = [[UITextField alloc] initWithFrame:CGRectMake(16 * scoreboardWidthRate, 202.5 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
    guestTextField.textColor = [UIColor blackColor];
    guestTextField.font = [UIFont systemFontOfSize:14 * scoreboardHeightRate];
    
    guestTextField.text = @"Guest";  //place holder
    guestTextField.textAlignment=UITextAlignmentCenter;
    guestTextField.backgroundColor = [UIColor clearColor];
    guestTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    guestTextField.keyboardType = UIKeyboardTypeDefault;
    guestTextField.returnKeyType = UIReturnKeyDone;
    guestTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //guestTextField.alpha=0.3;
    GuestBorder.frame=guestTextField.frame;
    
    guestTextField.tag = 10002;
    
    [VolleyBallView addSubview:guestTextField];
    
    hiddenHomeTextField = [[UITextField alloc] initWithFrame:CGRectMake(87 * scoreboardWidthRate, 215 * scoreboardHeightRate, 127 * scoreboardWidthRate, 17 * scoreboardHeightRate)];
    
    hiddenHomeTextField.borderStyle = UITextBorderStyleBezel;
    hiddenHomeTextField.textColor = [UIColor blackColor];
    hiddenHomeTextField.font = [UIFont systemFontOfSize:17 * scoreboardHeightRate];
    hiddenHomeTextField.placeholder = @"Home";  //place holder
    hiddenHomeTextField.textAlignment=UITextAlignmentCenter;
    hiddenHomeTextField.backgroundColor = [UIColor clearColor];
    hiddenHomeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    hiddenHomeTextField.keyboardType = UIKeyboardTypeDefault;
    hiddenHomeTextField.returnKeyType = UIReturnKeyDone;
    hiddenHomeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [scrollView addSubview:hiddenHomeTextField];
    [hiddenHomeTextField setHidden:YES];
    
    
    hiddenGuestTextField = [[UITextField alloc] initWithFrame:CGRectMake(640 * scoreboardWidthRate, 200 * scoreboardHeightRate, 130 * scoreboardWidthRate, 17 * scoreboardHeightRate)];
    hiddenGuestTextField.borderStyle = UITextBorderStyleBezel;
    hiddenGuestTextField.textColor = [UIColor whiteColor];
    hiddenGuestTextField.font = [UIFont systemFontOfSize:17 * scoreboardHeightRate];
    hiddenGuestTextField.placeholder = @"Guest";  //place holder
    hiddenGuestTextField.textAlignment=UITextAlignmentCenter;
    hiddenGuestTextField.backgroundColor = [UIColor clearColor];
    hiddenGuestTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    hiddenGuestTextField.keyboardType = UIKeyboardTypeDefault;
    hiddenGuestTextField.returnKeyType = UIReturnKeyDone;
    hiddenGuestTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [scrollView addSubview:hiddenGuestTextField];
    [hiddenGuestTextField setHidden:YES];
    
    
    
    backVollayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backVollayButton.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [backVollayButton setImage:[UIImage imageNamed:@"main_menu_button.png"] forState:UIControlStateNormal];
    [backVollayButton addTarget:self
                         action:@selector(volleyBackButtonClick:)
               forControlEvents:UIControlEventTouchDown];
    [VolleyBallView addSubview:backVollayButton];
    
    UIImage * btnImage2 = [UIImage imageNamed:@"settings_button.png"];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(350 * scoreboardWidthRate, 5 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [button3 setImage:btnImage2 forState:UIControlStateNormal];
    [button3 addTarget:self
                action:@selector(settingsButtonClick:)
      forControlEvents:UIControlEventTouchDown];
    [backVollayButton setHidden:YES];
    [button3 setHidden:YES];
    backVollayButton.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    button3.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3SettingsViewController_iPad" bundle:nil];
    theme3SettingsViewController.delegateSetting = self;
    
    m_pMainBluetoothButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[m_pMainBluetoothButton setFrame:CGRectMake(195 * scoreboardWidthRate, 298 * scoreboardHeightRate, 90 * scoreboardWidthRate, 20 * scoreboardHeightRate)];
    [m_pMainBluetoothButton setImage:[UIImage imageNamed:@"mainBluetooth_button.png"] forState: UIControlStateNormal];
    [m_pMainBluetoothButton addTarget:self action:@selector(startBluetooth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_pMainBluetoothButton];
    [m_pMainBluetoothButton setHidden:NO];
    
    [theme3SettingsViewController release];
	
	homeTextField.delegate = self;
	guestTextField.delegate = self;
	hiddenHomeTextField.delegate = self;
	hiddenGuestTextField.delegate = self;
	
	
	//home score lable settings
	backHomeLableScore = 1;
	backGuestLableScore = 1;
    
	frontHomeLableScore= 0;
	frontGuestLableScore=0;
	presentHomeScore = frontHomeLableScore;
	presentGuestScore = frontGuestLableScore;
	
	[self hiddenFrontHomeScoreLableInitialization];
	[self hiddenFrontGuestScoreLableInitialization];
	[self frontHomeScoreLableInitialization];
	[self frontGuestScoreLableInitialization];
    
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *leftSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveScrollViewLeft)] autorelease];
	leftSwipeUp.direction = UISwipeGestureRecognizerDirectionLeft;
	[scrollView addGestureRecognizer:leftSwipeUp];
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *rightSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveScrollViewRight)] autorelease];
	rightSwipeDown.direction = UISwipeGestureRecognizerDirectionRight;
	[scrollView addGestureRecognizer:rightSwipeDown];
	
	//period lable swipe recognizers
	UISwipeGestureRecognizer *periodSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(periodLableScoreUp)] autorelease];
	periodSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[preiodLabel addGestureRecognizer:periodSwipeUp];
	
	UISwipeGestureRecognizer *periodSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(periodLableScoreDown)] autorelease];
	periodSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[preiodLabel addGestureRecognizer:periodSwipeDown];
    
    UITapGestureRecognizer *PeriodLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(periodLableScoreUp)];
    [PeriodLabelTap setNumberOfTapsRequired:1];
    [PeriodLabelTap setNumberOfTouchesRequired:1];
    [preiodLabel addGestureRecognizer:PeriodLabelTap];
	
	//tap recognizer for score labels
    
    UITapGestureRecognizer *homeScoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeScoreLabelTap:)];
    [homeScoreLabelTap setNumberOfTapsRequired:1];
    [homeScoreLabelTap setNumberOfTouchesRequired:1];
    [frontHomeScoreLable addGestureRecognizer:homeScoreLabelTap];
    
    UITapGestureRecognizer *guestScoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guestScoreLabelTap:)];
    [guestScoreLabelTap setNumberOfTapsRequired:1];
    [guestScoreLabelTap setNumberOfTouchesRequired:1];
    [frontGuestScoreLable addGestureRecognizer:guestScoreLabelTap];
    
    UITapGestureRecognizer *hiddenHomeScoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenHomeScoreLabelTap:)];
    [hiddenHomeScoreLabelTap setNumberOfTapsRequired:1];
    [hiddenHomeScoreLabelTap setNumberOfTouchesRequired:1];
    [hiddenFrontHomeScoreLable addGestureRecognizer:hiddenHomeScoreLabelTap];
    
    UITapGestureRecognizer *hiddenGuestScoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGuestScoreLabelTap:)];
    [hiddenGuestScoreLabelTap setNumberOfTapsRequired:1];
    [hiddenGuestScoreLabelTap setNumberOfTouchesRequired:1];
    [hiddenFrontGuestScoreLable addGestureRecognizer:hiddenGuestScoreLabelTap];
	//initializing audio
	[self performSelector:@selector(initializeAudio) withObject:nil afterDelay:0.0];
    
    
    
    //    [self.view bringSubviewToFront:VolleyBallView];       //huodong
    //  [VolleyBallView  sendSubviewToBack:scrollView];
    
    [VolleyBallView bringSubviewToFront:preiodLabel];
    [VolleyBallView bringSubviewToFront:button3];
    //    [VolleyBallView bringSubviewToFront:button2];
    [VolleyBallView bringSubviewToFront:GuestBorder];
    [VolleyBallView bringSubviewToFront:HomeBorder];
    
    [scrollView bringSubviewToFront:homeTextField];
    [scrollView bringSubviewToFront:guestTextField];
    [scrollView bringSubviewToFront:hiddenGuestTextField];
    [scrollView bringSubviewToFront:hiddenHomeTextField];
    
    
    [self DigitalScoreBoardScreenDesign];
    [self DigitalScoreboardNewtheme1ScreenDesign];
    
    [self DigitalScoreboardNewtheme2ScreenDesign];
    [self DigitalScoreboardNewtheme3ScreenDesign];
    
    //    [BackgroundScrollView bringSubviewToFront:VolleyBallView];        //huodong
    [VolleyBallView bringSubviewToFront:scrollView];
    
    [VolleyBallView bringSubviewToFront:backVollayButton];
    [VolleyBallView addSubview:button3];
    [VolleyBallView bringSubviewToFront:guestTextField];
    [VolleyBallView bringSubviewToFront:homeTextField];
    [VolleyBallView bringSubviewToFront:preiodLabel];
    
    //    [button2 setUserInteractionEnabled:NO];
    //    [backVollayButton setHidden:NO];
    [backVollayButton setUserInteractionEnabled:NO];
    [button3 setUserInteractionEnabled:NO];
    [homeTextField setUserInteractionEnabled:NO];
    [guestTextField setUserInteractionEnabled:NO];
    [frontGuestScoreLable setUserInteractionEnabled:NO];
    [frontHomeScoreLable setUserInteractionEnabled:NO];
    [preiodLabel setUserInteractionEnabled:NO];
    
    [LeftSideViewForTap setBackgroundColor:[UIColor blackColor]];
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            for (UITextField *tableSubview in subView.subviews) {
                tableSubview.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            }
        }
    }
    
    buttoninfo=[UIButton buttonWithType:UIButtonTypeCustom];
    //[buttoninfo setFrame:CGRectMake(440 * scoreboardWidthRate, 700, 50, 50)];
    [self.view addSubview:buttoninfo];
    [buttoninfo setImage:[UIImage imageNamed:@"Info_Button.png"] forState:UIControlStateNormal];
    [buttoninfo addTarget:self action:@selector(showInstructions) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)showInstructions{
    scroll=[[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scroll];
    [self.view bringSubviewToFront:scroll];
    
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width,5*self.view.frame.size.height-175)];
    int y=0;
    [scroll setBackgroundColor:[UIColor blackColor]];
    UIImage *backImage=[UIImage imageNamed:@"bluetooth_cancel.png"];
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(430 * scoreboardWidthRate, 20 * scoreboardHeightRate, 32 * scoreboardWidthRate, 28 * scoreboardHeightRate);
    [backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchDown];
    [backbutton setImage:backImage forState:UIControlStateNormal];
    [self.view addSubview:backbutton];
    [self.view bringSubviewToFront:backbutton];

    for (int a=1; a<5; a++) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, y, 1024, 1365)];
        [scroll addSubview:img];
        [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"instructions%d.png",a]]];
        
        
        y=y+1365;
    }
    
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width,4*1365)];
}
-(void)backButtonClick{
    [scroll removeFromSuperview];
    [backbutton removeFromSuperview];
    
}
#pragma mark iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480.0f * scoreboardWidthRate, 320.0f * scoreboardHeightRate)];
    view.contentMode = UIViewContentModeCenter;
    [view addSubview:_items[index]];
    
    return view;
}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}
- (CGFloat)
:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return _wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            //            return value * 1.05f;
            return value;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}
#pragma mark -
#pragma mark Second ScoreBoard Screen desings .................
//modify by huodong
-(void)DigitalScoreBoardScreenDesign{
    //
    scrollViewDigital = [[UIScrollView alloc] initWithFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1020 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    scrollViewDigital.frame= CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    //    scrollViewDigital.contentSize = CGSizeMake(480, 250);
    scrollViewDigital.contentSize = CGSizeMake(480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    
    scrollViewDigital.showsHorizontalScrollIndicator = YES;
    [scrollViewDigital setBackgroundColor:[UIColor clearColor]];
    
    [DigitalScoreboard addSubview:scrollViewDigital];
    //[scrollViewDigital setHidden:YES];
    
    
    CGRect Boders = CGRectMake(20 * scoreboardWidthRate, 225 * scoreboardHeightRate, 145 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    HomeBorderDigital = [[UIImageView alloc]initWithFrame:Boders];
    [HomeBorderDigital setImage:[UIImage imageNamed:@"VballLabels.png"]];
    [DigitalScoreboard addSubview:HomeBorderDigital];
    
    CGRect GuestBorderImage = CGRectMake(219 * scoreboardWidthRate, 225 * scoreboardHeightRate, 145 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    GuestBorderDigital = [[UIImageView alloc]initWithFrame:GuestBorderImage];
    [GuestBorderDigital setImage:[UIImage imageNamed:@"VballLabels.png"]];
    [DigitalScoreboard addSubview:GuestBorderDigital];
    
    countdownTimerView=[[CountdownTimer_iPad alloc]initWithFrame:CGRectMake(183 * scoreboardWidthRate, 6 * scoreboardHeightRate, 113 * scoreboardWidthRate, 61 * scoreboardHeightRate)];
    countdownTimerViewTheme1=[[CountDownTimerTheme1_ipad alloc]initWithFrame:CGRectMake(183 * scoreboardWidthRate, 6 * scoreboardHeightRate, 113 * scoreboardWidthRate, 61 * scoreboardHeightRate)];
    
    //
    hiddenHomeTextFieldDigital = [[UITextField alloc] initWithFrame:CGRectMake(35 * scoreboardWidthRate, 150 * scoreboardHeightRate, 90 * scoreboardWidthRate, 14 * scoreboardHeightRate)];
    hiddenHomeTextFieldDigital.borderStyle = UITextBorderStyleBezel;
    hiddenHomeTextFieldDigital.textColor = [UIColor blackColor];
    hiddenHomeTextFieldDigital.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    hiddenHomeTextFieldDigital.text = @"Home";
    hiddenHomeTextFieldDigital.textAlignment=UITextAlignmentCenter;
    hiddenHomeTextFieldDigital.autocorrectionType = UITextAutocorrectionTypeNo;
    hiddenHomeTextFieldDigital.backgroundColor = [UIColor clearColor];
    hiddenHomeTextFieldDigital.keyboardType = UIKeyboardTypeDefault;
    hiddenHomeTextFieldDigital.returnKeyType = UIReturnKeyDone;
    hiddenHomeTextFieldDigital.clearButtonMode = UITextFieldViewModeWhileEditing;
    // [self.view addSubview:homeTextField];
    [DigitalScoreboard addSubview:hiddenHomeTextFieldDigital];
    hiddenHomeTextFieldDigital.delegate = self;
    
    [hiddenHomeTextFieldDigital setHidden:YES];
    
    
    guestTextFieldDigital = [[UITextField alloc] initWithFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    // guestTextFieldDigital.borderStyle = UITextBorderStyleBezel;
    guestTextFieldDigital.textColor = [UIColor blackColor];
    guestTextFieldDigital.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    guestTextFieldDigital.text = @"Guest";
    guestTextFieldDigital.textAlignment = UITextAlignmentCenter;
    guestTextFieldDigital.backgroundColor = [UIColor clearColor];
    guestTextFieldDigital.autocorrectionType = UITextAutocorrectionTypeNo;
    guestTextFieldDigital.keyboardType = UIKeyboardTypeDefault;
    guestTextFieldDigital.returnKeyType = UIReturnKeyDone;
    guestTextFieldDigital.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:guestTextField];
    [DigitalScoreboard addSubview:guestTextFieldDigital];
    
    guestTextFieldDigital.tag = 10004;
    
    guestTextFieldDigital.delegate = self;
    
    homeTextFieldDigital = [[UITextField alloc] initWithFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    // homeTextFieldDigital.borderStyle = UITextBorderStyleBezel;
    homeTextFieldDigital.textColor = [UIColor blackColor];
    homeTextFieldDigital.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldDigital.text = @"Home";
    homeTextFieldDigital.textAlignment=UITextAlignmentCenter;
    homeTextFieldDigital.autocorrectionType = UITextAutocorrectionTypeNo;
    homeTextFieldDigital.backgroundColor = [UIColor clearColor];
    homeTextFieldDigital.keyboardType = UIKeyboardTypeDefault;
    homeTextFieldDigital.returnKeyType = UIReturnKeyDone;
    homeTextFieldDigital.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    homeTextFieldDigital.tag = 10003;
    
    // [self.view addSubview:homeTextField];
    [DigitalScoreboard addSubview:homeTextFieldDigital];
    homeTextFieldDigital.delegate = self;
    [guestTextFieldDigital setUserInteractionEnabled:NO];
    [homeTextFieldDigital setUserInteractionEnabled:NO];
    
    
    hiddenGuestTextFieldDigital = [[UITextField alloc] initWithFrame:CGRectMake(1335 * scoreboardWidthRate, 430 * scoreboardHeightRate, 255 * scoreboardWidthRate, 38 * scoreboardHeightRate)];
    hiddenGuestTextFieldDigital.borderStyle = UITextBorderStyleBezel;
    hiddenGuestTextFieldDigital.textColor = [UIColor blackColor];
    hiddenGuestTextFieldDigital.font = [UIFont systemFontOfSize:17 * scoreboardHeightRate];
    hiddenGuestTextFieldDigital.text = @"Guest";
    hiddenGuestTextFieldDigital.textAlignment=UITextAlignmentCenter;
    hiddenGuestTextFieldDigital.backgroundColor = [UIColor blackColor];
    hiddenGuestTextFieldDigital.autocorrectionType = UITextAutocorrectionTypeNo;
    hiddenGuestTextFieldDigital.keyboardType = UIKeyboardTypeDefault;
    hiddenGuestTextFieldDigital.returnKeyType = UIReturnKeyDone;
    hiddenGuestTextFieldDigital.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:guestTextField];
    [DigitalScoreboard addSubview:hiddenGuestTextFieldDigital];
    [hiddenGuestTextFieldDigital setHidden:YES];
    
    hiddenGuestTextFieldDigital.delegate = self;
    self.view.backgroundColor = [UIColor redColor];
    
    
    CGRect myImageRect = CGRectMake( 129 * scoreboardWidthRate, 24 * scoreboardHeightRate, 7 * scoreboardWidthRate, 13 * scoreboardHeightRate);
    //    CGRect myImageRect = CGRectMake( 495, 10, 30, 150);
    tutorialImageView = [[UIImageView alloc]initWithFrame:myImageRect];
    [tutorialImageView setImage:[UIImage imageNamed:@"21dot.png"]];
    [DigitalScoreboard addSubview:tutorialImageView];
    //
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect = CGRectMake( 228, 10, 15, 50);
    CGRect myImageRect1 = CGRectMake( 139 * scoreboardWidthRate, 17.5 * scoreboardHeightRate, 26 * scoreboardWidthRate, 35 * scoreboardHeightRate);
    tutorialImageView1 = [[UIImageView alloc]initWithFrame:myImageRect1];
    [tutorialImageView1 setImage:[UIImage imageNamed:@"green0.png"]];
    [DigitalScoreboard addSubview:tutorialImageView1];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect2 = CGRectMake( 206, 10, 20, 50);
    CGRect myImageRect2 = CGRectMake( 122 * scoreboardWidthRate, 17.5 * scoreboardHeightRate, 26 * scoreboardWidthRate, 35 * scoreboardHeightRate);
    tutorialImageView2 = [[UIImageView alloc]initWithFrame:myImageRect2];
    [tutorialImageView2 setImage:[UIImage imageNamed:@"green0.png"]];
    [DigitalScoreboard addSubview:tutorialImageView2];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect3 = CGRectMake( 244, 10, 20, 50);
    CGRect myImageRect3 = CGRectMake( 134 * scoreboardWidthRate, 17.5 * scoreboardHeightRate, 26 * scoreboardWidthRate, 35 * scoreboardHeightRate);
    tutorialImageView3 = [[UIImageView alloc]initWithFrame:myImageRect3];
    [tutorialImageView3 setImage:[UIImage imageNamed:@"green0.png"]];
    [DigitalScoreboard addSubview:tutorialImageView3];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect4 = CGRectMake( 265, 10, 20, 50);
    CGRect myImageRect4 = CGRectMake( 152 * scoreboardWidthRate, 17.5 * scoreboardHeightRate, 26 * scoreboardWidthRate, 35 * scoreboardHeightRate);
    tutorialImageView4 = [[UIImageView alloc]initWithFrame:myImageRect4];
    [tutorialImageView4 setImage:[UIImage imageNamed:@"green0.png"]];
    [DigitalScoreboard addSubview:tutorialImageView4];
    
    countdownTimerView.minuteImage1=tutorialImageView1;
    countdownTimerView.minuteImage2=tutorialImageView2;
    countdownTimerView.secondImage1=tutorialImageView3;
    countdownTimerView.secondImage2=tutorialImageView4;
    
    UIImage *timerPlayandPauseButtonImage = [UIImage imageNamed:@"sb2_play.png"];
    DigitaltimerPlayandPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    DigitaltimerPlayandPauseButton.frame = CGRectMake(88 * scoreboardWidthRate, 3 * scoreboardHeightRate, 90 * scoreboardWidthRate, 32 * scoreboardHeightRate);
    [DigitalScoreboard addSubview:DigitaltimerPlayandPauseButton];
    //[scrollView addSubview:timerPlayandPauseButton];
    [DigitaltimerPlayandPauseButton addTarget:self action:@selector(timerPlayandPauseButtonClick:)
                             forControlEvents:UIControlEventTouchUpInside];
    [DigitaltimerPlayandPauseButton setImage:timerPlayandPauseButtonImage forState:UIControlStateNormal];
    [DigitaltimerPlayandPauseButton setUserInteractionEnabled:NO];
    
    
    
    UIImage * backImage = [UIImage imageNamed:@"main_menu_button.png"];
    SmallButtonDigital = [UIButton buttonWithType:UIButtonTypeCustom];
    SmallButtonDigital.frame = CGRectMake(5 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 28 * scoreboardHeightRate);
    [SmallButtonDigital addTarget:self action:@selector(backButtonClickDigiatal:)
                 forControlEvents:UIControlEventTouchUpInside];
    [SmallButtonDigital setImage:backImage forState:UIControlStateNormal];
    
    [DigitalScoreboard addSubview:SmallButtonDigital];
    
    UIImage * settingImage = [UIImage imageNamed:@"settings_button.png"];
    DigitalsettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    DigitalsettingButton.frame = CGRectMake(350 * scoreboardWidthRate, 5 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [DigitalsettingButton addTarget:self action:@selector(DigitalresetButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];
    [DigitalsettingButton setImage:settingImage forState:UIControlStateNormal];
    
    [DigitalScoreboard addSubview: DigitalsettingButton];
    [SmallButtonDigital setHidden:YES];
    [DigitalsettingButton setHidden:YES];
    SmallButtonDigital.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    DigitalsettingButton.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    ///insert time setting button ////
    UIImage * resetImage = [UIImage imageNamed:@"Vball-reset.png"];
    timeSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeSetButton.frame = CGRectMake(178 * scoreboardWidthRate, 140 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [timeSetButton addTarget:self action:@selector(DigitalsettingsButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [timeSetButton setImage:resetImage forState:UIControlStateNormal];
    [timeSetButton setUserInteractionEnabled:NO];
    // [scrollView addSubview:resetButton];
    //  [DigitalScoreboard addSubview: timeSetButton];
    
    
    
    
    
    SmallButtonDigital.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    DigitalsettingButton.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    
    
    
    
    //  [DigitalScoreboard bringSubviewToFront:scrollViewDigital];
    
    [DigitalsettingButton setUserInteractionEnabled:NO];
    [SmallButtonDigital setUserInteractionEnabled:NO];
    
    //    [DigitalsettingButton setFrame:CGRectMake(242.3, 1, 20, 20)];
    //    [SmallButtonDigital setFrame:CGRectMake(2, 1, 20, 20)];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRecthiddenHome = CGRectMake( 310 * scoreboardWidthRate, 135 * scoreboardHeightRate, 100 * scoreboardWidthRate, 195 * scoreboardHeightRate);
    hiddenRightHomeImageView = [[UIImageView alloc]initWithFrame:myImageRecthiddenHome];
    [hiddenRightHomeImageView setImage:[UIImage imageNamed:@"off.png"]];
    // [self.view addSubview:rightGuestImageView];
    hiddenRightHomeImageView.userInteractionEnabled=YES;
    [scrollViewDigital addSubview:hiddenRightHomeImageView];
    [hiddenRightHomeImageView setHidden:YES];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRecthiddenHomeLeft = CGRectMake( 160 * scoreboardWidthRate, 135 * scoreboardHeightRate, 100 * scoreboardWidthRate, 195 * scoreboardHeightRate);
    hiddenLeftHomeImageView = [[UIImageView alloc]initWithFrame:myImageRecthiddenHomeLeft];
    [hiddenLeftHomeImageView setImage:[UIImage imageNamed:@"off.png"]];
    // [self.view addSubview:rightGuestImageView];
    hiddenLeftHomeImageView.userInteractionEnabled=YES;
    [scrollViewDigital addSubview:hiddenLeftHomeImageView];
    
    [hiddenLeftHomeImageView setHidden:YES];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectleftGuest = CGRectMake(262 * scoreboardWidthRate, 80 * scoreboardHeightRate, 75 * scoreboardWidthRate, 125 * scoreboardHeightRate);
    leftGuestImageView = [[UIImageView alloc]initWithFrame:myImageRectleftGuest];
    [leftGuestImageView setImage:[UIImage imageNamed:@"off.png"]];
    leftGuestImageView.userInteractionEnabled=YES;
    
    [scrollViewDigital addSubview:leftGuestImageView];
    
    [leftGuestImageView setHidden:YES];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectrightGuest = CGRectMake( 330 * scoreboardWidthRate, 80 * scoreboardHeightRate, 75 * scoreboardWidthRate, 125 * scoreboardHeightRate);
    rightGuestImageView = [[UIImageView alloc]initWithFrame:myImageRectrightGuest];
    [rightGuestImageView setImage:[UIImage imageNamed:@"off.png"]];
    rightGuestImageView.userInteractionEnabled=YES;
    [scrollViewDigital addSubview:rightGuestImageView];
    
    [rightGuestImageView setHidden:YES];
    
    CGRect myImageRect8 = CGRectMake( 260 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 135 * scoreboardHeightRate);
    guestBackImageView = [[UIImageView alloc]initWithFrame:myImageRect8];
    guestBackImageView.backgroundColor = [UIColor blackColor];
    guestBackImageView.userInteractionEnabled=YES;
    [scrollViewDigital addSubview:guestBackImageView];
    
    CGRect myImageRect7 = CGRectMake(462 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 135 * scoreboardHeightRate);
    homeBackImageView = [[UIImageView alloc]initWithFrame:myImageRect7];
    homeBackImageView.backgroundColor = [UIColor blackColor];
    homeBackImageView.userInteractionEnabled=YES;
    [scrollViewDigital addSubview:homeBackImageView];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectg = CGRectMake(256 * scoreboardWidthRate, 64 * scoreboardHeightRate, 88 * scoreboardWidthRate, 136 * scoreboardHeightRate);
    hiddenLeftGuestImageView = [[UIImageView alloc]initWithFrame:myImageRectg];
    [hiddenLeftGuestImageView setImage:[UIImage imageNamed:@"dot-0.png"]];
    hiddenLeftGuestImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    hiddenLeftGuestImageView.userInteractionEnabled=NO;
    //[self.view addSubview:leftGuestImageView];
    [scrollViewDigital addSubview:hiddenLeftGuestImageView];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRecth = CGRectMake(336 * scoreboardWidthRate, 64 * scoreboardHeightRate, 88 * scoreboardWidthRate, 136 * scoreboardHeightRate);
    hiddenRightGuestImageView = [[UIImageView alloc]initWithFrame:myImageRecth];
    [hiddenRightGuestImageView setImage:[UIImage imageNamed:@"dot-0.png"]];
    hiddenRightGuestImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    // [self.view addSubview:rightGuestImageView];
    hiddenRightGuestImageView.userInteractionEnabled=NO;
    [scrollViewDigital addSubview:hiddenRightGuestImageView];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectd = CGRectMake( 456 * scoreboardWidthRate, 64 * scoreboardHeightRate, 88 * scoreboardWidthRate, 136 * scoreboardHeightRate);
    leftHomeImageView = [[UIImageView alloc]initWithFrame:myImageRectd];
    [leftHomeImageView setImage:[UIImage imageNamed:@"dot-0.png"]];
    leftHomeImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    leftHomeImageView.userInteractionEnabled=NO;
    //[self.view addSubview:hiddenLeftGuestImageView];
    [scrollViewDigital addSubview:leftHomeImageView];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectc = CGRectMake(536 * scoreboardWidthRate, 69 * scoreboardHeightRate, 88 * scoreboardWidthRate, 136 * scoreboardHeightRate);
    rightHomeImageView = [[UIImageView alloc]initWithFrame:myImageRectc];
    [rightHomeImageView setImage:[UIImage imageNamed:@"dot-0.png"]];
    rightHomeImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    rightHomeImageView.userInteractionEnabled=NO;
    [scrollViewDigital addSubview:rightHomeImageView];
    
    
    int tutorialy = 29;
    int tutorialHeight = 44 * scoreboardHeightRate;
    int tutorialWidth = 26 * scoreboardWidthRate;
    
    int Yvalue=80 * scoreboardHeightRate;
    int width=76 * scoreboardWidthRate;
    int height=150 * scoreboardWidthRate;
    [hiddenLeftGuestImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
    [hiddenRightGuestImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
    [leftHomeImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
    [rightHomeImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
    
    CGRect myImageRect81 = CGRectMake( 260 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    guestBackImageView.frame=myImageRect81;
    
    CGRect myImageRect71 = CGRectMake(462 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    homeBackImageView.frame=myImageRect71;
    
    
    
    [tutorialImageView setFrame:CGRectMake( 183.1 * scoreboardWidthRate, 19 * scoreboardHeightRate, 14 * scoreboardWidthRate, 30 * scoreboardHeightRate)];
    [tutorialImageView1 setFrame:CGRectMake( 135 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView2 setFrame:CGRectMake( 161 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView3 setFrame:CGRectMake( 192 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView4 setFrame:CGRectMake( 218 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    
    [guestTextFieldDigital setFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [homeTextFieldDigital setFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    [DigitalScoreboard bringSubviewToFront:DigitalscoreboardBackground];
    [DigitalScoreboard bringSubviewToFront:HomeBorderDigital];
    [DigitalScoreboard bringSubviewToFront:GuestBorderDigital];
    [DigitalScoreboard bringSubviewToFront:homeTextFieldDigital];
    [DigitalScoreboard bringSubviewToFront:guestTextFieldDigital];
    homeTextFieldDigital.frame=HomeBorderDigital.frame;
    guestTextFieldDigital.frame=GuestBorderDigital.frame;
    [DigitalScoreboard bringSubviewToFront:DigitalsettingButton];
    [DigitalScoreboard bringSubviewToFront:SmallButtonDigital];
    
    //
    //
	//initializing swipe recognizers
	UISwipeGestureRecognizer *rightHomeImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHomeImageViewScoreUp)] autorelease];
	rightHomeImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[rightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeUp];
	
	UISwipeGestureRecognizer *rightHomeImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHomeImageViewScoreDown)] autorelease];
	rightHomeImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[rightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeDown];
    //
    //
	//initializing swipe recognizers
	UISwipeGestureRecognizer *leftHomeImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHomeImageViewScoreUp)] autorelease];
	leftHomeImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[leftHomeImageView addGestureRecognizer:leftHomeImageViewSwipeUp];
	
	UISwipeGestureRecognizer *leftHomeImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHomeImageViewScoreDown)] autorelease];
	leftHomeImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[leftHomeImageView addGestureRecognizer:leftHomeImageViewSwipeDown];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *rightGuestImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightGuestImageViewScoreUp)] autorelease];
	rightGuestImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[rightGuestImageView addGestureRecognizer:rightGuestImageViewSwipeUp];
	
	UISwipeGestureRecognizer *rightGuestImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightGuestImageViewScoreDown)] autorelease];
	rightGuestImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[rightGuestImageView addGestureRecognizer:rightGuestImageViewSwipeDown];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *leftGuestImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftGuestImageViewScoreUp)] autorelease];
	leftGuestImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[leftGuestImageView addGestureRecognizer:leftGuestImageViewSwipeUp];
	
	UISwipeGestureRecognizer *leftGuestImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftGuestImageViewScoreDown)] autorelease];
	leftGuestImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[leftGuestImageView addGestureRecognizer:leftGuestImageViewSwipeDown];
	
	
	/*
	 //hidden imageview guesters initialziation
	 */
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenRightHomeImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightHomeImageViewScoreUp)] autorelease];
	hiddenRightHomeImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenRightHomeImageView addGestureRecognizer:hiddenRightHomeImageViewSwipeUp];
	
	UISwipeGestureRecognizer *hiddenRightHomeImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightHomeImageViewScoreDown)] autorelease];
	hiddenRightHomeImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenRightHomeImageView addGestureRecognizer:hiddenRightHomeImageViewSwipeDown];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenLeftHomeImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftHomeImageViewScoreUp)] autorelease];
	hiddenLeftHomeImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenLeftHomeImageView addGestureRecognizer:hiddenLeftHomeImageViewSwipeUp];
	
	UISwipeGestureRecognizer *hiddenLeftHomeImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftHomeImageViewScoreDown)] autorelease];
	hiddenLeftHomeImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenLeftHomeImageView addGestureRecognizer:hiddenLeftHomeImageViewSwipeDown];
	
    
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenRightGuestImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightGuestImageViewScoreUp)] autorelease];
	hiddenRightGuestImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenRightGuestImageView addGestureRecognizer:hiddenRightGuestImageViewSwipeUp];
	
	UISwipeGestureRecognizer *hiddenRightGuestImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightGuestImageViewScoreDown)] autorelease];
	hiddenRightGuestImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenRightGuestImageView addGestureRecognizer:hiddenRightGuestImageViewSwipeDown];
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenLeftGuestImageViewSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftGuestImageViewScoreUp)] autorelease];
	hiddenLeftGuestImageViewSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenLeftGuestImageView addGestureRecognizer:hiddenLeftGuestImageViewSwipeUp];
	
	UISwipeGestureRecognizer *hiddenLeftGuestImageViewSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftGuestImageViewScoreDown)] autorelease];
	hiddenLeftGuestImageViewSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenLeftGuestImageView addGestureRecognizer:hiddenLeftGuestImageViewSwipeDown];
	
	
    //
    //	//scrollview guesture initialization
    //	//scroll view swipe recognizers
	UISwipeGestureRecognizer *leftSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalMoveScrollViewLeft)] autorelease];
	leftSwipeUp.direction = UISwipeGestureRecognizerDirectionLeft;
	[scrollViewDigital addGestureRecognizer:leftSwipeUp];
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *rightSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalmoveScrollViewRight)] autorelease];
	rightSwipeDown.direction = UISwipeGestureRecognizerDirectionRight;
	[scrollViewDigital addGestureRecognizer:rightSwipeDown];
    //
    //	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetScore) name:@"shake" object:nil];
    //    //tap gesture
    //    //1
    UITapGestureRecognizer *rightHomeScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeScoreChangeWithTap:)];
    [rightHomeScoreImageTap setNumberOfTapsRequired:1];
    [rightHomeScoreImageTap setNumberOfTouchesRequired:1];
    [rightHomeImageView addGestureRecognizer:rightHomeScoreImageTap];
    
    UITapGestureRecognizer *leftHomeScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeScoreChangeWithTap:)];
    [leftHomeScoreImageTap setNumberOfTapsRequired:1];
    [leftHomeScoreImageTap setNumberOfTouchesRequired:1];
    [leftHomeImageView addGestureRecognizer:leftHomeScoreImageTap];
    
    //2
    UITapGestureRecognizer *rightGuestScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guestScoreChangeWithTap:)];
    [rightGuestScoreImageTap setNumberOfTapsRequired:1];
    [rightGuestScoreImageTap setNumberOfTouchesRequired:1];
    [rightGuestImageView addGestureRecognizer:rightGuestScoreImageTap];
    
    UITapGestureRecognizer *leftGuestScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guestScoreChangeWithTap:)];
    [leftGuestScoreImageTap setNumberOfTapsRequired:1];
    [leftGuestScoreImageTap setNumberOfTouchesRequired:1];
    [leftGuestImageView addGestureRecognizer:leftGuestScoreImageTap];
    //3
    UITapGestureRecognizer *hiddenRightHomeScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenHomeScoreChangeWithTap:)];
    [hiddenRightHomeScoreImageTap setNumberOfTapsRequired:1];
    [hiddenRightHomeScoreImageTap setNumberOfTouchesRequired:1];
    [hiddenRightHomeImageView addGestureRecognizer:hiddenRightHomeScoreImageTap];
    
    UITapGestureRecognizer *hiddenLeftHomeScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenHomeScoreChangeWithTap:)];
    [hiddenLeftHomeScoreImageTap setNumberOfTapsRequired:1];
    [hiddenLeftHomeScoreImageTap setNumberOfTouchesRequired:1];
    [hiddenLeftHomeImageView addGestureRecognizer:hiddenLeftHomeScoreImageTap];
    //4
    UITapGestureRecognizer *hiddenRightGuestScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGuestScoreChangeWithTap:)];
    [hiddenRightGuestScoreImageTap setNumberOfTapsRequired:1];
    [hiddenRightGuestScoreImageTap setNumberOfTouchesRequired:1];
    [hiddenRightGuestImageView addGestureRecognizer:hiddenRightGuestScoreImageTap];
    
    UITapGestureRecognizer *hiddenLeftGuestScoreImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGuestScoreChangeWithTap:)];
    [hiddenLeftGuestScoreImageTap setNumberOfTapsRequired:1];
    [hiddenLeftGuestScoreImageTap setNumberOfTouchesRequired:1];
    [hiddenLeftGuestImageView addGestureRecognizer:hiddenLeftGuestScoreImageTap];
    
    UITapGestureRecognizer *VolleyBallTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTheVolleyBallView:)];
    [VolleyBallTap setNumberOfTapsRequired:1];
    [VolleyBallTap setNumberOfTouchesRequired:1];
    [VolleyBallView addGestureRecognizer:VolleyBallTap];
    
    
    UITapGestureRecognizer *DigitalBoardTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTheDigitalScoreBoard:)];
    [DigitalBoardTap setNumberOfTapsRequired:1];
    [DigitalBoardTap setNumberOfTouchesRequired:1];
    [DigitalScoreboard addGestureRecognizer:DigitalBoardTap];
    
    
    UITapGestureRecognizer *Theme1ScoreboardTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTheTheme1:)];
    [Theme1ScoreboardTap setNumberOfTapsRequired:1];
    [Theme1ScoreboardTap setNumberOfTouchesRequired:1];
    [DigitalScoreboardNewtheme1 addGestureRecognizer:Theme1ScoreboardTap];
    
    
    UITapGestureRecognizer *Theme2ScoreBoardTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTheTheme2:)];
    [Theme2ScoreBoardTap setNumberOfTapsRequired:1];
    [Theme2ScoreBoardTap setNumberOfTouchesRequired:1];
    [DigitalScoreBordNewTheme2 addGestureRecognizer:Theme2ScoreBoardTap];
    
    
    UITapGestureRecognizer *Theme3ScoreBoardTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTheTheme3:)];
    [Theme3ScoreBoardTap setNumberOfTapsRequired:1];
    [Theme3ScoreBoardTap setNumberOfTouchesRequired:1];
    [DigitalScoreBordNewTheme3 addGestureRecognizer:Theme3ScoreBoardTap];
    
}
- (IBAction)volleyBackButtonClick:(id)sender {
    NSLog(@"VolleyBallview Tapped");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [backVollayButton setHidden:NO];
    [button3 setHidden:NO];
    [m_pMainBluetoothButton setHidden:NO];
    [backVollayButton setHidden:YES];
    [button3 setHidden:YES];
    //    [backButton setHidden:YES];
    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    [button3 setUserInteractionEnabled:NO];
    [backVollayButton setUserInteractionEnabled:NO];
    
    [homeTextField setUserInteractionEnabled:NO];
    [guestTextField setUserInteractionEnabled:NO];
    [frontGuestScoreLable setUserInteractionEnabled:NO];
    [frontHomeScoreLable setUserInteractionEnabled:NO];
    [preiodLabel setUserInteractionEnabled:NO];
    preiodLabel.font=[UIFont systemFontOfSize:35 * scoreboardHeightRate] ;
    [HomeBorder setFrame:CGRectMake(229 * scoreboardWidthRate, 202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
    [GuestBorder setFrame:CGRectMake(16 * scoreboardWidthRate, 202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
    
    //    frontHomeScoreLable.font=[UIFont systemFontOfSize:LABLE_FONTSIZE-40];
    //    frontGuestScoreLable.font=[UIFont systemFontOfSize:LABLE_FONTSIZE-40];
    
    homeTextField.font = [UIFont systemFontOfSize:14 * scoreboardHeightRate];
    guestTextField.font = [UIFont systemFontOfSize:14 * scoreboardHeightRate];
    
    backVollayButton.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    button3.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    
    
    
   
    
    //        button2.frame = CGRectMake(120, 95, 25, 25);
    
    VolleyBallViewBigger = NO;
    globalVolleyBallViewBigger = NO;
    // [DigitalScoreboard setFrame:CGRectMake(450,20,320,250)];
    //        [DigitalScoreboard setFrame:CGRectMake(DigitalScoreboard.frame.origin.x-250, DigitalScoreboard.frame.origin.y, DigitalScoreboard.frame.size.width, DigitalScoreboard.frame.size.height)];
    //
    //    [VolleyBallView setFrame:CGRectMake(107.4, 80,265.3,177)];
    [VolleyBallView setFrame:CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    //    [VolleyBallBackGroundImageView setFrame:CGRectMake( 0, 0, VolleyBallView.frame.size.width,VolleyBallView.frame.size.height)];
    [VolleyBallBackGroundImageView setFrame:CGRectMake(0, 0, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    
    
    [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y + 50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
    
    [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y+50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
    
    [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y+50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
    
    regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, 0, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
    
    
    //    [preiodLabel setFrame:CGRectMake(122,-1, 20, 48)];
    [preiodLabel setFrame:CGRectMake(168 * scoreboardWidthRate, scoreboardHeightRate+6.5, 44 * scoreboardWidthRate, 53.0 * scoreboardHeightRate)];  //
    
    if (VolleyBallCourtChanged==NO) {
        
        
        [frontHomeScoreLable setFrame:CGRectMake(467 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
        [frontGuestScoreLable setFrame:CGRectMake(255 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
        [guestTextField setFrame:CGRectMake(16 * scoreboardWidthRate, 202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
        
        [homeTextField setFrame:CGRectMake(229 * scoreboardWidthRate, 202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];    }
    else{
        
        [frontGuestScoreLable setFrame:CGRectMake(467 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
        [frontHomeScoreLable setFrame:CGRectMake(255 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
        
        [homeTextField setFrame:CGRectMake(16 * scoreboardWidthRate,202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
        
        
        [guestTextField setFrame:CGRectMake(229 * scoreboardWidthRate, 202 * scoreboardHeightRate, 135 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
        
    }
    
    [self performSelector:@selector(FadeOut1) withObject:nil afterDelay:0.5];
    
    [UIView commitAnimations];
    
    
    guestTextField.alpha = 0.0;
    
    homeTextField.alpha = 0.0;
    
    [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x+105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
    [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x-105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
    
    frontHomeScoreLable.font=[UIFont systemFontOfSize:(LABLE_FONTSIZE - 15) * scoreboardHeightRate];
    frontGuestScoreLable.font=[UIFont systemFontOfSize:(LABLE_FONTSIZE - 15) * scoreboardHeightRate];
    frontGuestScoreLable.adjustsFontSizeToFitWidth = YES;
    frontHomeScoreLable.adjustsFontSizeToFitWidth = YES;
}

-(void)TapTheVolleyBallView:(UIGestureRecognizer *)gesture{
    
//    if (_carousel.toggle != 0.0f) {
//        [_carousel carouseActionContinue];
//        return;
//    }
    
    if (isAvaiableThemeTap == NO) {
        [_carousel carouseActionContinue];
        return;
    }
    
    NSLog(@"VolleyBallview Tapped");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    //    [backButton setHidden:NO];
    [backVollayButton setHidden:NO];
    [button3 setHidden:NO];
    [buttoninfo setHidden:YES];
    backVollayButton.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);

    button3.frame = CGRectMake(445 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);

    if(VolleyBallViewBigger == NO){
        
        if (self.isServer) {
            [self.game changeScoreBoard: 101];
        }
        
        if (!isBluetooth) {
            [m_pMainBluetoothButton setHidden:YES];
        }
        
        [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x-200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x+200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        /////// for first time use/////////////
        [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x-105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
        [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x+105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
        
        //        [button2 setUserInteractionEnabled:YES];
        [button3 setUserInteractionEnabled:YES];
        [backVollayButton setUserInteractionEnabled:YES];
        
        [homeTextField setUserInteractionEnabled:YES];
        [guestTextField setUserInteractionEnabled:YES];
        [frontGuestScoreLable setUserInteractionEnabled:YES];
        [frontHomeScoreLable setUserInteractionEnabled:YES];
        [preiodLabel setUserInteractionEnabled:YES];
        
        [HomeBorder setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        [GuestBorder setFrame:CGRectMake(20 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        
        
        //        [homeTextField setBackgroundColor:[UIColor redColor]];
        //        [guestTextField setBackgroundColor:[UIColor redColor]];
        
        
        //        [homeTextField setHidden:YES];
        //        [guestTextField setHidden:YES];
        
        
        //        [HomeBorder setAlpha:0.4];
        //        [GuestBorder setAlpha:0.4];
        
        homeTextField.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        guestTextField.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
            frontHomeScoreLable.font=[UIFont systemFontOfSize:(LABLE_FONTSIZE + 30) * scoreboardHeightRate];
            frontGuestScoreLable.font=[UIFont systemFontOfSize:(LABLE_FONTSIZE + 30) * scoreboardHeightRate];
        
        
        [preiodLabel setFrame:CGRectMake(212 * scoreboardWidthRate, 4 * scoreboardHeightRate-3, 57 * scoreboardWidthRate, 68 * scoreboardHeightRate)];
        preiodLabel.font=[UIFont systemFontOfSize:50 * scoreboardHeightRate] ;
        // preiodLabel.alpha=0.4;
        
        VolleyBallViewBigger = YES;
        
        globalVolleyBallViewBigger = YES;
        
        scrollView.frame=CGRectMake(-250 * scoreboardWidthRate, 0, 980 * scoreboardWidthRate, 320 * scoreboardHeightRate);
        [VolleyBallView setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        
        
        [VolleyBallBackGroundImageView setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y-50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
        
        [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y-50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
        
        [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y-50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
        
        regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, -50 * scoreboardHeightRate, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
        
        
        homeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        guestTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [homeTextField setBackgroundColor:[UIColor redColor]];
//        [guestTextField setBackgroundColor:[UIColor redColor]];
        homeTextField.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        guestTextField.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        if (VolleyBallCourtChanged == NO) {
            
            [frontHomeScoreLable setFrame:CGRectMake((frontHomeScoreLable.frame.origin.x + 57 * scoreboardWidthRate) , frontGuestScoreLable.frame.origin.y+1 * scoreboardHeightRate, (frontGuestScoreLable.frame.size.width + 42 * scoreboardWidthRate), frontGuestScoreLable.frame.size.height + 45 * scoreboardHeightRate)];
            
            [frontGuestScoreLable setFrame:CGRectMake((frontGuestScoreLable.frame.origin.x +1 * scoreboardWidthRate), frontGuestScoreLable.frame.origin.y+1 * scoreboardHeightRate, (frontGuestScoreLable.frame.size.width + 42 * scoreboardWidthRate), frontGuestScoreLable.frame.size.height + 45 * scoreboardHeightRate)];
            
            
            [homeTextField setFrame:CGRectMake(285 * scoreboardWidthRate, 252 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            [guestTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 248.5 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            
            
            
            [guestTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            [homeTextField setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            NSLog(@"/////////////////////%f, and %f",frontGuestScoreLable.frame.size.width, frontGuestScoreLable.frame.size.height);
            
        }
        else{
            
            [frontHomeScoreLable setFrame:CGRectMake((frontHomeScoreLable.frame.origin.x + 0 * scoreboardWidthRate) , frontGuestScoreLable.frame.origin.y+1 * scoreboardHeightRate, (frontGuestScoreLable.frame.size.width + 42 * scoreboardWidthRate), frontGuestScoreLable.frame.size.height + 45 * scoreboardHeightRate)];
            
            [frontGuestScoreLable setFrame:CGRectMake((frontGuestScoreLable.frame.origin.x +57 * scoreboardWidthRate), frontGuestScoreLable.frame.origin.y+1 * scoreboardHeightRate, (frontGuestScoreLable.frame.size.width + 42 * scoreboardWidthRate), frontGuestScoreLable.frame.size.height + 45 * scoreboardHeightRate)];
            
            [homeTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            [guestTextField setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        }
        
        [self performSelector:@selector(FadeOut1) withObject:nil afterDelay:0.1];
        
        [UIView commitAnimations];
        
        
        guestTextField.alpha=0.0;
        
        homeTextField.alpha=0.0;
        
    }
    else
        [UIView commitAnimations];
frontGuestScoreLable.adjustsFontSizeToFitWidth = YES;
    frontHomeScoreLable.adjustsFontSizeToFitWidth = YES;

}

-(void)FadeOut1{
    NSLog(@"its first time");
    homeTextField.alpha = 0.20;
    guestTextField.alpha = 0.20;
    [self performSelector:@selector(FadeOut2) withObject:nil afterDelay:0.1];
    
}
-(void)FadeOut2{
    homeTextField.alpha = 0.40;
    guestTextField.alpha = 0.40;
    [self performSelector:@selector(FadeOut3) withObject:nil afterDelay:0.1];
}
-(void)FadeOut3{
    homeTextField.alpha = 0.60;
    guestTextField.alpha = 0.60;
    [self performSelector:@selector(FadeOut4) withObject:nil afterDelay:0.1];
}
-(void)FadeOut4{
    homeTextField.alpha = 0.80;
    guestTextField.alpha = 0.80;
    [self performSelector:@selector(FadeOut5) withObject:nil afterDelay:0.1];
}
-(void)FadeOut5{
    homeTextField.alpha = 1.0;
    guestTextField.alpha = 1.0;
    
}

-(IBAction)backButtonClickDigiatal:(id)sender{
    
    NSLog(@"----------the Digital scoreboard Tapped-------");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [SmallButtonDigital setHidden:YES];
    [DigitalsettingButton setHidden:YES];
    
    SmallButtonDigital.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    DigitalsettingButton.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [m_pMainBluetoothButton setHidden:NO];
    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x+200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x-200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    DigitalViewBigger=NO;
    globalDigitalViewBigger = NO;
    BiggerModeDigitalActivated=NO;
    [DigitaltimerPlayandPauseButton setUserInteractionEnabled:NO];
    [DigitalsettingButton setUserInteractionEnabled:NO];
    [SmallButtonDigital setUserInteractionEnabled:NO];
    
 
    
    // [timeSetButton setFrame:CGRectMake(178 * scoreboardWidthRate, 140 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    //    [GuestBorderDigital setFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    //    [HomeBorderDigital setFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    [homeBackImageView setFrame:CGRectMake(462 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 135 * scoreboardHeightRate)];
    [guestBackImageView setFrame:CGRectMake(260 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 135 * scoreboardHeightRate)];
    
    guestTextFieldDigital.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldDigital.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    hiddenLeftGuestImageView.userInteractionEnabled=NO;
    hiddenRightGuestImageView.userInteractionEnabled=NO;
    rightHomeImageView.userInteractionEnabled=NO;
    leftHomeImageView.userInteractionEnabled=NO;
    
    
    
    [DigitalScoreboardNewtheme1 setHidden:NO];
    [DigitalScoreboard setFrame:CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    [DigitalscoreboardBackground setFrame:CGRectMake(0, 0, DigitalScoreboard.frame.size.width, DigitalScoreboard.frame.size.height)];
    
    
    
    [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y+50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
    
    [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y+50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
    
    [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y+50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
    
    regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, 0 ,190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
    
    
    scrollViewDigital.frame= CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 3200 * scoreboardHeightRate);
    scrollViewDigital.contentSize = CGSizeMake(480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    
    
    
    
    int H = 136 * scoreboardHeightRate;
    int W = 88 * scoreboardWidthRate;
    int Y = 64 * scoreboardHeightRate;
    //
    //    int tutorialy = 10;
    //    int tutorialHeight = 44 * scoreboardHeightRate;
    //    int tutorialWidth = 26 * scoreboardWidthRate;
    //
    //    int Yvalue=70 * scoreboardHeightRate;
    //    int width=76 * scoreboardWidthRate;
    //    int height=125.5 * scoreboardWidthRate;
    //    [hiddenLeftGuestImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
    //    [hiddenRightGuestImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
    //    [leftHomeImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
    //    [rightHomeImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
    //
    //    CGRect myImageRect81 = CGRectMake( 260 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    //    guestBackImageView.frame=myImageRect81;
    //
    //    CGRect myImageRect71 = CGRectMake(462 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    //    homeBackImageView.frame=myImageRect71;
    //
    //
    //
    //
    //    [tutorialImageView setFrame:CGRectMake( 182.1 * scoreboardWidthRate, 14 * scoreboardHeightRate, 14 * scoreboardWidthRate, 35 * scoreboardHeightRate)];
    //    [tutorialImageView1 setFrame:CGRectMake( 135 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    //    [tutorialImageView2 setFrame:CGRectMake( 161 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    //    [tutorialImageView3 setFrame:CGRectMake( 192 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    //    [tutorialImageView4 setFrame:CGRectMake( 218 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    //
    //    [guestTextFieldDigital setFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    //    [homeTextFieldDigital setFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    //
    int tutorialy = 29;
    int tutorialHeight = 44 * scoreboardHeightRate;
    int tutorialWidth = 26 * scoreboardWidthRate;
    
    int Yvalue=80 * scoreboardHeightRate;
    int width=76 * scoreboardWidthRate;
    int height=150 * scoreboardWidthRate;
    
    
    CGRect myImageRect81 = CGRectMake( 260 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    guestBackImageView.frame=myImageRect81;
    
    CGRect myImageRect71 = CGRectMake(462 * scoreboardWidthRate, 64 * scoreboardHeightRate, 158 * scoreboardWidthRate, 155 * scoreboardHeightRate);
    homeBackImageView.frame=myImageRect71;
    
    
    
    [tutorialImageView setFrame:CGRectMake( 183.1 * scoreboardWidthRate, 19 * scoreboardHeightRate, 14 * scoreboardWidthRate, 30 * scoreboardHeightRate)];
    [tutorialImageView1 setFrame:CGRectMake( 135 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView2 setFrame:CGRectMake( 161 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView3 setFrame:CGRectMake( 192 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    [tutorialImageView4 setFrame:CGRectMake( 218 * scoreboardWidthRate, tutorialy, tutorialWidth, tutorialHeight)];
    
    [guestTextFieldDigital setFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [homeTextFieldDigital setFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    CGRect Boders = CGRectMake(20 * scoreboardWidthRate, 225 * scoreboardHeightRate, 145 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [HomeBorderDigital setFrame:Boders];
    
    CGRect GuestBorderImage = CGRectMake(219 * scoreboardWidthRate, 225 * scoreboardHeightRate, 145 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [GuestBorderDigital setFrame:GuestBorderImage];
    
    
    
    if (DigitalScoreboardCourtChnage == NO){
        NSLog(@"its coming here");
        [hiddenLeftGuestImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
        [hiddenRightGuestImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
        [leftHomeImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
        [rightHomeImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
        
        
        [homeTextFieldDigital setFrame:HomeBorderDigital.frame];
        [guestTextFieldDigital setFrame:GuestBorderDigital.frame];
    }
    else{
        
        [hiddenLeftGuestImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
        [hiddenRightGuestImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
        [leftHomeImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
        [rightHomeImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
        
        
        [guestTextFieldDigital setFrame:HomeBorderDigital.frame];
        [homeTextFieldDigital setFrame:GuestBorderDigital.frame];
        
    }
    
    DigitaltimerPlayandPauseButton.frame = CGRectMake(130 * scoreboardWidthRate, 5 * scoreboardHeightRate, 130 * scoreboardWidthRate, 44 * scoreboardHeightRate);
    
    [self performSelector:@selector(FadeOutDigital1) withObject:nil afterDelay:0.1];
    
    [UIView commitAnimations];
    
    homeTextFieldDigital.alpha=0.0;
    guestTextFieldDigital.alpha=0.0;
    [guestTextFieldDigital setUserInteractionEnabled:NO];
    [homeTextFieldDigital setUserInteractionEnabled:NO];
    
    
    [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x+105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
    
    [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x-105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
    
}
-(void)TapTheDigitalScoreBoard:(UIGestureRecognizer *)gesture{
    
//    if (_carousel.toggle != 0.0f) {
//        [_carousel carouseActionContinue];
//        return;
//    }
    
    if (isAvaiableThemeTap == NO) {
        [_carousel carouseActionContinue];
        return;
    }
    
    [SmallButtonDigital setHidden:NO];
    [DigitalsettingButton setHidden:NO];
    [buttoninfo setHidden:YES];

    NSLog(@"the Digital scoreboard Tapped");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    if (DigitalViewBigger==NO) {
        
        if (self.isServer) {
            [self.game changeScoreBoard: 102];
        }
        
        if (!isBluetooth) {
            [m_pMainBluetoothButton setHidden:YES];
        }
        
        [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x-200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x+200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [guestTextFieldDigital setUserInteractionEnabled:YES];
        [homeTextFieldDigital setUserInteractionEnabled:YES];
        //        [SmallButtonDigital setHidden:NO];
        
        DigitalViewBigger=YES;
        globalDigitalViewBigger = YES;
        BiggerModeDigitalActivated=YES;
        
        [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x-105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
        [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x+105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
        
        int tutorialHeight = 55 * scoreboardHeightRate;
        int tutorialwidth = 32 * scoreboardWidthRate;
        int tutorialYposition = 14 * scoreboardHeightRate;
        
        [DigitaltimerPlayandPauseButton setUserInteractionEnabled:YES];
        [DigitalsettingButton setUserInteractionEnabled:YES];
        [SmallButtonDigital setUserInteractionEnabled:YES];
        
        [tutorialImageView setFrame:CGRectMake( 231 * scoreboardWidthRate, 24 * scoreboardHeightRate, 20 * scoreboardWidthRate, 35 * scoreboardHeightRate)];
        [tutorialImageView1 setFrame:CGRectMake( 172 * scoreboardWidthRate, tutorialYposition, tutorialwidth, tutorialHeight)];
        [tutorialImageView2 setFrame:CGRectMake( 202 * scoreboardWidthRate, tutorialYposition, tutorialwidth, tutorialHeight)];
        [tutorialImageView3 setFrame:CGRectMake( 246 * scoreboardWidthRate, tutorialYposition, tutorialwidth, tutorialHeight)];
        [tutorialImageView4 setFrame:CGRectMake( 276 * scoreboardWidthRate, tutorialYposition, tutorialwidth, tutorialHeight)];
        
        
        
        SmallButtonDigital.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
        
        DigitalsettingButton.frame = CGRectMake(445 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
        //        [timeSetButton setFrame:CGRectMake(225 * scoreboardWidthRate, 183 * scoreboardHeightRate, 30 * scoreboardWidthRate, 30 * scoreboardHeightRate)];
        
        [DigitaltimerPlayandPauseButton setFrame:CGRectMake(165 * scoreboardWidthRate, 7 * scoreboardHeightRate, 148 * scoreboardWidthRate, 55 * scoreboardHeightRate)];
        
        [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y-50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
        [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y-50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
        [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y-50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
        
        regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, -50 * scoreboardHeightRate, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
        
        //
        [GuestBorderDigital setFrame:CGRectMake(285 * scoreboardWidthRate, 280 * scoreboardHeightRate, 160 * scoreboardWidthRate, 24 * scoreboardHeightRate)];
        [HomeBorderDigital setFrame:CGRectMake(38 * scoreboardWidthRate, 280 * scoreboardHeightRate, 160 * scoreboardWidthRate, 24 * scoreboardHeightRate)];
        
        guestTextFieldDigital.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        homeTextFieldDigital.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        
        [DigitalScoreboard setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        [DigitalscoreboardBackground setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        scrollViewDigital.frame=CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate);
        
        scrollViewDigital.contentSize = CGSizeMake(480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
        
        int height = 160 * scoreboardHeightRate;
        int width = 92 * scoreboardWidthRate;
        int Yposition = 100 * scoreboardHeightRate;
        
        
        int borderwidth=HomeBorderDigital.frame.size.width;
        int borderheight=HomeBorderDigital.frame.size.height;
        homeTextFieldDigital.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        guestTextFieldDigital.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [homeTextFieldDigital setBackgroundColor:[UIColor redColor]];
//        [guestTextFieldDigital setBackgroundColor:[UIColor redColor]];
        homeTextFieldDigital.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        guestTextFieldDigital.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];

        if (DigitalScoreboardCourtChnage == NO) {
            
            [homeBackImageView setFrame:CGRectMake(520 * scoreboardWidthRate, Yposition , 193 * scoreboardWidthRate, 185 * scoreboardHeightRate)];
            [guestBackImageView setFrame:CGRectMake( 264 * scoreboardWidthRate, Yposition, 193 * scoreboardWidthRate, 185 * scoreboardHeightRate)];
            
            
            
            [hiddenRightGuestImageView setFrame:CGRectMake(366 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 276 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 613 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(523 * scoreboardWidthRate, Yposition, width, height)];
            
            [guestTextFieldDigital setFrame:GuestBorderDigital.frame];
            [homeTextFieldDigital setFrame:HomeBorderDigital.frame];
            
        }
        else{
            [homeBackImageView setFrame:CGRectMake(520 * scoreboardWidthRate, Yposition, 193 * scoreboardWidthRate, 185 * scoreboardHeightRate)];
            [guestBackImageView setFrame:CGRectMake( 264 * scoreboardWidthRate, Yposition, 193 * scoreboardWidthRate, 185 * scoreboardHeightRate)];
            
            [hiddenRightGuestImageView setFrame:CGRectMake(613 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 523 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 366 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(276 * scoreboardWidthRate, Yposition, width, height)];
            
            [guestTextFieldDigital setFrame:HomeBorderDigital.frame];
            [homeTextFieldDigital setFrame:GuestBorderDigital.frame];
        }
        
        
        hiddenLeftGuestImageView.userInteractionEnabled=YES;
        hiddenRightGuestImageView.userInteractionEnabled=YES;
        rightHomeImageView.userInteractionEnabled=YES;
        leftHomeImageView.userInteractionEnabled=YES;
        //timeSetButton.userInteractionEnabled = YES;
        
        [self performSelector:@selector(FadeOutDigital1) withObject:nil afterDelay:0.1];
        
        [UIView commitAnimations];
        
        homeTextFieldDigital.alpha=0.0;
        guestTextFieldDigital.alpha=0.0;
        
    }
    else
        [UIView commitAnimations];
    
}
-(void)FadeOutDigital1{
    NSLog(@"its first time");
    homeTextFieldDigital.alpha=0.20;
    guestTextFieldDigital.alpha=0.20;
    [self performSelector:@selector(FadeOutDigital2) withObject:nil afterDelay:0.1];
    
}
-(void)FadeOutDigital2{
    homeTextFieldDigital.alpha=0.40;
    guestTextFieldDigital.alpha=0.40;
    [self performSelector:@selector(FadeOutDigital3) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigital3{
    homeTextFieldDigital.alpha=0.60;
    guestTextFieldDigital.alpha=0.60;
    [self performSelector:@selector(FadeOutDigital4) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigital4{
    homeTextFieldDigital.alpha=0.80;
    guestTextFieldDigital.alpha=0.80;
    [self performSelector:@selector(FadeOutDigital5) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigital5{
    homeTextFieldDigital.alpha=1.0;
    guestTextFieldDigital.alpha=1.0;
    
}
-(IBAction)backButtonClickTheme1:(id)sender{
    
    
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [settingButtonTheme1 setHidden:YES];
    [SmallButtonTheme1 setHidden:YES];
    SmallButtonTheme1.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    settingButtonTheme1.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [m_pMainBluetoothButton setHidden:NO];
    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x+200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x-200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [Theme1PlayPauseButton setUserInteractionEnabled:NO];
    
    [scrollViewTheme1 setFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    [Periodbutton setUserInteractionEnabled:NO];
    
    
    Periodbutton.frame=CGRectMake(167 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton1.frame=CGRectMake(180 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton2.frame=CGRectMake(193* scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton3.frame=CGRectMake(206 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);

    
    
    Theme1Bigger=NO;
    globalTheme1Bigger = NO;
    [DigitalScoreboardNewtheme1 setFrame:CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    
    [DigitalScoreBoardBackGroundTheme1 setFrame:CGRectMake(0, 0, DigitalScoreboardNewtheme1.frame.size.width, DigitalScoreboardNewtheme1.frame.size.height)];
    
    [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y+50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
    
    [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y+50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
    
    [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y+50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
    
    regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, 0, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
    
    
    [GuestBorderDigitalTheme1 setFrame:CGRectMake(21 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [HomeBorderDigitalTheme1 setFrame:CGRectMake(224 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
  
    
    //resetButtonTheme1.frame = CGRectMake(178 * scoreboardWidthRate, 150 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    guestTextFieldTheme1.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme1.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    
    hiddenLeftGuestImageViewTheme1.userInteractionEnabled=NO;
    hiddenRightGuestImageViewTheme1.userInteractionEnabled=NO;
    rightHomeImageViewTheme1.userInteractionEnabled=NO;
    leftHomeImageViewTheme1.userInteractionEnabled=NO;
    guestTextFieldTheme1.userInteractionEnabled=NO;
    homeTextFieldTheme1.userInteractionEnabled=NO;
    // resetButtonTheme1.userInteractionEnabled=NO;
    settingButtonTheme1.userInteractionEnabled=NO;
    SmallButtonTheme1.userInteractionEnabled=NO;
    
 
    
    int H = 113 * scoreboardHeightRate;
    int W = 64 * scoreboardWidthRate;
    int Y = 107 * scoreboardHeightRate;
    
  
    
    if (Theme1CourtChange == NO) {
        [leftHomeImageViewTheme1 setFrame:CGRectMake(27 * scoreboardWidthRate, Y, W, H)];
        [rightHomeImageViewTheme1 setFrame:CGRectMake(90.3 * scoreboardWidthRate, Y, W, H)];
        
        
        [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(226 * scoreboardWidthRate, Y, W, H)];
        [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(289 * scoreboardWidthRate, Y, W, H)];
        
        [guestTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
        [homeTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
        
    }
    else{
        NSLog(@"its coming here");
        
        [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(27 * scoreboardWidthRate, Y, W, H)];
        [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(90.3 * scoreboardWidthRate, Y, W, H)];
        
        
        [leftHomeImageViewTheme1 setFrame:CGRectMake(226 * scoreboardWidthRate, Y, W, H)];
        [rightHomeImageViewTheme1 setFrame:CGRectMake(289 * scoreboardWidthRate, Y, W, H)];
        
        [homeTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
        [guestTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
        
    }
    
    
    int TutorialImageHeight = 66 * scoreboardHeightRate;
    int TutorialImageWidth = 45 * scoreboardWidthRate;
    int TutorialImageY = 15 * scoreboardHeightRate;
    
    [TwoDotsImagetheme1 setFrame:CGRectMake(186 * scoreboardWidthRate, 31 * scoreboardHeightRate, 7 * scoreboardWidthRate, 38 * scoreboardHeightRate)];
    [tutorialImageViewTheme11 setFrame:CGRectMake(100 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme12 setFrame:CGRectMake(138.5 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme13 setFrame:CGRectMake(195 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme14 setFrame:CGRectMake(233.5 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    Theme1PlayPauseButton.frame = CGRectMake(80 * scoreboardWidthRate, 8 * scoreboardHeightRate, 212 * scoreboardWidthRate, 76 * scoreboardHeightRate);
    
    [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x+105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
    
    [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x-105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
    
    
    [self performSelector:@selector(FadeOutDigitalTheme11) withObject:nil afterDelay:0.1];
    
    if (Theme1CourtChange == NO) {
        [GuestBorderDigitalTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [HomeBorderDigitalTheme1 setFrame:CGRectMake(223 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        CGRect myImageRect81= CGRectMake( 25 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
        CGRect myImageRect82= CGRectMake( 227 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
        HomeBackViewTheme1.frame=myImageRect82;
        
        GuestBackViewTheme1.frame= myImageRect81;
        
        
        
    }
    else{
        NSLog(@"its coming here");
        [GuestBorderDigitalTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [HomeBorderDigitalTheme1 setFrame:CGRectMake(223 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        CGRect myImageRect81= CGRectMake( 25 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
        CGRect myImageRect82= CGRectMake( 227 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
        HomeBackViewTheme1.frame=myImageRect81;
        
        GuestBackViewTheme1.frame= myImageRect82;
        
        
    }
    
    [CustomButtonForPeriod setUserInteractionEnabled:NO];
    [UIView commitAnimations];

}

-(void)TapTheTheme1:(UIGestureRecognizer *)gestur{
    
//    if (_carousel.toggle != 0.0f) {
//        [_carousel carouseActionContinue];
//        return;
//    }
    
    if (isAvaiableThemeTap == NO) {
        [_carousel carouseActionContinue];
        return;
    }
    
    [settingButtonTheme1 setHidden:NO];
    [SmallButtonTheme1 setHidden:NO];
    [buttoninfo setHidden:YES];

    NSLog(@"the Theme1 scoreboard Tapped");
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    
    if (Theme1Bigger == NO) {
        
        if (self.isServer) {
            [self.game changeScoreBoard: 103];
        }
        
        if (!isBluetooth) {
            [m_pMainBluetoothButton setHidden:YES];
        }
        
        [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x-200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x+200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x-105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
        
        [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x+105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
        
        [CustomButtonForPeriod setUserInteractionEnabled:YES];
        
        [scrollViewTheme1 setFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        Theme1Bigger=YES;
        globalTheme1Bigger = YES;
        [Theme1PlayPauseButton setUserInteractionEnabled:YES];
        Theme1PlayPauseButton.frame = CGRectMake(110 * scoreboardWidthRate, 10 * scoreboardHeightRate, 258 * scoreboardWidthRate, 96 * scoreboardHeightRate);
        [DigitalScoreBoardBackGroundTheme1 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        [DigitalScoreboardNewtheme1 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        // resetButtonTheme1.frame = CGRectMake(225 * scoreboardWidthRate, 183 * scoreboardHeightRate, 30 * scoreboardWidthRate, 30 * scoreboardHeightRate);
        
        
        
        
        SmallButtonTheme1.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
        
        settingButtonTheme1.frame = CGRectMake(445 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
        
        
        [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y-50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
        
        [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y-50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
        
        [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y-50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
        
        regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, -50 * scoreboardHeightRate, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
        
        
        
        
        
        guestTextFieldTheme1.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        homeTextFieldTheme1.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        
        
        hiddenLeftGuestImageViewTheme1.userInteractionEnabled=YES;
        hiddenRightGuestImageViewTheme1.userInteractionEnabled=YES;
        rightHomeImageViewTheme1.userInteractionEnabled=YES;
        leftHomeImageViewTheme1.userInteractionEnabled=YES;
        guestTextFieldTheme1.userInteractionEnabled=YES;
        homeTextFieldTheme1.userInteractionEnabled=YES;
        //  resetButtonTheme1.userInteractionEnabled=YES;
        settingButtonTheme1.userInteractionEnabled=YES;
        SmallButtonTheme1.userInteractionEnabled=YES;
        
        
        int TutorialImageHeight=75 * scoreboardHeightRate;
        int TutorialImageWidth=50 * scoreboardWidthRate;
        int TutorialImageY=21 * scoreboardHeightRate;
        
        
        [TwoDotsImagetheme1 setFrame:CGRectMake(235 * scoreboardWidthRate, 36 * scoreboardHeightRate, 7 * scoreboardWidthRate, 50 * scoreboardHeightRate)];
        
        
        [tutorialImageViewTheme11 setFrame:CGRectMake(131 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
        [tutorialImageViewTheme12 setFrame:CGRectMake(180 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
        [tutorialImageViewTheme13 setFrame:CGRectMake(246 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
        [tutorialImageViewTheme14 setFrame:CGRectMake(296 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
        
        //
        //          [PeriodButton3 setHidden:NO];
        //        [PeriodButton2 setHidden:NO];
        //            [PeriodButton1 setHidden:NO];
        
        Periodbutton.frame = CGRectMake(210 * scoreboardWidthRate, 148 * scoreboardHeightRate, 14 * scoreboardWidthRate, 14 * scoreboardHeightRate);
        PeriodButton1.frame = CGRectMake(227 * scoreboardWidthRate, 148 * scoreboardHeightRate, 14 * scoreboardWidthRate, 14 * scoreboardHeightRate);
        PeriodButton2.frame = CGRectMake(243 * scoreboardWidthRate, 148 * scoreboardHeightRate, 14 * scoreboardWidthRate, 14 * scoreboardHeightRate);
        PeriodButton3.frame = CGRectMake(260 * scoreboardWidthRate, 148 * scoreboardHeightRate, 14 * scoreboardWidthRate, 14 * scoreboardHeightRate);
        
        
        
        
        
        
        [GuestBorderDigitalTheme1 setFrame:CGRectMake(31 * scoreboardWidthRate, 282 * scoreboardHeightRate, 166 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [HomeBorderDigitalTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, 282 * scoreboardHeightRate, 166 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        
        int H = 138 * scoreboardHeightRate;
        int W = 82 * scoreboardWidthRate;
        int Y = 132 * scoreboardHeightRate;
        
        
        
        homeTextFieldTheme1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        guestTextFieldTheme1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [homeTextFieldTheme1 setBackgroundColor:[UIColor redColor]];
//        [guestTextFieldTheme1 setBackgroundColor:[UIColor redColor]];
        homeTextFieldTheme1.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        guestTextFieldTheme1.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        
        
        
        ////////////////////////////////============================
        if (Theme1CourtChange == NO) {
            
            NSLog(@"the court change is BIG No");
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(364 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(33 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [guestTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [GuestBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate,395,686)];
            [HomeBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate, 395,686)];
        }
        else{
            NSLog(@"the court change is BIG No");
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(33 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(364* scoreboardWidthRate, Y, W, H)];
            
            [guestTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [homeTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [GuestBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate,195,186)];
            [HomeBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate, 195,186)];
            
        }
        
        [Periodbutton setUserInteractionEnabled:NO];
        [self performSelector:@selector(FadeOutDigitalTheme11) withObject:nil afterDelay:0.1];
        
        [UIView commitAnimations];
        
        homeTextFieldTheme1.alpha = 0.0;
        guestTextFieldTheme1.alpha = 0.0;
    }
    else
        [UIView commitAnimations];

    
}
-(void)FadeOutDigitalTheme11{
    NSLog(@"its first time");
    homeTextFieldTheme1.alpha=0.20;
    guestTextFieldTheme1.alpha=0.20;
    [self performSelector:@selector(FadeOutDigitalTheme12) withObject:nil afterDelay:0.1];
    
}
-(void)FadeOutDigitalTheme12{
    homeTextFieldTheme1.alpha=0.40;
    guestTextFieldTheme1.alpha=0.40;
    [self performSelector:@selector(FadeOutDigitalTheme13) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme13{
    homeTextFieldTheme1.alpha=0.60;
    guestTextFieldTheme1.alpha=0.60;
    [self performSelector:@selector(FadeOutDigitalTheme14) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme14{
    homeTextFieldTheme1.alpha=0.80;
    guestTextFieldTheme1.alpha=0.80;
    [self performSelector:@selector(FadeOutDigitalTheme15) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme15{
    homeTextFieldTheme1.alpha=1.0;
    guestTextFieldTheme1.alpha=1.0;
    
}
-(IBAction)backButtonClickTheme2:(id)sender{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    //    [SmallButtonTheme2 setHidden:YES];
    [Theme2Setting setHidden:YES];
    [Theme2Reset setHidden:YES];
    Theme2Reset.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme2Setting.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [m_pMainBluetoothButton setHidden:NO];
    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x+200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x-200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [Theme2LeftHomeImageview setUserInteractionEnabled:NO];
    [Theme2LeftGuestImageview setUserInteractionEnabled:NO];
    [Theme2RightGuestImageView setUserInteractionEnabled:NO];
    [Theme2RightHomeImageView  setUserInteractionEnabled:NO];
    [guestTextFieldTheme2 setUserInteractionEnabled:NO];
    [homeTextFieldTheme2 setUserInteractionEnabled:NO];
    
    Theme2ViewBigger = NO;
    globalTheme2ViewBigger = NO;
    
    [Theme2Setting setUserInteractionEnabled:NO];
    [Theme2Reset setUserInteractionEnabled:NO];
  
    
    [DigitalScoreBordNewTheme2 setFrame:CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    
    [DigitalScoreBoardBackGroundTheme2 setFrame:CGRectMake(0, 0, DigitalScoreBordNewTheme2.frame.size.width, DigitalScoreBordNewTheme2.frame.size.height)];
    
    [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y+50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
    
    [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y+50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
    
    [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y+50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
    
    regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, 0 ,190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
    
    
    [HomeBorderDigitalTheme2 setFrame:CGRectMake(213 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [GuestBorderDigitalTheme2 setFrame:CGRectMake(33 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];

    
    [ScrollViewTheme2 setFrame:CGRectMake(-265 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    
    guestTextFieldTheme2.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme2.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    
    
    
    
    int H = 150 * scoreboardHeightRate;
    int W = 82 * scoreboardWidthRate;
    int Y = 55 * scoreboardHeightRate;
    if(Theme2CourtChange == YES){
        
        [GuestBackViewTheme2 setFrame:CGRectMake(200 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate)];
        [HomeBackViewTheme2 setFrame:CGRectMake(20 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate)];
        [Theme2LeftGuestImageview setFrame:CGRectMake(199 * scoreboardWidthRate, Y, W, H)];
        [Theme2RightGuestImageView setFrame:CGRectMake(279 * scoreboardWidthRate,Y, W, H)];
        
        [Theme2LeftHomeImageview setFrame:CGRectMake(19 * scoreboardWidthRate, Y, W, H)];
        [Theme2RightHomeImageView setFrame:CGRectMake(99 * scoreboardWidthRate, Y, W, H)];
        
        
        [homeTextFieldTheme2 setFrame:CGRectMake(36 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [guestTextFieldTheme2 setFrame:CGRectMake(212 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        
    }
    else{
        [GuestBackViewTheme2 setFrame:CGRectMake(20 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate)];
        [HomeBackViewTheme2 setFrame:CGRectMake(200 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate)];
        [Theme2LeftGuestImageview setFrame:CGRectMake(19 * scoreboardWidthRate, Y, W, H)];
        [Theme2RightGuestImageView setFrame:CGRectMake(99 * scoreboardWidthRate, Y, W, H)];
        
        [Theme2LeftHomeImageview setFrame:CGRectMake(199 * scoreboardWidthRate, Y, W, H)];
        [Theme2RightHomeImageView setFrame:CGRectMake(279 * scoreboardWidthRate, Y, W, H)];
        
        
        [homeTextFieldTheme2 setFrame:CGRectMake(212 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [guestTextFieldTheme2 setFrame:CGRectMake(36 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        
    }
    
    [self performSelector:@selector(FadeOutDigitalTheme21) withObject:nil afterDelay:0.1];
    
    [UIView commitAnimations];
    
    [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x+105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
    [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x-105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
    
}
-(void)TapTheTheme2:(UIGestureRecognizer *)gestur{
    [Theme2Setting setHidden:NO];
    [Theme2Reset setHidden:NO];
//    if (_carousel.toggle != 0.0f) {
//        [_carousel carouseActionContinue];
//        return;
//    }
    
    if (isAvaiableThemeTap == NO) {
        [_carousel carouseActionContinue];
        return;
    }
    
    [buttoninfo setHidden:YES];

    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    
    if (Theme2ViewBigger==NO) {
        
        if (self.isServer) {
            [self.game changeScoreBoard: 104];
        }
        
        if (!isBluetooth) {
            [m_pMainBluetoothButton setHidden:YES];
        }
        
        [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x-200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x+200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x-105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
        
        [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x+105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
        
        [Theme2LeftHomeImageview setUserInteractionEnabled:YES];
        [Theme2LeftGuestImageview setUserInteractionEnabled:YES];
        [Theme2RightGuestImageView setUserInteractionEnabled:YES];
        [Theme2RightHomeImageView  setUserInteractionEnabled:YES];
        [guestTextFieldTheme2 setUserInteractionEnabled:YES];
        [homeTextFieldTheme2 setUserInteractionEnabled:YES];
        Theme2ViewBigger=YES;
        globalTheme2ViewBigger = YES;
        [Theme2Setting setUserInteractionEnabled:YES];
        [Theme2Reset setUserInteractionEnabled:YES];
        [DigitalScoreBordNewTheme2 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        [DigitalScoreBoardBackGroundTheme2 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        
        [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y-50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
        
        [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y-50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
        
        [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y-50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
        regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, -50 * scoreboardHeightRate, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
        
       
        
        
        Theme2Reset.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
        
        Theme2Setting.frame = CGRectMake(445 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);

        guestTextFieldTheme2.font = [UIFont systemFontOfSize:18 * scoreboardHeightRate];
        homeTextFieldTheme2.font = [UIFont systemFontOfSize:18 * scoreboardHeightRate];
        
        
        guestTextFieldTheme2.textAlignment = UITextAlignmentCenter;
        homeTextFieldTheme2.textAlignment = UITextAlignmentCenter;
        
        
        [HomeBorderDigitalTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [GuestBorderDigitalTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        
        [ScrollViewTheme2 setFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        
        
        int H = 200 * scoreboardHeightRate;
        int W = 114 * scoreboardWidthRate;
        int Y = 59 * scoreboardHeightRate;
        //        [homeTextFieldTheme2 setBackgroundColor:[UIColor redColor]];
        //        [guestTextFieldTheme2 setBackgroundColor:[UIColor redColor]];
        homeTextFieldTheme2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        guestTextFieldTheme2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//       [homeTextFieldTheme2 setBackgroundColor:[UIColor redColor]];
//       [guestTextFieldTheme2 setBackgroundColor:[UIColor redColor]];
        homeTextFieldTheme2.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        guestTextFieldTheme2.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        if(Theme2CourtChange == YES){
            
            [GuestBackViewTheme2 setFrame:CGRectMake(260 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [HomeBackViewTheme2 setFrame:CGRectMake(8 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [Theme2LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(368 * scoreboardWidthRate,Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(0 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(110 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
        }
        else{
            [GuestBackViewTheme2 setFrame:CGRectMake(8 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [HomeBackViewTheme2 setFrame:CGRectMake(260 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate,199 * scoreboardHeightRate)];
            [Theme2LeftGuestImageview setFrame:CGRectMake(0 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(110 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(256 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(366 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
        }
        
        
        [self performSelector:@selector(FadeOutDigitalTheme21) withObject:nil afterDelay:0.1];
        
        [UIView commitAnimations];
        
        homeTextFieldTheme2.alpha=0.0;
        guestTextFieldTheme2.alpha=0.0;
    }
    else
        [UIView commitAnimations];

    
}
-(void)FadeOutDigitalTheme21{
    NSLog(@"its first time");
    homeTextFieldTheme2.alpha=0.20;
    guestTextFieldTheme2.alpha=0.20;
    [self performSelector:@selector(FadeOutDigitalTheme22) withObject:nil afterDelay:0.1];
    
}
-(void)FadeOutDigitalTheme22{
    homeTextFieldTheme2.alpha=0.40;
    guestTextFieldTheme2.alpha=0.40;
    [self performSelector:@selector(FadeOutDigitalTheme23) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme23{
    homeTextFieldTheme2.alpha=0.60;
    guestTextFieldTheme2.alpha=0.60;
    [self performSelector:@selector(FadeOutDigitalTheme24) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme24{
    homeTextFieldTheme2.alpha=0.80;
    guestTextFieldTheme2.alpha=0.80;
    [self performSelector:@selector(FadeOutDigitalTheme25) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme25{
    homeTextFieldTheme2.alpha=1.0;
    guestTextFieldTheme2.alpha=1.0;
    
}
-(void)TapTheTheme3:(UIGestureRecognizer *)gestur{
    [Theme3SettingNEW setHidden:NO];
    [Theme3ResetNew setHidden:NO];
    [buttoninfo setHidden:YES];
    
    

//    if (_carousel.toggle != 0.0f) {
//        [_carousel carouseActionContinue];
//        return;
//    }
    
    if (isAvaiableThemeTap == NO) {
        [_carousel carouseActionContinue];
        return;
    }
    
    if (!isBluetooth) {
        [m_pMainBluetoothButton setHidden:YES];
    }
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    Theme3ResetNew.frame = CGRectMake(8 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme3SettingNEW.frame = CGRectMake(445 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);

    if (Theme3ViewBigger == NO) {
        
        if (self.isServer) {
            [self.game changeScoreBoard: 105];
        }
        
        [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x-200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x+200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
        
        [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x-105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
        [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x+105) * scoreboardWidthRate, RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
        
        [SmallButtonTheme3 setUserInteractionEnabled:YES];
        [SmallButtonTheme3 setHidden:NO];
        [Theme3LeftHomeImageview setUserInteractionEnabled:YES];
        [Theme3LeftGuestImageview setUserInteractionEnabled:YES];
        [Theme3RightGuestImageView setUserInteractionEnabled:YES];
        [Theme3RightHomeImageView  setUserInteractionEnabled:YES];
        [guestTextFieldTheme3 setUserInteractionEnabled:YES];
        [homeTextFieldTheme3 setUserInteractionEnabled:YES];
        
        [self.guestLeftFlipView setUserInteractionEnabled:YES];
        [self.guestRightFlipView setUserInteractionEnabled:YES];
        [self.homeLeftFlipView setUserInteractionEnabled:YES];
        [self.homeRightFlipView setUserInteractionEnabled:YES];
        
        Theme3ViewBigger=YES;
        globalTheme3ViewBigger = YES;
        [Theme3Setting setUserInteractionEnabled:YES];
        [Theme3Reset setUserInteractionEnabled:YES];
        //        [DigitalScoreBordNewTheme2 setFrame:CGRectMake(905.4, 0,480,320)];
        [DigitalScoreBordNewTheme3 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        [DigitalScoreBoardBackGroundTheme3 setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        
        [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y-50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
        
        [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y-50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
        
        [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y-50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
        
        regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, -50 * scoreboardHeightRate, 190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
        
       
            guestTextFieldTheme3.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        homeTextFieldTheme3.font = [UIFont systemFontOfSize:20 * scoreboardHeightRate];
        
        [HomeBorderDigitalTheme3 setFrame:CGRectMake(285 * scoreboardWidthRate, 22.4 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        [GuestBorderDigitalTheme3 setFrame:CGRectMake(45 * scoreboardWidthRate, 22.4 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        
        [ScrollViewTheme3 setFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
        
        int H = 210 * scoreboardHeightRate;
        int W = 103 * scoreboardWidthRate;
        int Y = 78 * scoreboardHeightRate;
        homeTextFieldTheme3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        guestTextFieldTheme3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [homeTextFieldTheme3 setBackgroundColor:[UIColor redColor]];
//        [guestTextFieldTheme3 setBackgroundColor:[UIColor redColor]];
        homeTextFieldTheme3.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        guestTextFieldTheme3.font = [UIFont systemFontOfSize:15 * scoreboardHeightRate];
        if (Theme3CourtChange == NO) {
            [Theme3LeftGuestImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            [guestTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
            
            
        }
        else{
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            //            [Flip3LeftHomeImageview setFrame:CGRectMake(255, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(124 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(124 * scoreboardWidthRate, Y, W, H)];
            
            
            [guestTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            [homeTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
            
        }
        
        [self performSelector:@selector(FadeOutDigitalTheme31) withObject:nil afterDelay:0.1];
        
        [UIView commitAnimations];
        
    }
    else
        [UIView commitAnimations];

    
}
-(void)FadeOutDigitalTheme31{
    NSLog(@"its first time");
    homeTextFieldTheme3.alpha=0.20;
    guestTextFieldTheme3.alpha=0.20;
    [self performSelector:@selector(FadeOutDigitalTheme32) withObject:nil afterDelay:0.1];
    
}
-(void)FadeOutDigitalTheme32{
    homeTextFieldTheme3.alpha=0.40;
    guestTextFieldTheme3.alpha=0.40;
    [self performSelector:@selector(FadeOutDigitalTheme33) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme33{
    homeTextFieldTheme3.alpha=0.60;
    guestTextFieldTheme3.alpha=0.60;
    [self performSelector:@selector(FadeOutDigitalTheme34) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme34{
    homeTextFieldTheme3.alpha=0.80;
    guestTextFieldTheme3.alpha=0.80;
    [self performSelector:@selector(FadeOutDigitalTheme35) withObject:nil afterDelay:0.1];
}
-(void)FadeOutDigitalTheme35{
    homeTextFieldTheme3.alpha=1.0;
    guestTextFieldTheme3.alpha=1.0;
}
#pragma mark DigitalScoreboard Actions and methods
//////////////////////////////////////////////////Digital////////////////////////////////////////////////////
-(IBAction)timerPlayandPauseButtonClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    [countdownTimerView playPauseTimer:button];
}
- (IBAction)DigitalsettingsButtonClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"scoreboardNumber"];
    
    if (!self.isServer && isBluetooth) {
        return;
    }
    [SmallButtonDigital setHidden:YES];
    [DigitalsettingButton setHidden:YES];
	BasketballSettingsViewController *basketballSettingsViewController = [[BasketballSettingsViewController alloc]  init];
    basketballSettingsViewController.homeName=homeTextField.text;
    basketballSettingsViewController.guestName=guestTextField.text;
    
    basketballSettingsViewController.m_pVolleyViewController = self;
    
	basketballSettingsViewController.homeScore =homeScoreIndex;
	basketballSettingsViewController.guestScore = guestScoreIndex;
    
    [self.view addSubview: basketballSettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [basketballSettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [basketballSettingsViewController.view setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    [UIView commitAnimations];
	
    //    [basketballSettingsViewController release];
}

- (IBAction)DigitalresetButtonClick:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:2  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    [UIView beginAnimations:nil context:nil];
  	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseIn forView:self.navigationController.view cache:YES];
	[UIView commitAnimations];
    
	UIDevice  *thisDevice = [UIDevice currentDevice];
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3SettingsViewController_iPad" bundle:nil];
    theme3SettingsViewController.delegateSetting = self;
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    theme3SettingsViewController.defaultsKey = @"SwatchColor";
    theme3SettingsViewController.guestKey = @"GuestColor";
#else
    // We re-use the current value set to the background of this demonstration view
    theme3SettingsViewController.HomeColor = HomeBackLeftViewTheme3.backgroundColor;
    theme3SettingsViewController.GuestColor = GuestBackLeftViewTheme3.backgroundColor;
    
#endif
    
    NSLog(@"Setting Dialog");
    //    [self presentModalViewController:theme3SettingsViewController animated:YES];
    
    //    [self presentViewController:theme3SettingsViewController animated:NO completion:nil];
    
    [self.view addSubview: theme3SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme3SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [theme3SettingsViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [UIView commitAnimations];
    
	
}

-(void)DigitalmoveScrollViewRight{
    
	if (DigitalViewBigger==YES) {
        int height = 160 * scoreboardHeightRate;
        int width = 92 * scoreboardWidthRate;
        int Yposition = 100 * scoreboardHeightRate;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        if (DigitalScoreboardCourtChnage == NO) {
            NSLog(@"THE COURT IS NOT CHANGED");
            
            DigitalScoreboardCourtChnage = YES;
            if( self.isServer && isBluetooth)
            {
                [self.game rightSwipeServer: 102];
            }
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            [hiddenRightGuestImageView setFrame:CGRectMake(613 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 523 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 366 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(276 * scoreboardWidthRate, Yposition, width, height)];
            int borderwidth=HomeBorderDigital.frame.size.width;
            int borderheight=HomeBorderDigital.frame.size.height;
            
            [guestTextFieldDigital setFrame:CGRectMake(38 * scoreboardWidthRate, 280 * scoreboardHeightRate,borderwidth,borderheight)];
            [homeTextFieldDigital setFrame:CGRectMake(285 * scoreboardWidthRate, 280 * scoreboardHeightRate, borderwidth,borderheight)];
            
            
            
        }
        
        
        
        [UIView commitAnimations];
        
    }
}
-(void)DigitalMoveScrollViewLeft{
	
    if (DigitalViewBigger==YES) {
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        int height = 160 * scoreboardHeightRate;
        int width = 92 * scoreboardWidthRate;
        int Yposition = 100 * scoreboardHeightRate;
        
        NSLog(@"The digital scroll view center when sroll Left%f",scrollViewDigital.center.x);
        if (DigitalScoreboardCourtChnage==YES) {
            NSLog(@"THE COURT IS CHANGED ");
            
            DigitalScoreboardCourtChnage=NO;
            if( self.isServer && isBluetooth)
            {
                [self.game leftSwipeServer: 102];
            }
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            [hiddenRightGuestImageView setFrame:CGRectMake(366 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 276 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 613 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(523 * scoreboardWidthRate, Yposition, width, height)];
            
            int borderwidth=HomeBorderDigital.frame.size.width;
            int borderheight=HomeBorderDigital.frame.size.height;
            
            [guestTextFieldDigital setFrame:CGRectMake(285 * scoreboardWidthRate, 280 * scoreboardHeightRate,borderwidth,borderheight)];
            [homeTextFieldDigital setFrame:CGRectMake(38 * scoreboardWidthRate, 280 * scoreboardHeightRate, borderwidth,borderheight)];
            
        }
        [UIView commitAnimations];
	}
    
}
#pragma mark Image view score change methods
-(void)rightHomeImageViewScoreUp{
	
	selectedImageViewName = @"rightHomeImageView";
	homeScoreIndex += 1;
	if (homeScoreIndex > 99) {
		homeScoreIndex = 99;
	}
	
	[self homeScoreChange];
}
-(void)rightHomeImageViewScoreDown{
	selectedImageViewName = @"rightHomeImageView";
	homeScoreIndex -= 1;
	
	[self homeScoreChange];
}
-(void)leftHomeImageViewScoreUp{
	selectedImageViewName = @"leftHomeImageView";
	homeScoreIndex += 1;
	if (homeScoreIndex > 99) {
		homeScoreIndex = 99;
	}
	
	[self homeScoreChange];
}
-(void)leftHomeImageViewScoreDown{
	selectedImageViewName = @"leftHomeImageView";
	homeScoreIndex -=1;
	[self homeScoreChange];
}
-(void)rightGuestImageViewScoreUp{
	selectedImageViewName = @"rightGuestImageView";
	guestScoreIndex +=1;
	if (homeScoreIndex>99) {
		homeScoreIndex=99;
	}
	[self guestScoreChange];
}
-(void)rightGuestImageViewScoreDown{
	selectedImageViewName = @"rightGuestImageView";
	guestScoreIndex -=1;
	[self guestScoreChange];
}
-(void)leftGuestImageViewScoreUp{
	selectedImageViewName = @"leftGuestImageView";
	guestScoreIndex +=1;
	[self guestScoreChange];
}
-(void)leftGuestImageViewScoreDown{
	selectedImageViewName = @"leftGuestImageView";
	guestScoreIndex -=1;
	[self guestScoreChange];
}
#pragma mark hidden image scroll methods
-(void)hiddenRightHomeImageViewScoreUp{
	selectedImageViewName = @"hiddenRightHomeImageView";
	homeScoreIndex +=1;
	[self homeScoreChange];
}
-(void)hiddenRightHomeImageViewScoreDown{
	selectedImageViewName = @"hiddenRightHomeImageView";
	homeScoreIndex -=1;
	[self homeScoreChange];
}
-(void)hiddenLeftHomeImageViewScoreUp{
	selectedImageViewName = @"hiddenLeftHomeImageView";
	homeScoreIndex +=1;
	[self homeScoreChange];
}
-(void)hiddenLeftHomeImageViewScoreDown{
	selectedImageViewName = @"hiddenLeftHomeImageView";
	homeScoreIndex -=1;
	[self homeScoreChange];
}
-(void)hiddenRightGuestImageViewScoreUp{
	selectedImageViewName = @"hiddenRightGuestImageView";
	guestScoreIndex +=1;
	[self guestScoreChange];
}
-(void)hiddenRightGuestImageViewScoreDown{
	selectedImageViewName = @"hiddenRightGuestImageView";
	guestScoreIndex -=1;
	[self guestScoreChange];
}
-(void)hiddenLeftGuestImageViewScoreUp{
	selectedImageViewName = @"hiddenLeftGuestImageView";
	guestScoreIndex +=1;
	
	[self guestScoreChange];
}
-(void)hiddenLeftGuestImageViewScoreDown{
	selectedImageViewName = @"hiddenLeftGuestImageView";
	guestScoreIndex -=1;
	[self guestScoreChange];
}
-(void)homeScoreChange
{
    
	if (homeScoreIndex > 99) {
		homeScoreIndex = 99;
		return;
	}
    
	if (homeScoreIndex < 0) {
		homeScoreIndex = 0;
	}
	
	if(homeScoreIndex < 100)
	{
        
        if( self.isServer )
        {
            [self.game homeScoreServerChange: homeScoreIndex];
        } else {
            return;
        }
        
		int temp=homeScoreIndex;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		
		[self setupImage:hiddenRightHomeImageView :secondDigit];
		[self setupImage:rightHomeImageView :secondDigit];
		
		
		
		if (firstDigit!=0)
		{
			[self setupImage:hiddenLeftHomeImageView :firstDigit];
			[self setupImage:leftHomeImageView :firstDigit];
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
		}
		
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHome)];
		[UIView commitAnimations];
		
		homeScoreFirstDigit = firstDigit;
	}
	
}
-(void)dimUpHome{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
	[hiddenRightHomeImageView setAlpha:1.0];
	[hiddenLeftHomeImageView setAlpha:1.0];
	[rightHomeImageView setAlpha:1.0];
	[leftHomeImageView setAlpha:1.0];
	[UIView commitAnimations];
}
-(void)ChangeColor{
    int tempHome=homeScoreIndex;
    
    int secondDigitHome = tempHome % 10;
    tempHome = tempHome / 10;
    int firstDigitHome = tempHome;
    
    int temp=guestScoreIndex;
    
    int secondDigit = temp % 10;
    temp = temp / 10;
    int firstDigit = temp;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1){
        
        hiddenLeftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",firstDigit]];
        leftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",firstDigit]];
        
        
        hiddenRightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",secondDigit]];
        rightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",secondDigit]];
        
        
        hiddenLeftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",firstDigitHome]];
        leftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",firstDigitHome]];
        
        
        hiddenRightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",secondDigitHome]];
        rightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot-%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2){
        hiddenLeftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",firstDigit]];
        leftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",firstDigit]];
        
        hiddenRightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",secondDigit]];
        rightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",secondDigit]];
        
        hiddenLeftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",firstDigitHome]];
        leftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",firstDigitHome]];
        
        hiddenRightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",secondDigitHome]];
        rightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotBlue%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3){
        hiddenLeftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",firstDigit]];
        leftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",firstDigit]];
        
        hiddenRightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",secondDigit]];
        rightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",secondDigit]];
        
        
        hiddenLeftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",firstDigitHome]];
        leftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",firstDigitHome]];
        
        hiddenRightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",secondDigitHome]];
        rightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotYellow%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4){
        hiddenLeftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",firstDigit]];
        leftGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",firstDigit]];
        
        hiddenRightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",secondDigit]];
        rightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",secondDigit]];
        
        hiddenLeftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",firstDigitHome]];
        leftHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",firstDigitHome]];
        
        hiddenRightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",secondDigitHome]];
        rightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dotWhite%d.png",secondDigitHome]];
    }
    
}
-(void)guestScoreChange
{
	if (guestScoreIndex > 99) {
		guestScoreIndex = 99;
		return;
	}
	if (guestScoreIndex < 0) {
		guestScoreIndex = 0;
		return;
	}
	
	if(guestScoreIndex < 100)
	{
        if( self.isServer )
        {
            [self.game guestScoreServerChange: guestScoreIndex];
        } else {
            return ;
        }
		
		int temp = guestScoreIndex;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImage:hiddenRightGuestImageView :secondDigit];
		[self setupImage:rightGuestImageView :secondDigit];
		
		if (firstDigit!= 0)
		{
			
			[self setupImage:hiddenLeftGuestImageView :firstDigit];
			[self setupImage:leftGuestImageView :firstDigit];
		}
		else
		{
            
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotBlue0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotBlue0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotYellow0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotYellow0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotWhite0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotWhite0.png"];
            }
            
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuest)];
		[UIView commitAnimations];
		
		guestScoreFirstDigit = firstDigit;
        
	}
    
}

-(void)dimUpGuest
{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[hiddenRightGuestImageView setAlpha:1.0];
	[hiddenLeftGuestImageView setAlpha:1.0];
	[rightGuestImageView setAlpha:1.0];
	[leftGuestImageView setAlpha:1.0];
	[UIView commitAnimations];
	
	
}

-(void)setupImage:(UIImageView*)imgView :(int)digit{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1) {
        
        switch (digit) {
                
            case 0:
                [imgView setImage:[UIImage imageNamed:@"dot-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"dot-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"dot-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"dot-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"dot-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"dot-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"dot-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"dot-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"dot-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"dot-9.png"]];
                break;
        }
	}
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2) {
        
        switch (digit) {
                
            case 0:
                [imgView setImage:[UIImage imageNamed:@"dotBlue0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"dotBlue1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"dotBlue2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"dotBlue3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"dotBlue4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"dotBlue5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"dotBlue6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"dotBlue7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"dotBlue8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"dotBlue9.png"]];
                break;
        }
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3) {
        
        switch (digit) {
                
            case 0:
                [imgView setImage:[UIImage imageNamed:@"dotYellow0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"dotYellow1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"dotYellow2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"dotYellow3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"dotYellow4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"dotYellow5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"dotYellow6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"dotYellow7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"dotYellow8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"dotYellow9.png"]];
                break;
        }
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4) {
        
        switch (digit) {
                
            case 0:
                [imgView setImage:[UIImage imageNamed:@"dotWhite0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"dotWhite1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"dotWhite2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"dotWhite3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"dotWhite4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"dotWhite5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"dotWhite6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"dotWhite7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"dotWhite8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"dotWhite9.png"]];
                break;
        }
    }
    
    
}

#pragma mark Tap to incerse Score
-(void)homeScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    
    selectedImageViewName = @"rightHomeImageView";
    selectedImageViewName = @"leftHomeImageView";
	homeScoreIndex += 1;
	if (homeScoreIndex > 99)
    {
		homeScoreIndex = 99;
	}
    
    [self homeScoreChange];
}

-(void)guestScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewName = @"rightGuestImageView";
    selectedImageViewName = @"leftGuestImageView";
	guestScoreIndex +=1;
	if (homeScoreIndex>99) {
		homeScoreIndex=99;
	}
	[self guestScoreChange];
    
}

-(void)hiddenHomeScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewName = @"hiddenRightHomeImageView";
    selectedImageViewName = @"hiddenLeftHomeImageView";
	homeScoreIndex +=1;
	[self homeScoreChange];
}

-(void)hiddenGuestScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewName = @"hiddenRightGuestImageView";
    selectedImageViewName = @"hiddenLeftGuestImageView";
	guestScoreIndex +=1;
	[self guestScoreChange];
}

#pragma mark------
#pragma mark Second ScoreBoard Screen designs.........

//modify by huodong

-(void)DigitalScoreboardNewtheme1ScreenDesign{
    
    CGRect Boders = CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    HomeBorderDigitalTheme1 = [[UIImageView alloc]initWithFrame:Boders];
    [HomeBorderDigitalTheme1 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreboardNewtheme1 addSubview:HomeBorderDigitalTheme1];
    
    CGRect GuestBorderImage = CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    GuestBorderDigitalTheme1 = [[UIImageView alloc]initWithFrame:GuestBorderImage];
    [GuestBorderDigitalTheme1 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreboardNewtheme1 addSubview:GuestBorderDigitalTheme1];
    
    scrollViewTheme1 = [[UIScrollView alloc] initWithFrame:CGRectMake(-250 * scoreboardWidthRate, 0, 1020 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    scrollViewTheme1.contentSize = CGSizeMake(480 * scoreboardWidthRate, 320 * scoreboardHeightRate);
    scrollViewTheme1.showsHorizontalScrollIndicator = YES;
    [scrollViewTheme1 setBackgroundColor:[UIColor clearColor]];
    
    [DigitalScoreboardNewtheme1 addSubview:scrollViewTheme1];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect = CGRectMake( 228, 10, 15, 50);
    CGRect myImageRect1 = CGRectMake( 69 * scoreboardWidthRate, 17 * scoreboardHeightRate, 35 * scoreboardWidthRate, 45 * scoreboardHeightRate);
    tutorialImageViewTheme11 = [[UIImageView alloc]initWithFrame:myImageRect1];
    [tutorialImageViewTheme11 setImage:[UIImage imageNamed:@"orange0.png"]];
    [DigitalScoreboardNewtheme1 addSubview:tutorialImageViewTheme11];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect2 = CGRectMake( 206, 10, 20, 50);
    CGRect myImageRect2 = CGRectMake( 92 * scoreboardWidthRate, 17 * scoreboardHeightRate, 35 * scoreboardWidthRate, 45 * scoreboardHeightRate);
    tutorialImageViewTheme12 = [[UIImageView alloc]initWithFrame:myImageRect2];
    [tutorialImageViewTheme12 setImage:[UIImage imageNamed:@"orange0.png"]];
    [DigitalScoreboardNewtheme1 addSubview:tutorialImageViewTheme12];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect3 = CGRectMake( 244, 10, 20, 50);
    CGRect myImageRect3 = CGRectMake( 139 * scoreboardWidthRate, 17 * scoreboardHeightRate, 35 * scoreboardWidthRate, 45 * scoreboardHeightRate);
    tutorialImageViewTheme13 = [[UIImageView alloc]initWithFrame:myImageRect3];
    [tutorialImageViewTheme13 setImage:[UIImage imageNamed:@"orange0.png"]];
    [DigitalScoreboardNewtheme1 addSubview:tutorialImageViewTheme13];
    
    self.view.backgroundColor = [UIColor clearColor];
    //CGRect myImageRect4 = CGRectMake( 265, 10, 20, 50);
    CGRect myImageRect4 = CGRectMake(171 * scoreboardWidthRate, 17 * scoreboardHeightRate, 35 * scoreboardWidthRate, 45 * scoreboardHeightRate);
    tutorialImageViewTheme14 = [[UIImageView alloc]initWithFrame:myImageRect4];
    [tutorialImageViewTheme14 setImage:[UIImage imageNamed:@"orange0.png"]];
    [DigitalScoreboardNewtheme1 addSubview:tutorialImageViewTheme14];
    
    TwoDotsImagetheme1=[[UIImageView alloc]initWithFrame:CGRectMake(127 * scoreboardWidthRate, 27 * scoreboardHeightRate, 7 * scoreboardWidthRate, 13 * scoreboardHeightRate)];
    [TwoDotsImagetheme1 setImage:[UIImage imageNamed:@"twoDot.png"]];
    [DigitalScoreboardNewtheme1 addSubview:TwoDotsImagetheme1];
    
    int TutorialImageHeight = 66 * scoreboardHeightRate;
    int TutorialImageWidth = 45 * scoreboardWidthRate;
    int TutorialImageY = 15 * scoreboardHeightRate;
    
    [TwoDotsImagetheme1 setFrame:CGRectMake(186 * scoreboardWidthRate, 31 * scoreboardHeightRate, 7 * scoreboardWidthRate, 38 * scoreboardHeightRate)];
    [tutorialImageViewTheme11 setFrame:CGRectMake(100 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme12 setFrame:CGRectMake(138.5 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme13 setFrame:CGRectMake(195 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    [tutorialImageViewTheme14 setFrame:CGRectMake(233.5 * scoreboardWidthRate, TutorialImageY, TutorialImageWidth, TutorialImageHeight)];
    
    
    countdownTimerViewTheme1.minuteImage1Theme1=tutorialImageViewTheme11;
    countdownTimerViewTheme1.minuteImage2Theme1=tutorialImageViewTheme12;
    countdownTimerViewTheme1.secondImage1Theme1=tutorialImageViewTheme13;
    countdownTimerViewTheme1.secondImage2Theme1=tutorialImageViewTheme14;
    
    
    hiddenHomeTextFieldTheme1 = [[UITextField alloc] initWithFrame:CGRectMake(70 * scoreboardWidthRate, 218 * scoreboardHeightRate, 120 * scoreboardWidthRate, 17 * scoreboardHeightRate)];
    hiddenHomeTextFieldTheme1.borderStyle = UITextBorderStyleBezel;
    hiddenHomeTextFieldTheme1.textColor = [UIColor blackColor];
    hiddenHomeTextFieldTheme1.font = [UIFont systemFontOfSize:35 * scoreboardHeightRate];
    hiddenHomeTextFieldTheme1.placeholder = @"Home";
    hiddenHomeTextFieldTheme1.textAlignment=UITextAlignmentCenter;
    hiddenHomeTextFieldTheme1.autocorrectionType = UITextAutocorrectionTypeNo;
    hiddenHomeTextFieldTheme1.backgroundColor = [UIColor clearColor];
    hiddenHomeTextFieldTheme1.keyboardType = UIKeyboardTypeDefault;
    hiddenHomeTextFieldTheme1.returnKeyType = UIReturnKeyDone;
    hiddenHomeTextFieldTheme1.clearButtonMode = UITextFieldViewModeWhileEditing;
    // [self.view addSubview:homeTextField];
    //    [scrollViewTheme1 addSubview:hiddenHomeTextFieldTheme1];
    [DigitalScoreboardNewtheme1 addSubview:hiddenHomeTextFieldTheme1];
    hiddenHomeTextFieldTheme1.delegate = self;
    
    [hiddenHomeTextFieldTheme1 setHidden:YES];
    
    guestTextFieldTheme1 = [[UITextField alloc] initWithFrame:CGRectMake(262 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    //guestTextFieldTheme1.borderStyle = UITextBorderStyleBezel;
    guestTextFieldTheme1.textColor = [UIColor whiteColor];
    guestTextFieldTheme1.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    guestTextFieldTheme1.text = @"Guest";
    guestTextFieldTheme1.textAlignment=UITextAlignmentCenter;
    guestTextFieldTheme1.backgroundColor = [UIColor clearColor];
    guestTextFieldTheme1.autocorrectionType = UITextAutocorrectionTypeNo;
    guestTextFieldTheme1.keyboardType = UIKeyboardTypeDefault;
    guestTextFieldTheme1.returnKeyType = UIReturnKeyDone;
    guestTextFieldTheme1.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    guestTextFieldTheme1.tag = 10006;
    
    //[self.view addSubview:guestTextField];
    //    [scrollViewTheme1 addSubview:guestTextFieldTheme1];
    [DigitalScoreboardNewtheme1 addSubview: guestTextFieldTheme1];
    guestTextFieldTheme1.delegate = self;
    
    
    homeTextFieldTheme1 = [[UITextField alloc] initWithFrame:CGRectMake(478 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    //homeTextFieldTheme1.borderStyle = UITextBorderStyleBezel;
    homeTextFieldTheme1.textColor = [UIColor whiteColor];
    homeTextFieldTheme1.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme1.text = @"Home";
    homeTextFieldTheme1.textAlignment=UITextAlignmentCenter;
    homeTextFieldTheme1.autocorrectionType = UITextAutocorrectionTypeNo;
    homeTextFieldTheme1.backgroundColor = [UIColor clearColor];
    homeTextFieldTheme1.keyboardType = UIKeyboardTypeDefault;
    homeTextFieldTheme1.returnKeyType = UIReturnKeyDone;
    homeTextFieldTheme1.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    homeTextFieldTheme1.tag = 10005;
    
    // [self.view addSubview:homeTextField];
    //    [scrollViewTheme1 addSubview:homeTextFieldTheme1];
    [DigitalScoreboardNewtheme1 addSubview: homeTextFieldTheme1];
    homeTextFieldTheme1.delegate = self;
    
    
    hiddenGuestTextFieldTheme1 = [[UITextField alloc] initWithFrame:CGRectMake(1335 * scoreboardWidthRate, 218 * scoreboardHeightRate, 120 * scoreboardWidthRate, 17 * scoreboardHeightRate)];
    // hiddenGuestTextFieldTheme1.borderStyle = UITextBorderStyleBezel;
    hiddenGuestTextFieldTheme1.textColor = [UIColor whiteColor];
    hiddenGuestTextFieldTheme1.font = [UIFont systemFontOfSize:35 * scoreboardHeightRate];
    hiddenGuestTextFieldTheme1.placeholder = @"Guest";
    hiddenGuestTextFieldTheme1.textAlignment=UITextAlignmentCenter;
    hiddenGuestTextFieldTheme1.backgroundColor = [UIColor blackColor];
    hiddenGuestTextFieldTheme1.autocorrectionType = UITextAutocorrectionTypeNo;
    hiddenGuestTextFieldTheme1.keyboardType = UIKeyboardTypeDefault;
    hiddenGuestTextFieldTheme1.returnKeyType = UIReturnKeyDone;
    hiddenGuestTextFieldTheme1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [DigitalScoreboardNewtheme1 addSubview:hiddenGuestTextFieldTheme1];
    hiddenGuestTextFieldTheme1.delegate = self;
    [hiddenGuestTextFieldTheme1 setHidden:YES];
    
    
    UIImage * resetImage = [UIImage imageNamed:@"Vball-reset.png"];
    resetButtonTheme1 = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButtonTheme1.frame = CGRectMake(178 * scoreboardWidthRate, 140 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [resetButtonTheme1 addTarget:self action:@selector(Theme1resetButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [resetButtonTheme1 setImage:resetImage forState:UIControlStateNormal];
    // [scrollView addSubview:resetButton];
    // [DigitalScoreboardNewtheme1 addSubview: resetButtonTheme1];
    //
    
    settingButtonTheme1=[[UIButton alloc]initWithFrame:CGRectMake(210 * scoreboardWidthRate, 145 * scoreboardHeightRate, 28 * scoreboardWidthRate, 28 * scoreboardHeightRate)];
    [settingButtonTheme1 setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [settingButtonTheme1 addTarget:self action:@selector(Theme1settingsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreboardNewtheme1 addSubview:settingButtonTheme1];
    
    SmallButtonTheme1=[[UIButton alloc]initWithFrame:CGRectMake(180 * scoreboardWidthRate, 145 * scoreboardHeightRate, 28 * scoreboardWidthRate, 28 * scoreboardHeightRate)];
    [SmallButtonTheme1 setImage:[UIImage imageNamed:@"main_menu_button.png"] forState:UIControlStateNormal];
    [SmallButtonTheme1 addTarget:self action:@selector(backButtonClickTheme1:) forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreboardNewtheme1 addSubview:SmallButtonTheme1];
    [settingButtonTheme1 setHidden:YES];
    [SmallButtonTheme1 setHidden:YES];
    
    SmallButtonTheme1.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    settingButtonTheme1.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    CustomButtonForPeriod =[[UIButton alloc]initWithFrame:CGRectMake(206 * scoreboardWidthRate, 158 * scoreboardHeightRate, 70 * scoreboardWidthRate, 18 * scoreboardHeightRate)];
    [CustomButtonForPeriod setBackgroundColor:[UIColor clearColor]];
    [CustomButtonForPeriod addTarget:self action:@selector(PeriodButtonClick:)
                    forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreboardNewtheme1 addSubview:CustomButtonForPeriod];
    
    [CustomButtonForPeriod setUserInteractionEnabled:NO];
    
    
    UIImage *PeriodButtonImage=[UIImage imageNamed:@"periodLightOn.png"];
    
    
    Periodbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    Periodbutton.frame=CGRectMake(117 * scoreboardWidthRate, 91.5 * scoreboardHeightRate, 6 * scoreboardWidthRate, 6 * scoreboardHeightRate);
    [Periodbutton addTarget:self action:@selector(PeriodButtonClick:)
           forControlEvents:UIControlEventTouchUpInside];
    [Periodbutton setImage:PeriodButtonImage forState:UIControlStateNormal];
    // [scrollView addSubview:resetButton];
    [DigitalScoreboardNewtheme1 addSubview: Periodbutton];
    
    PeriodButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    PeriodButton1.frame=CGRectMake(126 * scoreboardWidthRate, 81.5 * scoreboardHeightRate, 6 * scoreboardWidthRate, 6 * scoreboardHeightRate);
    [PeriodButton1 addTarget:self action:@selector(PeriodButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [PeriodButton1 setImage:PeriodButtonImage forState:UIControlStateNormal];
    // [scrollView addSubview:resetButton];
    [PeriodButton1 setUserInteractionEnabled:NO];
    
    [DigitalScoreboardNewtheme1 addSubview: PeriodButton1];
    
    PeriodButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    PeriodButton2.frame=CGRectMake(135 * scoreboardWidthRate, 81.5 * scoreboardHeightRate, 6 * scoreboardWidthRate, 6 * scoreboardHeightRate);
    [PeriodButton2 addTarget:self action:@selector(PeriodButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [PeriodButton2 setImage:PeriodButtonImage forState:UIControlStateNormal];
    // [scrollView addSubview:resetButton];
    [PeriodButton2 setUserInteractionEnabled:NO];
    
    [DigitalScoreboardNewtheme1 addSubview: PeriodButton2];
    
    
    PeriodButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    PeriodButton3.frame=CGRectMake(144 * scoreboardWidthRate, 81.5 * scoreboardHeightRate, 6 * scoreboardWidthRate, 6 * scoreboardHeightRate);
    [PeriodButton3 addTarget:self action:@selector(PeriodButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [PeriodButton3 setImage:PeriodButtonImage forState:UIControlStateNormal];
    // [scrollView addSubview:resetButton];
    [PeriodButton3 setUserInteractionEnabled:NO];
    
    [DigitalScoreboardNewtheme1 addSubview: PeriodButton3];
    [PeriodButton3 setHidden:YES];
    [PeriodButton2 setHidden:YES];
    [PeriodButton1 setHidden:YES];
    [Periodbutton setUserInteractionEnabled:NO];
    PeriodButtonNumber=1;
    
    UIImage *timerPlayandPauseButtonImage = [UIImage imageNamed:@"sb2_play.png"];
    Theme1PlayPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [DigitalScoreboardNewtheme1 addSubview:Theme1PlayPauseButton];
    //[scrollView addSubview:timerPlayandPauseButton];
    [Theme1PlayPauseButton addTarget:self action:@selector(timerPlayandPauseButtonClickTheme1:)
                    forControlEvents:UIControlEventTouchUpInside];
    [Theme1PlayPauseButton setImage:timerPlayandPauseButtonImage forState:UIControlStateNormal];
    [Theme1PlayPauseButton setUserInteractionEnabled:NO];
    
    
    Theme1PlayPauseButton.frame = CGRectMake(70 * scoreboardWidthRate, 6 * scoreboardHeightRate, 124 * scoreboardWidthRate, 43 * scoreboardHeightRate);
    
    Periodbutton.frame=CGRectMake(167 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton1.frame=CGRectMake(180 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton2.frame=CGRectMake(193* scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    PeriodButton3.frame=CGRectMake(206 * scoreboardWidthRate, 121 * scoreboardHeightRate, 10 * scoreboardWidthRate, 10 * scoreboardHeightRate);
    //    [PeriodButton1 setImage:PeriodButtonImage forState:UIControlStateNormal];
    //    [PeriodButton2 setImage:PeriodButtonImage forState:UIControlStateNormal];
    //    [PeriodButton3 setImage:PeriodButtonImage forState:UIControlStateNormal];
//        [PeriodButton3 setHidden:NO];
//       [PeriodButton2 setHidden:NO];
//        [PeriodButton1 setHidden:NO];
    [GuestBorderDigitalTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [HomeBorderDigitalTheme1 setFrame:CGRectMake(223 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    //    settingButtonTheme1.frame = CGRectMake(122.5,125, 20,20);
    resetButtonTheme1.frame = CGRectMake(178 * scoreboardWidthRate, 140 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    
    CGRect myImageRect7 = CGRectMake(224 * scoreboardWidthRate, 86 * scoreboardHeightRate, 131 * scoreboardWidthRate, 172 * scoreboardHeightRate);
    HomeBackViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRect7];
    HomeBackViewTheme1.backgroundColor = [UIColor blackColor];
    HomeBackViewTheme1.userInteractionEnabled=YES;
    //    [scrollViewTheme1 addSubview:HomeBackViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview:HomeBackViewTheme1];
    
    CGRect myImageRect8 = CGRectMake( 24 * scoreboardWidthRate, 86 * scoreboardHeightRate, 131 * scoreboardWidthRate, 172 * scoreboardHeightRate);
    GuestBackViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRect8];
    GuestBackViewTheme1.backgroundColor = [UIColor blackColor];
    GuestBackViewTheme1.userInteractionEnabled=YES;
    //    [scrollViewTheme1 addSubview:GuestBackViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview:GuestBackViewTheme1];
    
    self.view.backgroundColor = [UIColor clearColor];
//    [GuestBackViewTheme1 setBackgroundColor:[UIColor greenColor]];
//    [HomeBackViewTheme1 setBackgroundColor:[UIColor greenColor]];

    
    CGRect myImageRect81= CGRectMake( 25 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
    CGRect myImageRect82= CGRectMake( 227 * scoreboardWidthRate, 108 * scoreboardHeightRate, 128 * scoreboardWidthRate, 113 * scoreboardHeightRate);
    HomeBackViewTheme1.frame=myImageRect82;
    
    GuestBackViewTheme1.frame= myImageRect81;
    
    
    int H = 113 * scoreboardHeightRate;
    int W = 64 * scoreboardWidthRate;
    int Y = 107 * scoreboardHeightRate;
    
    
    
    CGRect myImageRectd = CGRectMake( 26 * scoreboardWidthRate, Y, W, H);
    leftHomeImageViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRectd];
    [leftHomeImageViewTheme1 setImage:[UIImage imageNamed:@"digital-0.png"]];
        leftHomeImageViewTheme1.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    leftHomeImageViewTheme1.userInteractionEnabled=YES;
    //[self.view addSubview:hiddenLeftGuestImageView];
    //    [scrollViewTheme1 addSubview:leftHomeImageViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview: leftHomeImageViewTheme1];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectc = CGRectMake(93.5 * scoreboardWidthRate, Y, W, H);
    rightHomeImageViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRectc];
    [rightHomeImageViewTheme1 setImage:[UIImage imageNamed:@"digital-0.png"]];
        rightHomeImageViewTheme1.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    rightHomeImageViewTheme1.userInteractionEnabled=YES;
    // [self.view addSubview:hiddenRightGuestImageView];
    //    [scrollViewTheme1 addSubview:rightHomeImageViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview:rightHomeImageViewTheme1];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectg = CGRectMake( 224 * scoreboardWidthRate, Y, W, H);
    hiddenLeftGuestImageViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRectg];
    [hiddenLeftGuestImageViewTheme1 setImage:[UIImage imageNamed:@"digital-0.png"]];
        hiddenLeftGuestImageViewTheme1.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    hiddenLeftGuestImageViewTheme1.userInteractionEnabled=YES;
    //[self.view addSubview:leftGuestImageView];
    //    [scrollViewTheme1 addSubview:hiddenLeftGuestImageViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview:hiddenLeftGuestImageViewTheme1];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRecth = CGRectMake( 289.5 * scoreboardWidthRate, Y, W, H);
    hiddenRightGuestImageViewTheme1 = [[UIImageView alloc]initWithFrame:myImageRecth];
    [hiddenRightGuestImageViewTheme1 setImage:[UIImage imageNamed:@"digital-0.png"]];
        hiddenRightGuestImageViewTheme1.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    // [self.view addSubview:rightGuestImageView];
    hiddenRightGuestImageViewTheme1.userInteractionEnabled=YES;
    //    [scrollViewTheme1 addSubview:hiddenRightGuestImageViewTheme1];
    [DigitalScoreboardNewtheme1 addSubview:hiddenRightGuestImageViewTheme1];
    
    
    [leftHomeImageViewTheme1 setFrame:CGRectMake(27 * scoreboardWidthRate, Y, W, H)];
    [rightHomeImageViewTheme1 setFrame:CGRectMake(90.3 * scoreboardWidthRate, Y, W, H)];
    
    
    [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(226 * scoreboardWidthRate, Y, W, H)];
    [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(289 * scoreboardWidthRate, Y, W, H)];
    
    [guestTextFieldTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [homeTextFieldTheme1 setFrame:CGRectMake(224 * scoreboardWidthRate, 215 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    
    UISwipeGestureRecognizer *leftSwipeUpScrollTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme1MoveScrollViewLeft)] autorelease];
	leftSwipeUpScrollTheme1.direction = UISwipeGestureRecognizerDirectionLeft;
	[DigitalScoreboardNewtheme1 addGestureRecognizer:leftSwipeUpScrollTheme1];
    //	[scrollViewTheme1 addGestureRecognizer:leftSwipeUpScrollTheme1];
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *rightSwipeDownScrollTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme1moveScrollViewRight)] autorelease];
	rightSwipeDownScrollTheme1.direction = UISwipeGestureRecognizerDirectionRight;
    //	[scrollViewTheme1 addGestureRecognizer:rightSwipeDownScrollTheme1];
	[DigitalScoreboardNewtheme1 addGestureRecognizer:rightSwipeDownScrollTheme1];
    
    
    UISwipeGestureRecognizer *rightHomeImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1rightHomeImageViewScoreUp)] autorelease];
	rightHomeImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[rightHomeImageViewTheme1 addGestureRecognizer:rightHomeImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *rightHomeImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1rightHomeImageViewScoreDown)] autorelease];
	rightHomeImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[rightHomeImageViewTheme1 addGestureRecognizer:rightHomeImageViewSwipeDownTheme1];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *leftHomeImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1leftHomeImageViewScoreUp)] autorelease];
	leftHomeImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[leftHomeImageViewTheme1 addGestureRecognizer:leftHomeImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *leftHomeImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1leftHomeImageViewScoreDown)] autorelease];
	leftHomeImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[leftHomeImageViewTheme1 addGestureRecognizer:leftHomeImageViewSwipeDownTheme1];
    
    UISwipeGestureRecognizer *rightGuestImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1rightGuestImageViewScoreUp)] autorelease];
	rightGuestImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[rightGuestImageViewTheme1 addGestureRecognizer:rightGuestImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *rightGuestImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1rightGuestImageViewScoreDown)] autorelease];
	rightGuestImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[rightGuestImageViewTheme1 addGestureRecognizer:rightGuestImageViewSwipeDownTheme1];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *leftGuestImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1leftGuestImageViewScoreUp)] autorelease];
	leftGuestImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[leftGuestImageViewTheme1 addGestureRecognizer:leftGuestImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *leftGuestImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1leftGuestImageViewScoreDown)] autorelease];
	leftGuestImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[leftGuestImageViewTheme1 addGestureRecognizer:leftGuestImageViewSwipeDownTheme1];
    
    UISwipeGestureRecognizer *hiddenRightHomeImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenRightHomeImageViewScoreUp)] autorelease];
	hiddenRightHomeImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenRightHomeImageViewTheme1 addGestureRecognizer:hiddenRightHomeImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *hiddenRightHomeImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenRightHomeImageViewScoreDown)] autorelease];
	hiddenRightHomeImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenRightHomeImageViewTheme1 addGestureRecognizer:hiddenRightHomeImageViewSwipeDownTheme1];
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenLeftHomeImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenLeftHomeImageViewScoreUp)] autorelease];
	hiddenLeftHomeImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenLeftHomeImageViewTheme1 addGestureRecognizer:hiddenLeftHomeImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *hiddenLeftHomeImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenLeftHomeImageViewScoreDown)] autorelease];
	hiddenLeftHomeImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenLeftHomeImageViewTheme1 addGestureRecognizer:hiddenLeftHomeImageViewSwipeDownTheme1];
	
    
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenRightGuestImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenRightGuestImageViewScoreUp)] autorelease];
	hiddenRightGuestImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenRightGuestImageViewTheme1 addGestureRecognizer:hiddenRightGuestImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *hiddenRightGuestImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenRightGuestImageViewScoreDown)] autorelease];
	hiddenRightGuestImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenRightGuestImageViewTheme1 addGestureRecognizer:hiddenRightGuestImageViewSwipeDownTheme1];
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *hiddenLeftGuestImageViewSwipeUpTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenLeftGuestImageViewScoreUp)] autorelease];
	hiddenLeftGuestImageViewSwipeUpTheme1.direction = UISwipeGestureRecognizerDirectionUp;
	[hiddenLeftGuestImageViewTheme1 addGestureRecognizer:hiddenLeftGuestImageViewSwipeUpTheme1];
	
	UISwipeGestureRecognizer *hiddenLeftGuestImageViewSwipeDownTheme1 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenLeftGuestImageViewScoreDown)] autorelease];
	hiddenLeftGuestImageViewSwipeDownTheme1.direction = UISwipeGestureRecognizerDirectionDown;
	[hiddenLeftGuestImageViewTheme1 addGestureRecognizer:hiddenLeftGuestImageViewSwipeDownTheme1];
    
    //tap gesture
    //1
    UITapGestureRecognizer *rightHomeScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1homeScoreChangeWithTap:)];
    [rightHomeScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [rightHomeScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [rightHomeImageViewTheme1 addGestureRecognizer:rightHomeScoreImageTapTheme1];
    
    UITapGestureRecognizer *leftHomeScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1homeScoreChangeWithTap:)];
    [leftHomeScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [leftHomeScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [leftHomeImageViewTheme1 addGestureRecognizer:leftHomeScoreImageTapTheme1];
    
    //2
    UITapGestureRecognizer *rightGuestScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1guestScoreChangeWithTap:)];
    [rightGuestScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [rightGuestScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [rightGuestImageViewTheme1 addGestureRecognizer:rightGuestScoreImageTapTheme1];
    
    UITapGestureRecognizer *leftGuestScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1guestScoreChangeWithTap:)];
    [leftGuestScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [leftGuestScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [leftGuestImageViewTheme1 addGestureRecognizer:leftGuestScoreImageTapTheme1];
    //3
    UITapGestureRecognizer *hiddenRightHomeScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenHomeScoreChangeWithTap:)];
    [hiddenRightHomeScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [hiddenRightHomeScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [hiddenRightHomeImageViewTheme1 addGestureRecognizer:hiddenRightHomeScoreImageTapTheme1];
    
    UITapGestureRecognizer *hiddenLeftHomeScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenHomeScoreChangeWithTap:)];
    [hiddenLeftHomeScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [hiddenLeftHomeScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [hiddenLeftHomeImageViewTheme1 addGestureRecognizer:hiddenLeftHomeScoreImageTapTheme1];
    //4
    UITapGestureRecognizer *hiddenRightGuestScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenGuestScoreChangeWithTap:)];
    [hiddenRightGuestScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [hiddenRightGuestScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [hiddenRightGuestImageViewTheme1 addGestureRecognizer:hiddenRightGuestScoreImageTapTheme1];
    
    UITapGestureRecognizer *hiddenLeftGuestScoreImageTapTheme1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme1hiddenGuestScoreChangeWithTap:)];
    [hiddenLeftGuestScoreImageTapTheme1 setNumberOfTapsRequired:1];
    [hiddenLeftGuestScoreImageTapTheme1 setNumberOfTouchesRequired:1];
    [hiddenLeftGuestImageViewTheme1 addGestureRecognizer:hiddenLeftGuestScoreImageTapTheme1];
    
	[self homeScoreChangeTheme1];
    [self guestScoreChangeTheme1];
    [scrollViewTheme1 bringSubviewToFront:homeTextFieldTheme1];
    [scrollViewTheme1 bringSubviewToFront:guestTextFieldTheme1];
    hiddenLeftGuestImageViewTheme1.userInteractionEnabled=NO;
    hiddenRightGuestImageViewTheme1.userInteractionEnabled=NO;
    rightHomeImageViewTheme1.userInteractionEnabled=NO;
    leftHomeImageViewTheme1.userInteractionEnabled=NO;
    guestTextFieldTheme1.userInteractionEnabled=NO;
    homeTextFieldTheme1.userInteractionEnabled=NO;
    resetButtonTheme1.userInteractionEnabled=NO;
    settingButtonTheme1.userInteractionEnabled=NO;
    [DigitalScoreboardNewtheme1 bringSubviewToFront:DigitalScoreBoardBackGroundTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:GuestBorderDigitalTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:HomeBorderDigitalTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:homeTextFieldTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:guestTextFieldTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:Periodbutton];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:PeriodButton1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:PeriodButton2];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:PeriodButton3];
    
    [DigitalScoreboardNewtheme1 bringSubviewToFront:SmallButtonTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:settingButtonTheme1];
    [DigitalScoreboardNewtheme1 bringSubviewToFront:CustomButtonForPeriod];
    
    
    homeTextFieldTheme1.frame=HomeBorderDigitalTheme1.frame;
    guestTextFieldTheme1.frame=GuestBorderDigitalTheme1.frame;
    
    
}
#pragma mark Digital New Theme 1 Actions and common actions and method
- (IBAction)Theme1resetButtonClick:(id)sender {
    if (!self.isServer && isBluetooth) {
        return;
    }
    
	[UIView beginAnimations:nil context:nil];
  	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseIn forView:self.navigationController.view cache:YES];
	[UIView commitAnimations];
    
	Theme1SettingViewController_iPhone *theme1SettingsViewController = [[Theme1SettingViewController_iPhone alloc]  init];
    
    [self.view addSubview: theme1SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme1SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    
    theme1SettingsViewController.m_pVolleyViewController = self;
    
    [UIView beginAnimations:nil context:NULL];
    
    [theme1SettingsViewController.view setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    
    [UIView commitAnimations];
	
}
-(IBAction)timerPlayandPauseButtonClickTheme1:(id)sender
{
    NSLog(@"its working");
    
    UIButton *button=(UIButton *)sender;
    [countdownTimerViewTheme1 playPauseTimer:button];
}

-(IBAction)PeriodButtonClick:(id)sender{
    if( self.isServer )
    {
        [self.game periodNumberChangeServer: PeriodButtonNumber];
    } else {
        return;
    }
    if (PeriodButtonNumber==1) {
        [PeriodButton3 setHidden:YES];
        [PeriodButton2 setHidden:YES];
        [PeriodButton1 setHidden:NO];
        
    }
    else if(PeriodButtonNumber==2){
        [PeriodButton3 setHidden:YES];
        [PeriodButton2 setHidden:NO];
        [PeriodButton1 setHidden:NO];
    }
    else if(PeriodButtonNumber==3){
        [PeriodButton3 setHidden:NO];
        [PeriodButton2 setHidden:NO];
        [PeriodButton1 setHidden:NO];
    }
    else if(PeriodButtonNumber==4){
        [PeriodButton3 setHidden:YES];
        [PeriodButton2 setHidden:YES];
        [PeriodButton1 setHidden:YES];
    }
    if(PeriodButtonNumber<4){
        PeriodButtonNumber++;
    }
    else{
        PeriodButtonNumber=1;
        
    }
}

-(void)Theme1ColorChange{
    int tempHome=homeScoreIndexTheme1;
    
    int secondDigitHome = tempHome % 10;
    tempHome = tempHome / 10;
    int firstDigitHome = tempHome;
    
    int temp=guestScoreIndexTheme1;
    
    int secondDigit = temp % 10;
    temp = temp / 10;
    int firstDigit = temp;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"] == 1){
        
        hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        leftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        
        hiddenRightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        rightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        
        hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        leftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        
        hiddenRightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
        rightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
        hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        leftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        
        hiddenRightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        rightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        
        hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        leftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        
        hiddenRightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
        rightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
        hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        leftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        
        hiddenRightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        rightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        
        hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        leftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        
        hiddenRightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
        rightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
        hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        leftGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigit]];
        
        hiddenRightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        rightGuestImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigit]];
        
        hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        leftHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",firstDigitHome]];
        
        hiddenRightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
        rightHomeImageViewTheme1.image = [UIImage imageNamed:[NSString stringWithFormat:@"digital-%d.png",secondDigitHome]];
    }
}

-(void)DigitalNewTheme1moveScrollViewRight{
    if (Theme1Bigger==YES) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
//        int H = 138 * scoreboardHeightRate;
//        int W = 87 * scoreboardWidthRate;
//        int Y = 106 * scoreboardHeightRate;
        
        if (Theme1CourtChange == NO) {
            
            if( self.isServer && isBluetooth)
            {
                [self.game rightSwipeServer: 103];
            }
            
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            Theme1CourtChange = YES;
            
          
            
            
            int H = 138 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 131 * scoreboardHeightRate;
            ////////////////////////////////============================
            
                NSLog(@"the court change is BIG No");
                
            
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(34 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate , Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(364* scoreboardWidthRate, Y, W, H)];
            
            [guestTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [homeTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [HomeBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate,395,686)];
            [GuestBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate, 395,686)];
            //
            //            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(28 * scoreboardWidthRate, Y, W, H)];
            //            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            //
            //            [leftHomeImageViewTheme1 setFrame:CGRectMake(278 * scoreboardWidthRate, Y, W, H)];
            //            [rightHomeImageViewTheme1 setFrame:CGRectMake(364 * scoreboardWidthRate, Y, W, H)];
            //
            //            [guestTextFieldTheme1 setFrame:CGRectMake(278 * scoreboardWidthRate, 257 * scoreboardHeightRate, 166 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            //            [homeTextFieldTheme1 setFrame:CGRectMake(34 * scoreboardWidthRate, 257 * scoreboardHeightRate, 166 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        }
        
        [UIView commitAnimations];
        NSLog(@"The digital scroll view center when sroll right%f", scrollViewTheme1.center.x);
        
	}
}
-(void)DigitalNewTheme1MoveScrollViewLeft{
    if (Theme1Bigger==YES) {
        
//        int H=135 * scoreboardHeightRate;
//        int W=90 * scoreboardWidthRate;
//        int Y=108 * scoreboardHeightRate;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        if (Theme1CourtChange==YES) {
            if( self.isServer && isBluetooth)
            {
                [self.game leftSwipeServer: 103];
            }
            
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            NSLog(@"Court changes NO");
            Theme1CourtChange=NO;
            int H = 138 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 131 * scoreboardHeightRate;
            ////////////////////////////////============================
            
            NSLog(@"the court change is BIG No");
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(364 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(34 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];

            
            [homeTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [guestTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
           
            
            [GuestBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate,395,686)];
            [HomeBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate, 395,686)];
        }
        
        [UIView commitAnimations];
        NSLog(@"The digital scroll view center when sroll Left%f", scrollViewTheme1.center.x);
        
	}
}
-(void)Theme1rightHomeImageViewScoreUp{
    selectedImageViewNameTheme1 = @"rightHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	if (homeScoreIndexTheme1>99) {
		homeScoreIndexTheme1=99;
	}
	
	[self homeScoreChangeTheme1];
}
-(void)Theme1rightHomeImageViewScoreDown{
    
	selectedImageViewNameTheme1 = @"rightHomeImageViewTheme1";
	homeScoreIndexTheme1 -=1;
	
	[self homeScoreChangeTheme1];
}
-(void)Theme1leftHomeImageViewScoreUp{
   	selectedImageViewNameTheme1 = @"leftHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	if (homeScoreIndexTheme1>99) {
		homeScoreIndexTheme1=99;
	}
	
	[self homeScoreChangeTheme1];
}
-(void)Theme1leftHomeImageViewScoreDown{
    
	selectedImageViewNameTheme1 = @"leftHomeImageViewTheme1";
	homeScoreIndexTheme1 -=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1rightGuestImageViewScoreUp{
    NSLog(@"Its entering into the Theme1hiddenRightHomeImageViewScoreUp ");
    
	selectedImageViewNameTheme1 = @"rightGuestImageViewTheme1";
	guestScoreIndexTheme1 +=1;
	if (homeScoreIndexTheme1>99) {
		homeScoreIndexTheme1=99;
	}
	[self guestScoreChangeTheme1];
}
-(void)Theme1rightGuestImageViewScoreDown{
	selectedImageViewNameTheme1 = @"rightGuestImageViewTheme1";
	guestScoreIndexTheme1 -=1;
	[self guestScoreChangeTheme1];
}
-(void)Theme1leftGuestImageViewScoreUp{
	selectedImageViewNameTheme1 = @"leftGuestImageViewTheme1";
	guestScoreIndexTheme1 +=1;
	[self guestScoreChangeTheme1];
}
-(void)Theme1leftGuestImageViewScoreDown{
	selectedImageViewNameTheme1 = @"leftGuestImageViewTheme1";
	guestScoreIndexTheme1 -=1;
	[self guestScoreChangeTheme1];
}
#pragma mark Tap to incerse Score
-(void)Theme1homeScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    
    selectedImageViewNameTheme1 = @"rightHomeImageViewTheme1";
    selectedImageViewNameTheme1 = @"leftHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	if (homeScoreIndexTheme1>99)
    {
		homeScoreIndexTheme1=99;
	}
    
    [self homeScoreChangeTheme1];
}
-(void)Theme1guestScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewNameTheme1 = @"rightGuestImageViewTheme1";
    selectedImageViewNameTheme1 = @"leftGuestImageViewTheme1";
	guestScoreIndexTheme1 +=1;
	if (homeScoreIndexTheme1>99) {
		homeScoreIndexTheme1=99;
	}
	[self guestScoreChangeTheme1];
    
}
-(void)Theme1hiddenHomeScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewNameTheme1 = @"hiddenRightHomeImageViewTheme1";
    selectedImageViewNameTheme1 = @"hiddenLeftHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1hiddenGuestScoreChangeWithTap:(UIGestureRecognizer *)gesture
{
    selectedImageViewNameTheme1 = @"hiddenRightGuestImageView";
    selectedImageViewNameTheme1 = @"hiddenLeftGuestImageView";
	guestScoreIndexTheme1 +=1;
	[self guestScoreChangeTheme1];
}
-(void)homeScoreChangeTheme1
{
    if (homeScoreIndexTheme1 > 99) {
		homeScoreIndexTheme1 = 99;
		return;
	}
	if (homeScoreIndexTheme1 < 0) {
		homeScoreIndexTheme1 = 0;
	}
	
	if(homeScoreIndexTheme1<100)
	{
        if( self.isServer )
        {
            [self.game homeScoreServerChange: homeScoreIndexTheme1];
        } else {
            return;
        }
		
		int temp = homeScoreIndexTheme1;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		
		[self setupImageTheme1:hiddenRightHomeImageViewTheme1 :secondDigit];
		[self setupImageTheme1:rightHomeImageViewTheme1 :secondDigit];
		
		
		
		if (firstDigit != 0)
		{
			[self setupImageTheme1:hiddenLeftHomeImageViewTheme1 :firstDigit];
			[self setupImageTheme1:leftHomeImageViewTheme1 :firstDigit];
            
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==1){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme1)];
		[UIView commitAnimations];
		
		homeScoreFirstDigitTheme1=firstDigit;
	}
}

-(void)dimUpHomeTheme1{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
	[hiddenRightHomeImageViewTheme1 setAlpha:1.0];
	[hiddenLeftHomeImageViewTheme1 setAlpha:1.0];
	[rightHomeImageViewTheme1 setAlpha:1.0];
	[leftHomeImageViewTheme1 setAlpha:1.0];
	[UIView commitAnimations];
}

-(void)guestScoreChangeTheme1
{
	if (guestScoreIndexTheme1 > 99) {
		guestScoreIndexTheme1 = 99;
		return;
	}
	if (guestScoreIndexTheme1 < 0) {
		guestScoreIndexTheme1 = 0;
		return;
	}
	
	if(guestScoreIndexTheme1 < 100)
	{
        if( self.isServer )
        {
            [self.game guestScoreServerChange: guestScoreIndexTheme1];
        } else {
            return;
        }
		int temp = guestScoreIndexTheme1;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme1:hiddenRightGuestImageViewTheme1 :secondDigit];
		[self setupImageTheme1:rightGuestImageViewTheme1 :secondDigit];
		
		if (firstDigit!=0)
		{
			
			[self setupImageTheme1:hiddenLeftGuestImageViewTheme1 :firstDigit];
			[self setupImageTheme1:leftGuestImageViewTheme1 :firstDigit];
		}
		else
		{
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==1){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                
            }
		}
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme1)];
		[UIView commitAnimations];
		
		guestScoreFirstDigitTheme1 = firstDigit;
	}
}

#pragma mark hidden image scroll methods
-(void)Theme1hiddenRightHomeImageViewScoreUp{
    
	selectedImageViewNameTheme1 = @"hiddenRightHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1hiddenRightHomeImageViewScoreDown{
	selectedImageViewNameTheme1 = @"hiddenRightHomeImageViewTheme1";
	homeScoreIndexTheme1 -=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1hiddenLeftHomeImageViewScoreUp{
	selectedImageViewNameTheme1 = @"hiddenLeftHomeImageViewTheme1";
	homeScoreIndexTheme1 +=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1hiddenLeftHomeImageViewScoreDown{
	selectedImageViewNameTheme1 = @"hiddenLeftHomeImageViewTheme1";
	homeScoreIndexTheme1 -=1;
	[self homeScoreChangeTheme1];
}
-(void)Theme1hiddenRightGuestImageViewScoreUp{
	selectedImageViewName = @"hiddenRightGuestImageView";
	guestScoreIndexTheme1 +=1;
	[self guestScoreChangeTheme1];
}
-(void)Theme1hiddenRightGuestImageViewScoreDown{
	selectedImageViewNameTheme1 = @"hiddenRightGuestImageViewTheme1";
	guestScoreIndexTheme1 -=1;
	[self guestScoreChangeTheme1];
}
-(void)Theme1hiddenLeftGuestImageViewScoreUp{
	selectedImageViewNameTheme1 = @"hiddenLeftGuestImageViewTheme1";
	guestScoreIndexTheme1 +=1;
	
	[self guestScoreChangeTheme1];
}
-(void)Theme1hiddenLeftGuestImageViewScoreDown{
	selectedImageViewNameTheme1 = @"hiddenLeftGuestImageViewTheme1";
	guestScoreIndexTheme1 -=1;
	[self guestScoreChangeTheme1];
}
-(void)dimUpGuestTheme1
{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[hiddenRightGuestImageViewTheme1 setAlpha:1.0];
	[hiddenLeftGuestImageViewTheme1 setAlpha:1.0];
	[rightGuestImageViewTheme1 setAlpha:1.0];
	[leftGuestImageViewTheme1 setAlpha:1.0];
	[UIView commitAnimations];
}

-(void)setupImageTheme1:(UIImageView *)imgView :(int)digit{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==1){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"digital-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"digital-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"digital-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"digital-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"digital-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"digital-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"digital-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"digital-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"digital-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"digital-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"digital-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"digital-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"digital-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"digital-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"digital-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"digital-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"digital-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"digital-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"digital-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"digital-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"digital-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"digital-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"digital-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"digital-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"digital-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"digital-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"digital-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"digital-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"digital-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"digital-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"digital-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"digital-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"digital-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"digital-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"digital-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"digital-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"digital-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"digital-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"digital-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"digital-9.png"]];
                break;
        }
    }
    
}

-(void)Theme1settingsButtonClick:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:3  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    UIDevice  *thisDevice = [UIDevice currentDevice];
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3SettingsViewController_iPad" bundle:nil];
    theme3SettingsViewController.delegateSetting = self;
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    theme3SettingsViewController.defaultsKey = @"SwatchColor";
    theme3SettingsViewController.guestKey = @"GuestColor";
#else
    // We re-use the current value set to the background of this demonstration view
    theme3SettingsViewController.HomeColor = HomeBackViewTheme1.backgroundColor;
    theme3SettingsViewController.GuestColor = GuestBackViewTheme1.backgroundColor;
    
#endif
    
    NSLog(@"Setting Dialog");
    
    [self.view addSubview: theme3SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme3SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [theme3SettingsViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [UIView commitAnimations];
    
}
#pragma mark-----
#pragma mark Third Scoreboard Screen designs
//modify by huodong
-(void)DigitalScoreboardNewtheme2ScreenDesign{
    
    CGRect GuestBorderImage = CGRectMake(23 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate);
    GuestBorderDigitalTheme2 = [[UIImageView alloc]initWithFrame:GuestBorderImage];
    [GuestBorderDigitalTheme2 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreBordNewTheme2 addSubview:GuestBorderDigitalTheme2];
    
    CGRect Boders = CGRectMake(154 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate);
    HomeBorderDigitalTheme2 = [[UIImageView alloc]initWithFrame:Boders];
    [HomeBorderDigitalTheme2 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreBordNewTheme2 addSubview:HomeBorderDigitalTheme2];
    
    
    [HomeBorderDigitalTheme2 setFrame:CGRectMake(213 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [GuestBorderDigitalTheme2 setFrame:CGRectMake(33 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    
    ScrollViewTheme2 = [[UIScrollView alloc] initWithFrame:CGRectMake(-265 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    ScrollViewTheme2.contentSize = CGSizeMake(DigitalScoreBordNewTheme2.frame.size.width, DigitalScoreBordNewTheme2.frame.size.height);
    ScrollViewTheme2.showsHorizontalScrollIndicator = YES;
    [ScrollViewTheme2 setBackgroundColor:[UIColor clearColor]];
    
    [DigitalScoreBordNewTheme2 addSubview:ScrollViewTheme2];
    
    guestTextFieldTheme2 = [[UITextField alloc] initWithFrame:CGRectMake(288 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate)];
    // guestTextFieldTheme2.borderStyle = UITextBorderStyleBezel;
    guestTextFieldTheme2.textColor = [UIColor whiteColor];
    guestTextFieldTheme2.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    guestTextFieldTheme2.text = @"Guest";
    guestTextFieldTheme2.textAlignment=UITextAlignmentCenter;
    guestTextFieldTheme2.backgroundColor = [UIColor clearColor];
    guestTextFieldTheme2.autocorrectionType = UITextAutocorrectionTypeNo;
    guestTextFieldTheme2.keyboardType = UIKeyboardTypeDefault;
    guestTextFieldTheme2.returnKeyType = UIReturnKeyDone;
    guestTextFieldTheme2.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:guestTextField];
    //    [ScrollViewTheme2 addSubview:guestTextFieldTheme2];
    
    guestTextFieldTheme2.tag = 10007;
    
    [DigitalScoreBordNewTheme2 addSubview:guestTextFieldTheme2];
    guestTextFieldTheme2.delegate = self;
    
    
    homeTextFieldTheme2 = [[UITextField alloc] initWithFrame:CGRectMake(419 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate)];
    // homeTextFieldTheme2.borderStyle = UITextBorderStyleBezel;
    homeTextFieldTheme2.textColor = [UIColor whiteColor];
    homeTextFieldTheme2.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme2.text = @"Home";
    homeTextFieldTheme2.textAlignment=UITextAlignmentCenter;
    homeTextFieldTheme2.autocorrectionType = UITextAutocorrectionTypeNo;
    homeTextFieldTheme2.backgroundColor = [UIColor clearColor];
    homeTextFieldTheme2.keyboardType = UIKeyboardTypeDefault;
    homeTextFieldTheme2.returnKeyType = UIReturnKeyDone;
    homeTextFieldTheme2.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    homeTextFieldTheme2.tag = 10008;
    
    // [self.view addSubview:homeTextField];
    //    [ScrollViewTheme2 addSubview:homeTextFieldTheme2];
    [DigitalScoreBordNewTheme2 addSubview:homeTextFieldTheme2];
    homeTextFieldTheme2.delegate = self;
    [guestTextFieldTheme2 setUserInteractionEnabled:NO];
    [homeTextFieldTheme2 setUserInteractionEnabled:NO];
    
    [homeTextFieldTheme2 setFrame:CGRectMake(213 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [guestTextFieldTheme2 setFrame:CGRectMake(33 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    Theme2Setting=[[UIButton alloc]initWithFrame:CGRectMake(350 * scoreboardWidthRate, 5 * scoreboardHeightRate, 25 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [Theme2Setting setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [Theme2Setting addTarget:self action:@selector(Theme2Setting:) forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreBordNewTheme2 addSubview:Theme2Setting];
    
    Theme2Reset=[[UIButton alloc]initWithFrame:CGRectMake(5 * scoreboardWidthRate, 5 * scoreboardHeightRate, 28 * scoreboardWidthRate, 28 * scoreboardHeightRate)];
    [Theme2Reset setImage:[UIImage imageNamed:@"main_menu_button.png"] forState:UIControlStateNormal];
    [Theme2Reset addTarget:self action:@selector(backButtonClickTheme2:) forControlEvents:UIControlEventTouchDown];
    [DigitalScoreBordNewTheme2 addSubview:Theme2Reset];
    [Theme2Setting setUserInteractionEnabled:NO];
    [Theme2Reset setUserInteractionEnabled:NO];
    
    [Theme2Setting setHidden:YES];
    [Theme2Reset setHidden:YES];
    Theme2Reset.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme2Setting.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
  
    
    
    
    CGRect myHomeImageRect = CGRectMake(200 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    HomeBackViewTheme2 = [[UIImageView alloc]initWithFrame:myHomeImageRect];
    HomeBackViewTheme2.backgroundColor = [UIColor blackColor];
    HomeBackViewTheme2.userInteractionEnabled=YES;
    //    [ScrollViewTheme2 addSubview:HomeBackViewTheme2];
    [DigitalScoreBordNewTheme2 addSubview:HomeBackViewTheme2];
    
    CGRect myGuestImageRect = CGRectMake( 20 * scoreboardWidthRate, 55 * scoreboardHeightRate, 160 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    GuestBackViewTheme2 = [[UIImageView alloc]initWithFrame:myGuestImageRect];
    GuestBackViewTheme2.backgroundColor = [UIColor blackColor];
    GuestBackViewTheme2.userInteractionEnabled=YES;
    //    [ScrollViewTheme2 addSubview:GuestBackViewTheme2];
    [DigitalScoreBordNewTheme2 addSubview:GuestBackViewTheme2];
    
    int H = 150 * scoreboardHeightRate;
    int W = 82 * scoreboardWidthRate;
    int Y = 55 * scoreboardHeightRate;
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRect7 = CGRectMake(19 * scoreboardWidthRate, Y, W, H);
    Theme2LeftGuestImageview = [[UIImageView alloc]initWithFrame:myImageRect7];
    [Theme2LeftGuestImageview setImage:[UIImage imageNamed:@"0s.png"]];
    Theme2LeftGuestImageview.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    Theme2LeftGuestImageview.userInteractionEnabled=YES;
    
    [DigitalScoreBordNewTheme2 addSubview: Theme2LeftGuestImageview];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRect8 = CGRectMake(99 * scoreboardWidthRate, Y, W, H);
    Theme2RightGuestImageView = [[UIImageView alloc]initWithFrame:myImageRect8];
    [Theme2RightGuestImageView setImage:[UIImage imageNamed:@"0s.png"]];
    Theme2RightGuestImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    
    Theme2RightGuestImageView.userInteractionEnabled=YES;
    
    [DigitalScoreBordNewTheme2 addSubview:Theme2RightGuestImageView];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectd = CGRectMake(199 * scoreboardWidthRate, Y, W, H);
    Theme2LeftHomeImageview = [[UIImageView alloc]initWithFrame:myImageRectd];
    [Theme2LeftHomeImageview setImage:[UIImage imageNamed:@"0s.png"]];
    Theme2LeftHomeImageview.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    Theme2LeftHomeImageview.userInteractionEnabled=YES;
    
    [DigitalScoreBordNewTheme2 addSubview:Theme2LeftHomeImageview];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectc = CGRectMake(279 * scoreboardWidthRate, Y, W, H);
    Theme2RightHomeImageView = [[UIImageView alloc]initWithFrame:myImageRectc];
    [Theme2RightHomeImageView setImage:[UIImage imageNamed:@"0s.png"]];
    Theme2RightHomeImageView.backgroundColor = [[UIColor alloc] initWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];

    Theme2RightHomeImageView.userInteractionEnabled=YES;
    
    [DigitalScoreBordNewTheme2 addSubview:Theme2RightHomeImageView];
    
    [Theme2LeftHomeImageview setUserInteractionEnabled:NO];
    [Theme2LeftGuestImageview setUserInteractionEnabled:NO];
    [Theme2RightGuestImageView setUserInteractionEnabled:NO];
    [Theme2RightHomeImageView  setUserInteractionEnabled:NO];
    
    UISwipeGestureRecognizer *leftSwipeUpScrollTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme2MoveScrollViewLeft)] autorelease];
	leftSwipeUpScrollTheme2.direction = UISwipeGestureRecognizerDirectionLeft;
    //	[ScrollViewTheme2 addGestureRecognizer:leftSwipeUpScrollTheme2];
	[DigitalScoreBordNewTheme2 addGestureRecognizer:leftSwipeUpScrollTheme2];
	
	//scroll view swipe recognizers
	UISwipeGestureRecognizer *rightSwipeDownScrollTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme2moveScrollViewRight)] autorelease];
	rightSwipeDownScrollTheme2.direction = UISwipeGestureRecognizerDirectionRight;
    //	[ScrollViewTheme2 addGestureRecognizer:rightSwipeDownScrollTheme2];
	[DigitalScoreBordNewTheme2 addGestureRecognizer:rightSwipeDownScrollTheme2];
    
    
    UISwipeGestureRecognizer *rightHomeImageViewSwipeUpTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2rightHomeImageViewScoreUp)] autorelease];
	rightHomeImageViewSwipeUpTheme2.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme2RightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeUpTheme2];
    
	
	UISwipeGestureRecognizer *rightHomeImageViewSwipeDownTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2rightHomeImageViewScoreDown)] autorelease];
	rightHomeImageViewSwipeDownTheme2.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme2RightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeDownTheme2];
    
	
	
	//initializing swipe recognizers
	UISwipeGestureRecognizer *leftHomeImageViewSwipeUpTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftHomeImageViewScoreUp)] autorelease];
	leftHomeImageViewSwipeUpTheme2.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme2LeftHomeImageview addGestureRecognizer:leftHomeImageViewSwipeUpTheme2];
    
	
	UISwipeGestureRecognizer *leftHomeImageViewSwipeDownTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftHomeImageViewScoreDown)] autorelease];
	leftHomeImageViewSwipeDownTheme2.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme2LeftHomeImageview addGestureRecognizer:leftHomeImageViewSwipeDownTheme2];
    
    
    
    UISwipeGestureRecognizer *RightHomeImageViewSwipeUpTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreUp)] autorelease];
	RightHomeImageViewSwipeUpTheme2.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme2LeftGuestImageview addGestureRecognizer:RightHomeImageViewSwipeUpTheme2];
    
    
    
    UISwipeGestureRecognizer *RightHomeImageViewSwipeDownTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreDown)] autorelease];
	RightHomeImageViewSwipeDownTheme2.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme2LeftGuestImageview addGestureRecognizer:RightHomeImageViewSwipeDownTheme2];
    
    
    
    
    UISwipeGestureRecognizer *RightGuestImageViewSwipeUpTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreUp)] autorelease];
	RightGuestImageViewSwipeUpTheme2.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme2RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeUpTheme2];
    
    
    
    UISwipeGestureRecognizer *RightGuestImageViewSwipeDownTheme2 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreDown)] autorelease];
	RightGuestImageViewSwipeDownTheme2.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme2RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeDownTheme2];
    
    
    
    
    UITapGestureRecognizer *rightGuestScoreImageTapTheme2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreUp)];
    [rightGuestScoreImageTapTheme2 setNumberOfTapsRequired:1];
    [rightGuestScoreImageTapTheme2 setNumberOfTouchesRequired:1];
    [Theme2RightGuestImageView addGestureRecognizer:rightGuestScoreImageTapTheme2];
    
    UITapGestureRecognizer *LeftGuestScoreImageTapTheme2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftGuestImageViewScoreUp)];
    [LeftGuestScoreImageTapTheme2 setNumberOfTapsRequired:1];
    [LeftGuestScoreImageTapTheme2 setNumberOfTouchesRequired:1];
    [Theme2LeftGuestImageview addGestureRecognizer:LeftGuestScoreImageTapTheme2];
    
    
    UITapGestureRecognizer *RightHomeScoreImageTapTheme2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftHomeImageViewScoreUp)];
    [RightHomeScoreImageTapTheme2 setNumberOfTapsRequired:1];
    [RightHomeScoreImageTapTheme2 setNumberOfTouchesRequired:1];
    [Theme2RightHomeImageView addGestureRecognizer:RightHomeScoreImageTapTheme2];
    
    UITapGestureRecognizer *LefttHomeScoreImageTapTheme2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme2leftHomeImageViewScoreUp)];
    [LefttHomeScoreImageTapTheme2 setNumberOfTapsRequired:1];
    [LefttHomeScoreImageTapTheme2 setNumberOfTouchesRequired:1];
    [Theme2LeftHomeImageview addGestureRecognizer:LefttHomeScoreImageTapTheme2];
    
}
#pragma mark DigitalScoreboardNewtheme3 Screen designs
-(void)DigitalScoreboardNewtheme3ScreenDesign{
    
    /////////**/
    #ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    // Retrieve saved user default for the color swatch - Must be archived before stored as a preference
    // Retrieve data object
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SwatchColor"];
    NSData *colorData1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"GuestColor"];
    UIColor *color, *color1;
    if (colorData!=nil) {
        // If the data object is valid, unarchive the color we've stored in it.
        color = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    } else {
        // If the data's not valid, the user default wasn't set, or there was an error retrieving the default value.
        
        // This is not the Apple-sanctioned way to set up defaults, but it _is_ permissible
        // The correct way to do it would be to register 'fall-back' defaults when the app launches for the first time,
        // usually via the app delegate.
        //
        // I've done it this way to consolidate initial defaults with error-checking code.
        
        // Create a new color (gray)
        color = [UIColor grayColor];
        
        // Archive the color into an NSData object
        colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
        
        // Store the NSData into the user defaults
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"SwatchColor"];
        
    }
    
    if( colorData1!=nil){
        color1 = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData1];
    }else{
        color1 = [UIColor grayColor];
        colorData1 = [NSKeyedArchiver archivedDataWithRootObject:color1];
        [[NSUserDefaults standardUserDefaults] setObject:colorData1 forKey:@"GuestColor"];
    }
    // Set the swatch color
    HomeBackRightViewTheme3.backgroundColor = color;
    HomeBackLeftViewTheme3.backgroundColor = color;
    
    GuestBackRightViewTheme3.backgroundColor = color1;
    GuestBackLeftViewTheme3.backgroundColor = color1;
#else
    // Set some arbitrary default color
    // Attention: This is not they way you should do it. Because everytime the ViewDidUnload
    // the color information will be lost. It's just the easy way for demonstration purposes
    //    HomeBorderDigitalTheme3.backgroundColor = [UIColor blueColor];
    
    HomeBackRightViewTheme3.backgroundColor = [UIColor blueColor];
    HomeBackLeftViewTheme3.backgroundColor = [UIColor blueColor];
    
    GuestBackRightViewTheme3.backgroundColor = [UIColor blueColor];
    GuestBackLeftViewTheme3.backgroundColor = [UIColor blueColor];
#endif
    
    ////////**/
    
    CGRect Boders = CGRectMake(210 * scoreboardWidthRate, 5 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    HomeBorderDigitalTheme3 = [[UIImageView alloc]initWithFrame:Boders];
    [HomeBorderDigitalTheme3 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreBordNewTheme3 addSubview:HomeBorderDigitalTheme3];
    
    CGRect GuestBorderImage = CGRectMake(56 * scoreboardWidthRate, 5 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    GuestBorderDigitalTheme3 = [[UIImageView alloc]initWithFrame:GuestBorderImage];
    [GuestBorderDigitalTheme3 setImage:[UIImage imageNamed:@"DigitslLabels.png"]];
    [DigitalScoreBordNewTheme3 addSubview:GuestBorderDigitalTheme3];
    
    
    [HomeBorderDigitalTheme3 setFrame:CGRectMake(210 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [GuestBorderDigitalTheme3 setFrame:CGRectMake(46 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    ScrollViewTheme3 = [[UIScrollView alloc] initWithFrame:CGRectMake(-265 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    ScrollViewTheme3.contentSize = CGSizeMake(DigitalScoreBordNewTheme3.frame.size.width, DigitalScoreBordNewTheme3.frame.size.height);
    ScrollViewTheme3.showsHorizontalScrollIndicator = YES;
    [ScrollViewTheme3 setBackgroundColor:[UIColor clearColor]];
    
    [DigitalScoreBordNewTheme3 addSubview:ScrollViewTheme3];
    
    guestTextFieldTheme3 = [[UITextField alloc] initWithFrame:CGRectMake(288 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate)];
    // guestTextFieldTheme3.borderStyle = UITextBorderStyleBezel;
    guestTextFieldTheme3.textColor = [UIColor whiteColor];
    guestTextFieldTheme3.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    guestTextFieldTheme3.text = @"Guest";
    guestTextFieldTheme3.textAlignment=UITextAlignmentCenter;
    guestTextFieldTheme3.backgroundColor = [UIColor clearColor];
    guestTextFieldTheme3.autocorrectionType = UITextAutocorrectionTypeNo;
    guestTextFieldTheme3.keyboardType = UIKeyboardTypeDefault;
    guestTextFieldTheme3.returnKeyType = UIReturnKeyDone;
    guestTextFieldTheme3.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[self.view addSubview:guestTextField];
    //    [ScrollViewTheme3 addSubview:guestTextFieldTheme3];
    
    guestTextFieldTheme3.tag = 10010;
    
    [DigitalScoreBordNewTheme3 addSubview:guestTextFieldTheme3];
    guestTextFieldTheme3.delegate = self;
    
    
    homeTextFieldTheme3 = [[UITextField alloc] initWithFrame:CGRectMake(419 * scoreboardWidthRate, 15 * scoreboardHeightRate, 88 * scoreboardWidthRate, 15 * scoreboardHeightRate)];
    // homeTextFieldTheme2.borderStyle = UITextBorderStyleBezel;
    homeTextFieldTheme3.textColor = [UIColor whiteColor];
    homeTextFieldTheme3.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme3.text = @"Home";
    homeTextFieldTheme3.textAlignment=UITextAlignmentCenter;
    homeTextFieldTheme3.autocorrectionType = UITextAutocorrectionTypeNo;
    homeTextFieldTheme3.backgroundColor = [UIColor clearColor];
    homeTextFieldTheme3.keyboardType = UIKeyboardTypeDefault;
    homeTextFieldTheme3.returnKeyType = UIReturnKeyDone;
    homeTextFieldTheme3.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    homeTextFieldTheme3.tag = 10009;
    
    // [self.view addSubview:homeTextField];
    //    [ScrollViewTheme3 addSubview:homeTextFieldTheme3];
    [DigitalScoreBordNewTheme3 addSubview:homeTextFieldTheme3];
    homeTextFieldTheme3.delegate = self;
    [guestTextFieldTheme3 setUserInteractionEnabled:NO];
    [homeTextFieldTheme3 setUserInteractionEnabled:NO];
    
    
    [homeTextFieldTheme3 setFrame:CGRectMake(206 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [guestTextFieldTheme3 setFrame:CGRectMake(39 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    
//    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settings_button.png"]];
//    [DigitalScoreBordNewTheme3 addSubview:img];
    
    Theme3ResetNew=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Theme3ResetNew setImage:[UIImage imageNamed:@"main_menu_button.png"] forState:UIControlStateNormal];
    [Theme3ResetNew addTarget:self action:@selector(backButtonClickTheme3:) forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreBordNewTheme3 addSubview:Theme3ResetNew];
    Theme3ResetNew.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    
    Theme3SettingNEW=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Theme3SettingNEW setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [Theme3SettingNEW addTarget:self action:@selector(Theme3Setting:) forControlEvents:UIControlEventTouchUpInside];
    [DigitalScoreBordNewTheme3 addSubview:Theme3SettingNEW];
    Theme3SettingNEW.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme3ResetNew.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme3SettingNEW.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme3Setting.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    [Theme3Setting setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [Theme3Setting addTarget:self action:@selector(Theme3Setting:) forControlEvents:UIControlEventTouchUpInside];
   // [DigitalScoreBordNewTheme3 addSubview:Theme3Setting];
    
    
    
    [Theme3Reset setImage:[UIImage imageNamed:@"main_menu_button.png"] forState:UIControlStateNormal];
    [Theme3Reset addTarget:self action:@selector(backButtonClickTheme3:) forControlEvents:UIControlEventTouchUpInside];
   // [DigitalScoreBordNewTheme3 addSubview:Theme3Reset];
    [Theme3Setting setHidden:YES];
    [Theme3Reset setHidden:YES];
    
    [Theme3Setting setUserInteractionEnabled:NO];
    [Theme3Reset setUserInteractionEnabled:NO];
    
    
   
    
    
    CGRect myHomeLeftRect = CGRectMake(200 * scoreboardWidthRate, 55 * scoreboardHeightRate, 80 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    HomeBackLeftViewTheme3 = [[UIImageView alloc]initWithFrame:myHomeLeftRect];
    HomeBackLeftViewTheme3.backgroundColor = [UIColor whiteColor];
    HomeBackLeftViewTheme3.userInteractionEnabled=YES;
    //    [DigitalScoreBordNewTheme3 addSubview:HomeBackLeftViewTheme3];
    
    CGRect myHomeRightRect = CGRectMake(280 * scoreboardWidthRate, 55 * scoreboardHeightRate, 80 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    HomeBackRightViewTheme3 = [[UIImageView alloc]initWithFrame:myHomeRightRect];
    HomeBackRightViewTheme3.backgroundColor = [UIColor whiteColor];
    HomeBackRightViewTheme3.userInteractionEnabled=YES;
    //    [DigitalScoreBordNewTheme3 addSubview:HomeBackRightViewTheme3];
    
    CGRect myGuestLeftImageRect = CGRectMake(20 * scoreboardWidthRate, 55 * scoreboardHeightRate, 80 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    GuestBackLeftViewTheme3 = [[UIImageView alloc]initWithFrame:myGuestLeftImageRect];
    GuestBackLeftViewTheme3.backgroundColor = [UIColor whiteColor];
    GuestBackLeftViewTheme3.userInteractionEnabled=YES;
    //    [DigitalScoreBordNewTheme3 addSubview:GuestBackLeftViewTheme3];
    
    CGRect myGuestRightImageRect = CGRectMake(100 * scoreboardWidthRate, 55 * scoreboardHeightRate, 80 * scoreboardWidthRate, 150 * scoreboardHeightRate);
    GuestBackRightViewTheme3 = [[UIImageView alloc]initWithFrame:myGuestRightImageRect];
    GuestBackRightViewTheme3.backgroundColor = [UIColor whiteColor];
    GuestBackRightViewTheme3.userInteractionEnabled=YES;
    
    int H = 150 * scoreboardHeightRate;
    int W = 82 * scoreboardWidthRate;
    int Y = 65 * scoreboardHeightRate;
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRect7 = CGRectMake(35 * scoreboardWidthRate, Y, W, H);
    Theme3LeftGuestImageview = [[UIImageView alloc]initWithFrame:myImageRect7];
    
    JDFlipImageView *flipImageView1  = [[JDFlipImageView alloc] initWithImage:[UIImage imageNamed:@"sb0.png"]];
    [flipImageView1 setFrame:myImageRect7];
    [DigitalScoreBordNewTheme3 addSubview:flipImageView1];
    self.guestLeftFlipView = flipImageView1;
    [flipImageView1 release];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRect8 = CGRectMake(108 * scoreboardWidthRate, Y, W, H);
    Theme3RightGuestImageView = [[UIImageView alloc]initWithFrame:myImageRect8];
    
    JDFlipImageView *flipImageView2  = [[JDFlipImageView alloc] initWithImage:[UIImage imageNamed:@"sb0.png"]];
    [flipImageView2 setFrame:myImageRect8];
    [DigitalScoreBordNewTheme3 addSubview:flipImageView2];
    self.guestRightFlipView = flipImageView2;
    [flipImageView2 release];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectd = CGRectMake(201 * scoreboardWidthRate, Y, W, H);
    Theme3LeftHomeImageview = [[UIImageView alloc]initWithFrame:myImageRectd];
    
    JDFlipImageView *flipImageView3  = [[JDFlipImageView alloc] initWithImage:[UIImage imageNamed:@"sb0.png"]];
    [flipImageView3 setFrame:myImageRectd];
    [DigitalScoreBordNewTheme3 addSubview:flipImageView3];
    self.homeLeftFlipView = flipImageView3;
    [flipImageView3 release];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect myImageRectc = CGRectMake(274 * scoreboardWidthRate, Y, W, H);
    Theme3RightHomeImageView = [[UIImageView alloc]initWithFrame:myImageRectc];
    
    JDFlipImageView *flipImageView4  = [[JDFlipImageView alloc] initWithImage:[UIImage imageNamed:@"sb0.png"]];
    [flipImageView4 setFrame:myImageRectc];
    [DigitalScoreBordNewTheme3 addSubview:flipImageView4];
    self.homeRightFlipView = flipImageView4;
    [flipImageView4 release];
    
    
    [Theme3LeftGuestImageview setUserInteractionEnabled:NO];
    [Theme3RightGuestImageView setUserInteractionEnabled:NO];
    [Theme3LeftHomeImageview setUserInteractionEnabled:NO];
    [Theme3RightHomeImageView  setUserInteractionEnabled:NO];
    
    [self.guestLeftFlipView setUserInteractionEnabled:NO];
    [self.guestRightFlipView setUserInteractionEnabled:NO];
    [self.homeLeftFlipView setUserInteractionEnabled:NO];
    [self.homeRightFlipView setUserInteractionEnabled:NO];
    
    UISwipeGestureRecognizer *leftSwipeUpScrollTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme3MoveScrollViewLeft)] autorelease];
	leftSwipeUpScrollTheme3.direction = UISwipeGestureRecognizerDirectionLeft;
	[DigitalScoreBordNewTheme3 addGestureRecognizer:leftSwipeUpScrollTheme3];
    
	UISwipeGestureRecognizer *rightSwipeDownScrollTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DigitalNewTheme3moveScrollViewRight)] autorelease];
	rightSwipeDownScrollTheme3.direction = UISwipeGestureRecognizerDirectionRight;
	[DigitalScoreBordNewTheme3 addGestureRecognizer:rightSwipeDownScrollTheme3];
    
    
    
    
    
    
    UISwipeGestureRecognizer *rightHomeImageViewSwipeUpTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3rightHomeImageViewScoreUp)] autorelease];
	rightHomeImageViewSwipeUpTheme3.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme3RightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeUpTheme3];
    [self.homeRightFlipView addGestureRecognizer:rightHomeImageViewSwipeUpTheme3];
	
	UISwipeGestureRecognizer *rightHomeImageViewSwipeDownTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3rightHomeImageViewScoreDown)] autorelease];
	rightHomeImageViewSwipeDownTheme3.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme3RightHomeImageView addGestureRecognizer:rightHomeImageViewSwipeDownTheme3];
    [self.homeRightFlipView addGestureRecognizer:rightHomeImageViewSwipeDownTheme3];
    
    UISwipeGestureRecognizer *RightHomeImageViewSwipeUpTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftHomeImageViewScoreUp)] autorelease];
	RightHomeImageViewSwipeUpTheme3.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme3RightHomeImageView addGestureRecognizer:RightHomeImageViewSwipeUpTheme3];
    [self.homeLeftFlipView addGestureRecognizer:RightHomeImageViewSwipeUpTheme3];
    
    UISwipeGestureRecognizer *RightHomeImageViewSwipeDownTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3rightHomeImageViewScoreDown)] autorelease];
	RightHomeImageViewSwipeDownTheme3.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme3RightHomeImageView addGestureRecognizer:RightHomeImageViewSwipeDownTheme3];
    [self.homeLeftFlipView addGestureRecognizer:RightHomeImageViewSwipeDownTheme3];
    
    UISwipeGestureRecognizer *RightGuestImageViewSwipeUpTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreUp)] autorelease];
	RightGuestImageViewSwipeUpTheme3.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme3RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeUpTheme3];
    [self.guestRightFlipView addGestureRecognizer:RightGuestImageViewSwipeUpTheme3];
    
    UISwipeGestureRecognizer *RightGuestImageViewSwipeDownTheme3 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreDown)] autorelease];
	RightGuestImageViewSwipeDownTheme3.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme3RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeDownTheme3];
    [self.guestRightFlipView addGestureRecognizer:RightGuestImageViewSwipeDownTheme3];

    UISwipeGestureRecognizer *RightGuestImageViewSwipeUpTheme34 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreUp)] autorelease];
	RightGuestImageViewSwipeUpTheme34.direction = UISwipeGestureRecognizerDirectionUp;
	[Theme3RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeUpTheme34];
    [self.guestLeftFlipView addGestureRecognizer:RightGuestImageViewSwipeUpTheme34];
    
    UISwipeGestureRecognizer *RightGuestImageViewSwipeDownTheme35 = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreDown)] autorelease];
	RightGuestImageViewSwipeDownTheme35.direction = UISwipeGestureRecognizerDirectionDown;
	[Theme3RightGuestImageView addGestureRecognizer:RightGuestImageViewSwipeDownTheme35];
    [self.guestLeftFlipView addGestureRecognizer:RightGuestImageViewSwipeDownTheme35];

    
    
    
    
    
    
    
    
    
    
    
    
    UITapGestureRecognizer *rightGuestScoreImageTapTheme3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreUp)];
    [rightGuestScoreImageTapTheme3 setNumberOfTapsRequired:1];
    [rightGuestScoreImageTapTheme3 setNumberOfTouchesRequired:1];
    [Theme3RightGuestImageView addGestureRecognizer:rightGuestScoreImageTapTheme3];
    [self.guestRightFlipView addGestureRecognizer:rightGuestScoreImageTapTheme3];
    
    UITapGestureRecognizer *LeftGuestScoreImageTapTheme3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftGuestImageViewScoreUp)];
    [LeftGuestScoreImageTapTheme3 setNumberOfTapsRequired:1];
    [LeftGuestScoreImageTapTheme3 setNumberOfTouchesRequired:1];
    [Theme3LeftGuestImageview addGestureRecognizer:LeftGuestScoreImageTapTheme3];
    [self.guestLeftFlipView addGestureRecognizer:LeftGuestScoreImageTapTheme3];
    
    UITapGestureRecognizer *RightHomeScoreImageTapTheme3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftHomeImageViewScoreUp)];
    [RightHomeScoreImageTapTheme3 setNumberOfTapsRequired:1];
    [RightHomeScoreImageTapTheme3 setNumberOfTouchesRequired:1];
    [Theme3RightHomeImageView addGestureRecognizer:RightHomeScoreImageTapTheme3];
    [self.homeRightFlipView addGestureRecognizer:RightHomeScoreImageTapTheme3];
    
    UITapGestureRecognizer *LefttHomeScoreImageTapTheme3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Theme3leftHomeImageViewScoreUp)];
    [LefttHomeScoreImageTapTheme3 setNumberOfTapsRequired:1];
    [LefttHomeScoreImageTapTheme3 setNumberOfTouchesRequired:1];
    [Theme3LeftHomeImageview addGestureRecognizer:LefttHomeScoreImageTapTheme3];
    [self.homeLeftFlipView addGestureRecognizer:LefttHomeScoreImageTapTheme3];
    
}

#pragma mark backButtonClickTheme3 Screen designs
-(IBAction)backButtonClickTheme3:(id)sender{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [SmallButtonTheme3 setHidden:YES];
    [Theme3SettingNEW setHidden:YES];
    [Theme3ResetNew setHidden:YES];
    [m_pMainBluetoothButton setHidden:NO];
    if (isBluetooth == YES)
        [buttoninfo setHidden:YES];
    else
        [buttoninfo setHidden:NO];

    [LeftSideViewForTap setFrame:CGRectMake((LeftSideViewForTap.frame.origin.x+200) * scoreboardWidthRate, LeftSideViewForTap.frame.origin.y * scoreboardHeightRate, LeftSideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [RightsideViewForTap setFrame:CGRectMake((RightsideViewForTap.frame.origin.x-200) * scoreboardWidthRate, RightsideViewForTap.frame.origin.y * scoreboardHeightRate, RightsideViewForTap.frame.size.width * scoreboardWidthRate, RightsideViewForTap.frame.size.height * scoreboardHeightRate)];
    
    [Theme3LeftHomeImageview setUserInteractionEnabled:NO];
    [Theme3LeftGuestImageview setUserInteractionEnabled:NO];
    [Theme3RightGuestImageView setUserInteractionEnabled:NO];
    [Theme3RightHomeImageView  setUserInteractionEnabled:NO];
    [guestTextFieldTheme3 setUserInteractionEnabled:NO];
    [homeTextFieldTheme3 setUserInteractionEnabled:NO];
    
    [self.guestLeftFlipView setUserInteractionEnabled:NO];
    [self.guestRightFlipView setUserInteractionEnabled:NO];
    [self.homeLeftFlipView setUserInteractionEnabled:NO];
    [self.homeRightFlipView setUserInteractionEnabled:NO];
    
    Theme3ViewBigger = NO;
    globalTheme3ViewBigger = NO;
    [Theme3Setting setUserInteractionEnabled:NO];
    [Theme3Reset setUserInteractionEnabled:NO];
    
    Theme3ResetNew.frame = CGRectMake(-70 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    Theme3SettingNEW.frame = CGRectMake(430 * scoreboardWidthRate, -50 * scoreboardHeightRate, 28 * scoreboardWidthRate, 25 * scoreboardHeightRate);
    
    [DigitalScoreBordNewTheme3 setFrame:CGRectMake(50 * scoreboardWidthRate, 30 * scoreboardHeightRate, 380 * scoreboardWidthRate, 260 * scoreboardHeightRate)];
    
    [DigitalScoreBoardBackGroundTheme3 setFrame:CGRectMake(0, 0, DigitalScoreBordNewTheme3.frame.size.width, DigitalScoreBordNewTheme3.frame.size.height)];
    
    [Twitter setFrame:CGRectMake(Twitter.frame.origin.x * scoreboardWidthRate, (Twitter.frame.origin.y+50) * scoreboardHeightRate, Twitter.frame.size.width * scoreboardWidthRate, Twitter.frame.size.height * scoreboardHeightRate)];
    
    [FacebookButton setFrame:CGRectMake(FacebookButton.frame.origin.x * scoreboardWidthRate, (FacebookButton.frame.origin.y+50) * scoreboardHeightRate, FacebookButton.frame.size.width * scoreboardWidthRate, FacebookButton.frame.size.height * scoreboardHeightRate)];
    
    [Instructions setFrame:CGRectMake(Instructions.frame.origin.x * scoreboardWidthRate, (Instructions.frame.origin.y+50) * scoreboardHeightRate, Instructions.frame.size.width * scoreboardWidthRate, Instructions.frame.size.height * scoreboardHeightRate)];
    
    regulerSBButton.frame=CGRectMake(145 * scoreboardWidthRate, 0 ,190 * scoreboardWidthRate, 24 * scoreboardHeightRate);
    
    [HomeBorderDigitalTheme3 setFrame:CGRectMake(200 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [GuestBorderDigitalTheme3 setFrame:CGRectMake(46 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [ScrollViewTheme3 setFrame:CGRectMake(-265 * scoreboardWidthRate, 0, 1040 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    
    
    
    [HomeBorderDigitalTheme3 setFrame:CGRectMake(210 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    [GuestBorderDigitalTheme3 setFrame:CGRectMake(46 * scoreboardWidthRate, 16 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
    
    guestTextFieldTheme3.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    homeTextFieldTheme3.font = [UIFont systemFontOfSize:12 * scoreboardHeightRate];
    
    int H = 150 * scoreboardHeightRate;
    int W = 82 * scoreboardWidthRate;
    int Y = 65 * scoreboardHeightRate;
    
    
    if(Theme3CourtChange==YES){
        
        [Theme3LeftGuestImageview setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
        [self.guestLeftFlipView setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3RightGuestImageView setFrame:CGRectMake(274 * scoreboardWidthRate, Y, W, H)];
        [self.guestRightFlipView setFrame:CGRectMake(274 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3LeftHomeImageview setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
        [self.homeLeftFlipView setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3RightHomeImageView setFrame:CGRectMake(108 * scoreboardWidthRate, Y, W, H)];
        [self.homeRightFlipView setFrame:CGRectMake(108 * scoreboardWidthRate, Y, W, H)];
        
        [homeTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
        [guestTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
    }
    else{
        
        [Theme3LeftGuestImageview setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
        [self.guestLeftFlipView setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3RightGuestImageView setFrame:CGRectMake(112 * scoreboardWidthRate, Y, W, H)];
        [self.guestRightFlipView setFrame:CGRectMake(112 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3LeftHomeImageview setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
        [self.homeLeftFlipView setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
        
        [Theme3RightHomeImageView setFrame:CGRectMake(278 * scoreboardWidthRate, Y, W, H)];
        [self.homeRightFlipView setFrame:CGRectMake(278 * scoreboardWidthRate, Y, W, H)];
        
        
        [homeTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
        [guestTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
    }
    
    [SmallButtonTheme3 setUserInteractionEnabled:NO];
    
    [self performSelector:@selector(FadeOutDigitalTheme31) withObject:nil afterDelay:0.1];
    
    [UIView commitAnimations];
    
    [LeftShadow setFrame:CGRectMake((LeftShadow.frame.origin.x+105) * scoreboardWidthRate, LeftShadow.frame.origin.y * scoreboardHeightRate, LeftShadow.frame.size.width * scoreboardWidthRate, LeftShadow.frame.size.height * scoreboardHeightRate)];
    
    [RightShadow setFrame:CGRectMake((RightShadow.frame.origin.x-105), RightShadow.frame.origin.y * scoreboardHeightRate, RightShadow.frame.size.width * scoreboardWidthRate, RightShadow.frame.size.height * scoreboardHeightRate)];
    
}
#pragma Theme2Scoreboard ScoreBoard Actions and methods
-(IBAction)Theme2Reset:(id)sender{
}

-(IBAction)Theme2Setting:(id)sender{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:4  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    [UIView beginAnimations:nil context:nil];
  	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseIn forView:self.navigationController.view cache:YES];
	[UIView commitAnimations];
    
	UIDevice  *thisDevice = [UIDevice currentDevice];
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3SettingsViewController_iPad" bundle:nil];
    theme3SettingsViewController.delegateSetting = self;
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    theme3SettingsViewController.defaultsKey = @"SwatchColor";
    theme3SettingsViewController.guestKey = @"GuestColor";
#else
    // We re-use the current value set to the background of this demonstration view
    theme3SettingsViewController.HomeColor = HomeBackLeftViewTheme3.backgroundColor;
    theme3SettingsViewController.GuestColor = GuestBackLeftViewTheme3.backgroundColor;
    
#endif
    
    NSLog(@"Setting Dialog");
    //    [self presentModalViewController:theme3SettingsViewController animated:YES];
    //    [self presentViewController:theme3SettingsViewController animated:NO completion:nil];
    [self.view addSubview: theme3SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme3SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [theme3SettingsViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [UIView commitAnimations];
    
}

-(void)DigitalNewTheme2MoveScrollViewLeft{
    
    if (Theme2ViewBigger == YES) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        if (Theme2CourtChange == YES) {
            Theme2CourtChange = NO;
            if( self.isServer && isBluetooth)
            {
                [self.game leftSwipeServer: 104];
            }
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            int H = 200 * scoreboardHeightRate;
            int W = 114 * scoreboardWidthRate;
            int Y = 59 * scoreboardHeightRate;
            
            [GuestBackViewTheme2 setFrame:CGRectMake(8 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [HomeBackViewTheme2 setFrame:CGRectMake(260 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate,199 * scoreboardHeightRate)];
            [Theme2LeftGuestImageview setFrame:CGRectMake(0 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(110 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(256 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(366 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        }
        [UIView commitAnimations];
        
    }
    
}
-(void)DigitalNewTheme2moveScrollViewRight{
    if (Theme2ViewBigger==YES) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        // NSLog(@"gggfsgxfscgxdsfdgwcvdgcfvcfrcvfrc ghcv bfrhcvbfrchrcbrcvhrbcdhcbdrhuyc  ednbejcrcbrdcvnr rdb c");
        
        if (Theme2CourtChange == NO) {
            Theme2CourtChange = YES;
            if( self.isServer && isBluetooth)
            {
                [self.game rightSwipeServer: 104];
            }
            
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            int H = 200 * scoreboardHeightRate;
            int W = 114 * scoreboardWidthRate;
            int Y = 59 * scoreboardHeightRate;
            [GuestBackViewTheme2 setFrame:CGRectMake(260 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [HomeBackViewTheme2 setFrame:CGRectMake(8 * scoreboardWidthRate, 59 * scoreboardHeightRate, 213 * scoreboardWidthRate, 199 * scoreboardHeightRate)];
            [Theme2LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(368 * scoreboardWidthRate,Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(0 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(110 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
        }
        [UIView commitAnimations];
        
    }
    
}
-(void)Theme2rightHomeImageViewScoreUp{
    selectedImageViewNameTheme2 = @"rightHomeImageViewTheme1";
	HomescoreIndexTheme2 +=1;
	if (HomescoreIndexTheme2>99) {
		HomescoreIndexTheme2=99;
	}
	
	[self homeScoreChangeTheme2];
}
-(void)Theme2rightHomeImageViewScoreDown{
    
	selectedImageViewNameTheme2 = @"rightHomeImageViewTheme1";
	HomescoreIndexTheme2 -=1;
	
	[self homeScoreChangeTheme2];
}
-(void)Theme2leftHomeImageViewScoreUp{
   	selectedImageViewNameTheme2 = @"leftHomeImageViewTheme1";
	HomescoreIndexTheme2 +=1;
	if (HomescoreIndexTheme2>99) {
		HomescoreIndexTheme2=99;
	}
	
	[self homeScoreChangeTheme2];
}
-(void)Theme2leftHomeImageViewScoreDown{
    
	selectedImageViewNameTheme2 = @"leftHomeImageViewTheme1";
	HomescoreIndexTheme2 -=1;
	[self homeScoreChangeTheme2];
}
-(void)Theme2rightGuestImageViewScoreUp{
    NSLog(@"Its entering into the Theme1hiddenRightHomeImageViewScoreUp ");
    
	selectedImageViewNameTheme2 = @"rightGuestImageViewTheme1";
	GuestScoreIndexTheme2 +=1;
	if (GuestScoreIndexTheme2>99) {
		GuestScoreIndexTheme2=99;
	}
	[self guestScoreChangeTheme2];
}
-(void)Theme2rightGuestImageViewScoreDown{
	selectedImageViewNameTheme2 = @"rightGuestImageViewTheme1";
	GuestScoreIndexTheme2 -=1;
	[self guestScoreChangeTheme2];
}
-(void)Theme2leftGuestImageViewScoreUp{
	selectedImageViewNameTheme2 = @"leftGuestImageViewTheme1";
	GuestScoreIndexTheme2 +=1;
	[self guestScoreChangeTheme2];
}
-(void)Theme2leftGuestImageViewScoreDown{
	selectedImageViewNameTheme2 = @"leftGuestImageViewTheme1";
	GuestScoreIndexTheme2 -=1;
	[self guestScoreChangeTheme2];
}
-(void)homeScoreChangeTheme2
{
    if (HomescoreIndexTheme2 > 99) {
		HomescoreIndexTheme2 = 99;
		return;
	}
	if (HomescoreIndexTheme2 < 0) {
		HomescoreIndexTheme2 = 0;
	}
	
	if(HomescoreIndexTheme2 < 100)
	{
        if( self.isServer )
        {
            [self.game homeScoreServerChange: HomescoreIndexTheme2];
        } else {
            return;
        }
		
		int temp = HomescoreIndexTheme2;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme2Home:Theme2RightHomeImageView :secondDigit];
		
		if (firstDigit != 0)
		{
			//[self setupImageTheme1:hiddenLeftHomeImageViewTheme1 :firstDigit];
			[self setupImageTheme2Home:Theme2LeftHomeImageview:firstDigit];
            
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==1){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineRed0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==2){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineBlue0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==3){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineYellow0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==4){
                //hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineWhite0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme2)];
		[UIView commitAnimations];
		
		homeScoreFirstDigitTheme2=firstDigit;
	}
}

-(void)dimUpHomeTheme2{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
	[Theme2LeftHomeImageview setAlpha:1.0];
	[Theme2RightHomeImageView setAlpha:1.0];
	[UIView commitAnimations];
}

-(void)guestScoreChangeTheme2
{
	if (GuestScoreIndexTheme2 > 99) {
		GuestScoreIndexTheme2 = 99;
		return;
	}
	if (GuestScoreIndexTheme2 < 0) {
		GuestScoreIndexTheme2 = 0;
		return;
	}
	
	if(GuestScoreIndexTheme2 < 100)
	{
        if( self.isServer )
        {
            [self.game guestScoreServerChange: GuestScoreIndexTheme2];
        } else {
            return;
        }
		int temp = GuestScoreIndexTheme2;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme2:Theme2RightGuestImageView :secondDigit];
		
		if (firstDigit!=0)
		{
			
			[self setupImageTheme2:Theme2LeftGuestImageview :firstDigit];
		}
		else
		{
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==1){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==2){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==3){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==4){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
		}
		
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme2)];
		[UIView commitAnimations];
		
		guestScoreFirstDigitTheme2 = firstDigit;
        
	}
}

-(void)dimUpGuestTheme2
{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
    
    [Theme2RightGuestImageView setAlpha:1.0];
	[Theme2LeftGuestImageview setAlpha:1.0];
	[UIView commitAnimations];
}

-(void)setupImageTheme2:(UIImageView *)imgView :(int)digit{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==1){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==2){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==3){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==4){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    
}

-(void)setupImageTheme2Home:(UIImageView *)imgView :(int)digit{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==1){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==2){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==3){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==4){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"line-0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"line-1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"line-2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"line-3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"line-4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"line-5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"line-6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"line-7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"line-8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"line-9.png"]];
                break;
        }
    }
    
}

-(void)Theme2ColorChange{
    int tempHome = HomescoreIndexTheme2;
    
    int secondDigitHome = tempHome % 10;
    tempHome = tempHome / 10;
    int firstDigitHome = tempHome;
    
    int temp=GuestScoreIndexTheme2;
    
    int secondDigit = temp % 10;
    temp = temp / 10;
    int firstDigit = temp;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==1){
        
        Theme2LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigit]];
        Theme2RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigit]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==2){
        Theme2LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigit]];
        Theme2RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigit]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==3){
        Theme2LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigit]];
        Theme2RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigit]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==4){
        Theme2LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigit]];
        Theme2RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigit]];
    }
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==1){
        Theme2LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigitHome]];
        Theme2RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==2){
        Theme2LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigitHome]];
        Theme2RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==3){
        Theme2LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigitHome]];
        Theme2RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigitHome]];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==4){
        Theme2LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",firstDigitHome]];
        Theme2RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%d.png",secondDigitHome]];
    }
}

#pragma Theme3Scoreboard ScoreBoard Actions and methods
-(IBAction)Theme3Reset:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:5  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    UIActionSheet *resetActionSheetForDigital = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reset Names",@"Reset Score", @"Reset Both", nil];
    //Revmob reset
    
    [resetActionSheetForDigital setTag:100];
    [resetActionSheetForDigital showInView:self.view];
    [resetActionSheetForDigital release];
}
-(IBAction)Theme3Setting:(id)sender{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:5  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    [UIView beginAnimations:nil context:nil];
  	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseIn forView:self.navigationController.view cache:YES];
	[UIView commitAnimations];
    
	UIDevice  *thisDevice = [UIDevice currentDevice];
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3NocolorchooserViewController_iad" bundle:nil];
    //
      theme3SettingsViewController.delegateSetting = self;
    //
    //#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    //    // theme3SettingsViewController.defaultsKey = @"SwatchColor";
    //    //  theme3SettingsViewController.guestKey = @"GuestColor";
    //    #else
    //        // We re-use the current value set to the background of this demonstration view
    ////        theme3SettingsViewController.HomeColor = HomeBackLeftViewTheme3.backgroundColor;
    ////    theme3SettingsViewController.GuestColor = GuestBackLeftViewTheme3.backgroundColor;
    //
    //#endif
    
    NSLog(@"Setting Dialog");
    [self.view addSubview: theme3SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme3SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [theme3SettingsViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [UIView commitAnimations];
    
    
    //#endif
    
}
- (void)GuestColorViewController:(Theme3SettingsViewController_iPhone *)colorPicker didSelectColor:(UIColor *)color {
    NSLog(@"Color: %d", color);
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.guestKey];
    
    if ([colorPicker.guestKey isEqualToString:@"GuestColor"]) {
        
        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==1){
            frontGuestScoreLable.backgroundColor = color;
        }
        else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==2){
//            guestBackImageView.backgroundColor = color;
            hiddenLeftGuestImageView.backgroundColor = color;
            hiddenRightGuestImageView.backgroundColor = color;

        }
        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==3){
//            GuestBackViewTheme1.backgroundColor = color;
            hiddenLeftGuestImageViewTheme1.backgroundColor = color;
            hiddenRightGuestImageViewTheme1.backgroundColor = color;
        }
        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==4){
//            GuestBackViewTheme2.backgroundColor = color;
            Theme2LeftGuestImageview.backgroundColor = color;
            Theme2RightGuestImageView.backgroundColor = color;
        }
        else
        {
            GuestBackLeftViewTheme3.backgroundColor = color;
            GuestBackRightViewTheme3.backgroundColor = color;
        }
    }
#else
    // No storage & check, just assign back the color
    colorSwatch.backgroundColor = color;
#endif
    
}

-(void) setTimer
{
    int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutesTheme1"];
    int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"secondsTheme1"];
    if (mins==0&&secs==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutesTheme1"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"secondsTheme1"];
    }
    int mins1=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutes"];
    int secs1=[[NSUserDefaults standardUserDefaults]integerForKey:@"seconds"];
    
    if (mins1==0&&secs1==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"seconds"];
    }
    if (countdownTimerView!=nil) {
		
		countdownTimerView.timerFlag= YES;
        int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutes"];
        int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"seconds"];
        
		[countdownTimerView settime:mins seconds:secs];
		
	}
    else{
        countdownTimerView.timerFlag = NO;
        
    }
    
    if (countdownTimerViewTheme1!=nil) {
		
		countdownTimerViewTheme1.timerFlagTheme1= YES;
        int mins=[[NSUserDefaults standardUserDefaults]integerForKey:@"minutesTheme1"];
        int secs=[[NSUserDefaults standardUserDefaults]integerForKey:@"secondsTheme1"];
        
		[countdownTimerViewTheme1 settime:mins seconds:secs];
        
	}
    else{
        countdownTimerViewTheme1.timerFlagTheme1=NO;
        
    }
}

-(void)DigitalNewTheme3MoveScrollViewLeft{
    
    if (Theme3ViewBigger == YES) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        // NSLog(@"gggfsgxfscgxdsfdgwcvdgcfvcfrcvfrc ghcv bfrhcvbfrchrcbrcvhrbcdhcbdrhuyc  ednbejcrcbrdcvnr rdb c");
        
        if (Theme3CourtChange == NO) {
            NSLog(@"scroll left");
            Theme3CourtChange = YES;
            
            if( self.isServer && isBluetooth)
            {
                [self.game leftSwipeServer: 105];
            }
            
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            int H=Theme3LeftGuestImageview.frame.size.height;
            int W=Theme3LeftGuestImageview.frame.size.width;
            int Y=Theme3LeftGuestImageview.frame.origin.y;
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            //            [Flip3LeftHomeImageview setFrame:CGRectMake(255, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme3 setFrame:CGRectMake(45 * scoreboardWidthRate, 27.0 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme3 setFrame:CGRectMake(285 * scoreboardWidthRate, 27.0 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
        }
        [UIView commitAnimations];
    }
}

-(void)DigitalNewTheme3moveScrollViewRight{
    
    NSLog(@"Scrool right");
    if (Theme3ViewBigger == YES) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        if (Theme3CourtChange == YES) {
            Theme3CourtChange = NO;
            
            NSLog(@"Scrool right");
            if( self.isServer && isBluetooth)
            {
                [self.game rightSwipeServer: 105];
            }
            
            if( !self.isServer && isBluetooth)
            {
                return;
            }
            
            int H=Theme3LeftGuestImageview.frame.size.height;
            int W=Theme3LeftGuestImageview.frame.size.width;
            int Y=Theme3LeftGuestImageview.frame.origin.y;
            
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme3 setFrame:CGRectMake(285 * scoreboardWidthRate, 27.0 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme3 setFrame:CGRectMake(45 * scoreboardWidthRate, 27.0 * scoreboardHeightRate, 150 * scoreboardWidthRate, 27 * scoreboardHeightRate)];
            
            
        }
        [UIView commitAnimations];
        
    }
}

-(void)Theme3rightHomeImageViewScoreUp{
    selectedImageViewNameTheme3 = @"rightHomeImageViewTheme1";
	HomescoreIndexTheme3 += 1;
	if (HomescoreIndexTheme3 > 99) {
		HomescoreIndexTheme3 = 99;
	}
	
	[self homeScoreChangeTheme3: NO];
}
-(void)Theme3rightHomeImageViewScoreDown{
    
	selectedImageViewNameTheme3 = @"rightHomeImageViewTheme1";
	HomescoreIndexTheme3 -= 1;
	
	[self homeScoreChangeTheme3: YES];
}
-(void)Theme3leftHomeImageViewScoreUp{
   	selectedImageViewNameTheme3 = @"leftHomeImageViewTheme1";
	HomescoreIndexTheme3 += 1;
	if (HomescoreIndexTheme3 > 99) {
		HomescoreIndexTheme3 = 99;
	}
	
	[self homeScoreChangeTheme3: NO];
}
-(void)Theme3leftHomeImageViewScoreDown{
    
	selectedImageViewNameTheme3 = @"leftHomeImageViewTheme1";
	HomescoreIndexTheme3 -= 1;
	[self homeScoreChangeTheme3: YES];
}
-(void)Theme3rightGuestImageViewScoreUp{
    NSLog(@"Its entering into the Theme1hiddenRightHomeImageViewScoreUp ");
    
	selectedImageViewNameTheme3 = @"rightGuestImageViewTheme1";
	GuestScoreIndexTheme3 += 1;
	if (GuestScoreIndexTheme3 > 99) {
		GuestScoreIndexTheme3 = 99;
	}
	[self guestScoreChangeTheme3: NO];
}
-(void)Theme3rightGuestImageViewScoreDown{
	selectedImageViewNameTheme3 = @"rightGuestImageViewTheme1";
	GuestScoreIndexTheme3 -= 1;
	[self guestScoreChangeTheme3: YES];
}
-(void)Theme3leftGuestImageViewScoreUp{
	selectedImageViewNameTheme3 = @"leftGuestImageViewTheme1";
	GuestScoreIndexTheme3 += 1;
	[self guestScoreChangeTheme3: NO];
}
-(void)Theme3leftGuestImageViewScoreDown{
	selectedImageViewNameTheme3 = @"leftGuestImageViewTheme1";
	GuestScoreIndexTheme3 -= 1;
	[self guestScoreChangeTheme3: YES];
}
-(void)homeScoreChangeTheme3: (BOOL) isDownFlip
{
    if (HomescoreIndexTheme3 > 99) {
		HomescoreIndexTheme3 = 99;
		return;
	}
	if (HomescoreIndexTheme3 < 0) {
		HomescoreIndexTheme3 = 0;
        return;
	}
	
	if(HomescoreIndexTheme3 < 100)
	{
        if( self.isServer )
        {
            [self.game homeScoreServerChange: HomescoreIndexTheme3];
        } else {
            return;
        }
		int temp = HomescoreIndexTheme3;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
        if ([self.homeRightFlipView isKindOfClass:[JDFlipImageView class]])
        {
            JDFlipImageView *flipImageView = (JDFlipImageView*)self.homeRightFlipView;
            [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigit]] setFlip:isDownFlip];
        }
        
        if ((secondDigit == 0 && isDownFlip == NO) || (secondDigit == 9 && isDownFlip == YES)) {
			
            if ([self.homeLeftFlipView isKindOfClass:[JDFlipImageView class]])
            {
                JDFlipImageView *flipImageView = (JDFlipImageView*)self.homeLeftFlipView;
                
                [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigit]] setFlip:isDownFlip];
            }
		}
		else
		{
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme3)];
		[UIView commitAnimations];
		
        homeScoreFirstDigitTheme3 = firstDigit;
	}
}

-(void)dimUpHomeTheme3{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
	[Theme3LeftHomeImageview setAlpha:1.0];
	[Theme3RightHomeImageView setAlpha:1.0];
	[UIView commitAnimations];
}

-(void)guestScoreChangeTheme3: (BOOL) isDownFlip
{
	if (GuestScoreIndexTheme3 > 99) {
		GuestScoreIndexTheme3 = 99;
		return;
	}
	if (GuestScoreIndexTheme3 < 0) {
		GuestScoreIndexTheme3 = 0;
		return;
	}
	
	if(GuestScoreIndexTheme3 < 100)
	{
        if( self.isServer )
        {
            [self.game guestScoreServerChange: GuestScoreIndexTheme3];
        } else {
            return;
        }
		int temp = GuestScoreIndexTheme3;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
        if ([self.guestRightFlipView isKindOfClass:[JDFlipImageView class]])
        {
            JDFlipImageView *flipImageView = (JDFlipImageView*) self.guestRightFlipView;
            
            [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigit]] setFlip:isDownFlip];
            
        }
		
		if ((secondDigit == 0 && isDownFlip == NO) || (secondDigit == 9 && isDownFlip == YES))
		{
			
            if ([self.guestLeftFlipView isKindOfClass:[JDFlipImageView class]])
            {
                JDFlipImageView *flipImageView1 = (JDFlipImageView*)self.guestLeftFlipView;
                
                [flipImageView1 setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigit]] setFlip:isDownFlip];
            }
		}
		else
		{
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme3)];
		[UIView commitAnimations];
        
		guestScoreFirstDigitTheme3 = firstDigit;
        
	}
    
}

-(void)dimUpGuestTheme3
{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
    
    [Theme3RightGuestImageView setAlpha:1.0];
	[Theme3LeftGuestImageview setAlpha:1.0];
	[UIView commitAnimations];
	
}

- (void) setupImageTheme3:(UIImageView *)imgView :(int)digit{
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"] == 1){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"sb0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"sb1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"sb2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"sb3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"sb4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"sb5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"sb6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"sb7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"sb8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"sb9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==2){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"sb0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"sb1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"sb2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"sb3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"sb4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"sb5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"sb6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"sb7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"sb8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"sb9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==3){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"sb0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"sb1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"sb2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"sb3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"sb4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"sb5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"sb6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"sb7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"sb8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"sb9.png"]];
                break;
        }
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==4){
        
        switch (digit) {
            case 0:
                [imgView setImage:[UIImage imageNamed:@"sb0.png"]];
                break;
            case 1:
                [imgView setImage:[UIImage imageNamed:@"sb1.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"sb2.png"]];
                break;
            case 3:
                [imgView setImage:[UIImage imageNamed:@"sb3.png"]];
                break;
            case 4:
                [imgView setImage:[UIImage imageNamed:@"sb4.png"]];
                break;
            case 5:
                [imgView setImage:[UIImage imageNamed:@"sb5.png"]];
                break;
            case 6:
                [imgView setImage:[UIImage imageNamed:@"sb6.png"]];
                break;
            case 7:
                [imgView setImage:[UIImage imageNamed:@"sb7.png"]];
                break;
            case 8:
                [imgView setImage:[UIImage imageNamed:@"sb8.png"]];
                break;
            case 9:
                [imgView setImage:[UIImage imageNamed:@"sb9.png"]];
                break;
        }
    }
}
-(void)Theme3ColorChange{
    int tempHome=HomescoreIndexTheme3;
    
    int secondDigitHome = tempHome % 10;
    tempHome = tempHome / 10;
    int firstDigitHome = tempHome;
    
    int temp=GuestScoreIndexTheme3;
    
    int secondDigit = temp % 10;
    temp = temp / 10;
    int firstDigit = temp;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"] == 1){
        
        Theme3LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigit]];
        
        Theme3RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigit]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
        Theme3LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigit]];
        
        Theme3RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigit]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
        Theme3LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigit]];
        
        Theme3RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigit]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
        Theme3LeftGuestImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigit]];
        
        Theme3RightGuestImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigit]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"] == 1){
        
        Theme3LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigitHome]];
        
        Theme3RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
        
        Theme3LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigitHome]];
        
        Theme3RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
        
        Theme3LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigitHome]];
        
        Theme3RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigitHome]];
        
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
        
        Theme3LeftHomeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",firstDigitHome]];
        
        Theme3RightHomeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sb%d.png",secondDigitHome]];
    }
    
    if ([self.guestLeftFlipView isKindOfClass:[JDFlipImageView class]])
    {
        JDFlipImageView *flipImageView = (JDFlipImageView*) self.guestLeftFlipView;
        
        [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigitHome]]];
        
    }
    
    if ([self.guestRightFlipView isKindOfClass:[JDFlipImageView class]])
    {
        JDFlipImageView *flipImageView = (JDFlipImageView*) self.guestRightFlipView;
        
        [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigitHome]]];
        
    }
    
    if ([self.homeLeftFlipView isKindOfClass:[JDFlipImageView class]])
    {
        JDFlipImageView *flipImageView = (JDFlipImageView*) self.homeLeftFlipView;
        
        [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigitHome]]];
        
    }
    
    if ([self.homeRightFlipView isKindOfClass:[JDFlipImageView class]])
    {
        JDFlipImageView *flipImageView = (JDFlipImageView*) self.homeRightFlipView;
        
        [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigitHome]]];
        
    }
    
}

////////////////////////////////////////////
#pragma mark VolleyBall scoreboard Actions and common actions and method
//////////////////////////////////////////// Volleyball and common aqctions and methods//////////////////////////////
-(IBAction)tutorialButtonClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [Tutorial setFrame:CGRectMake(0, 0, 480 * scoreboardWidthRate, 320 * scoreboardHeightRate)];
    [self.view bringSubviewToFront:Tutorial];
    [UIView commitAnimations];
}

-(IBAction)regulerSBButtonClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/scoreboard-pro/id442976974?mt=8"]];
}

-(IBAction) webViewCloseButtonClick:(id)sender
{
    [bgfade removeFromSuperview];
    
    [webView removeFromSuperview];
}

-(void)FaceBookIconClicked{
    NSLog(@"Facebook Button Clicked");
    
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Scoreboard-Mobile/491660797511058"]];
    bgfade=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgfade];
    [bgfade setBackgroundColor:[UIColor blackColor]];
    [bgfade setAlpha:0.6];
    
	NSString *facebookURLString = @"https://www.facebook.com/pages/Scoreboard-Mobile/491660797511058";
    NSURL *url = [NSURL URLWithString: facebookURLString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL: url];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(20 * scoreboardWidthRate, 20 * scoreboardHeightRate, 440 * scoreboardWidthRate, 280 * scoreboardHeightRate)];
    webView.delegate = self;
    [webView loadRequest: requestObj];
    
    UIImage *backImage=[UIImage imageNamed:@"cancelButton.png"];
    UIButton *m_pButtonWebViewClose=[UIButton buttonWithType:UIButtonTypeCustom];
    m_pButtonWebViewClose.frame=CGRectMake(428 * scoreboardWidthRate, -7 * scoreboardHeightRate, 20 * scoreboardWidthRate,18 * scoreboardHeightRate);
    [m_pButtonWebViewClose addTarget:self action:@selector(webViewCloseButtonClick:) forControlEvents:UIControlEventTouchDown];
    [m_pButtonWebViewClose setImage:backImage forState:UIControlStateNormal];
    [webView addSubview:m_pButtonWebViewClose];
    
    
    [self.view addSubview:webView];
    
}
-(void)TwitterIconClicked{
    NSLog(@"Twitter Button Clicked");
    
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/SoundHouseLLC"]];
    
	NSString *facebookURLString = @"https://twitter.com/SoundHouseLLC";
    NSURL *url = [NSURL URLWithString: facebookURLString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL: url];
    bgfade=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgfade];
    [bgfade setBackgroundColor:[UIColor blackColor]];
    [bgfade setAlpha:0.6];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(428 * scoreboardWidthRate, -7 * scoreboardHeightRate, 440 * scoreboardWidthRate, 280 * scoreboardHeightRate)];
    webView.delegate = self;
    [webView loadRequest: requestObj];
    
    UIImage *backImage=[UIImage imageNamed:@"cancelButton.png"];
    UIButton *m_pButtonWebViewClose=[UIButton buttonWithType:UIButtonTypeCustom];
    m_pButtonWebViewClose.frame=CGRectMake(420 * scoreboardWidthRate, 5 * scoreboardHeightRate, 20 * scoreboardWidthRate, 18 * scoreboardHeightRate);
    [m_pButtonWebViewClose addTarget:self action:@selector(webViewCloseButtonClick:) forControlEvents:UIControlEventTouchDown];
    [m_pButtonWebViewClose setImage:backImage forState:UIControlStateNormal];
    [webView addSubview:m_pButtonWebViewClose];
    
    
    [self.view addSubview:webView];
    
    
}
-(void)moveMainScrollViewLeft{
    if (VolleyBallViewBigger == NO && DigitalViewBigger == NO && Theme1Bigger == NO && Theme2Bigger == NO) {
        NSLog(@"Scrolled from Right to Left");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        if (BackGroundScroll.center.x>-50 * scoreboardWidthRate) {
            
            [BackGroundScroll setCenter:CGPointMake((BackGroundScroll.center.x-301.9) * scoreboardWidthRate, BackGroundScroll.center.y * scoreboardHeightRate)];
            PageNumber++;
            
        }
        
        NSLog(@"The page number value is %d", PageNumber);
        
        
        NSLog(@"TheScroll View Center is when scroll Left %f",BackGroundScroll.center.x);
        
        [UIView commitAnimations];
        
        if (PageNumber==1) {
            [VolleyBallView setUserInteractionEnabled:YES];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
            [LeftSideViewForTap setBackgroundColor:[UIColor blackColor]];
            [RightsideViewForTap setBackgroundColor:[UIColor clearColor]];
        }
        else if(PageNumber==2){
            [LeftSideViewForTap setBackgroundColor:[UIColor clearColor]];
            [LeftSideViewForTap setBackgroundColor:[UIColor clearColor]];
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:YES];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
        }
        else if(PageNumber==3){
            [RightsideViewForTap setBackgroundColor:[UIColor clearColor]];
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:YES];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
        }
        else if(PageNumber==4){
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:YES];
            [LeftSideViewForTap setBackgroundColor:[UIColor clearColor]];
            [RightsideViewForTap setBackgroundColor:[UIColor blackColor]];
            
        }
    }
}

-(void)moveMainScrollViewRight{
    
    if (VolleyBallViewBigger == NO && DigitalViewBigger == NO && Theme1Bigger == NO &&Theme2Bigger == NO) {
        
        NSLog(@"Scrolled from left to right");
        
        NSLog(@"TheScroll View Center is when scroll right %f",BackGroundScroll.center.x);
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        if (BackGroundScroll.center.x * scoreboardWidthRate < 550 * scoreboardWidthRate) {
            PageNumber--;
            
            [BackGroundScroll setCenter:CGPointMake((BackGroundScroll.center.x+301.9) * scoreboardWidthRate, BackGroundScroll.center.y * scoreboardHeightRate)];
        }
        NSLog(@"The page number value is %d",PageNumber);
        if (PageNumber==1) {
            [VolleyBallView setUserInteractionEnabled:YES];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
            [LeftSideViewForTap setBackgroundColor:[UIColor blackColor]];
            [RightsideViewForTap setBackgroundColor:[UIColor clearColor]];
            
        }
        else if(PageNumber==2){
            [LeftSideViewForTap setBackgroundColor:[UIColor clearColor]];
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:YES];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
        }
        else if(PageNumber==3){
            [RightsideViewForTap setBackgroundColor:[UIColor clearColor]];
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:YES];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:NO];
        }
        else if(PageNumber==4){
            [VolleyBallView setUserInteractionEnabled:NO];
            [DigitalScoreboard setUserInteractionEnabled:NO];
            [DigitalScoreboardNewtheme1 setUserInteractionEnabled:NO];
            [DigitalScoreBordNewTheme2 setUserInteractionEnabled:YES];
            [LeftSideViewForTap setBackgroundColor:[UIColor clearColor]];
            [RightsideViewForTap setBackgroundColor:[UIColor blackColor]];
            
        }
        
        [UIView commitAnimations];
        NSLog(@"TheScroll View Center is when scroll right %f",BackGroundScroll.center.x);
        
    }
}
#pragma mark Tap to incerse Score
-(void)homeScoreLabelTap:(UIGestureRecognizer *)gesture
{
    if (frontHomeLableScore<99)
    {
        if( self.isServer )
        {
            [self.game homeScoreServerChange: frontHomeLableScore + 1];
        } else {
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontHomeScoreLable cache:YES];
        [UIView commitAnimations];
        
        
        frontHomeLableScore +=1;
        [frontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
        [self playSound];
    }
}
-(void)guestScoreLabelTap:(UIGestureRecognizer *)gesture
{
    if (frontGuestLableScore<99)
    {
        if( self.isServer )
        {
            [self.game guestScoreServerChange: frontGuestLableScore + 1];
        } else {
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontGuestScoreLable cache:YES];
        [UIView commitAnimations];
        
        frontGuestLableScore +=1;
        [frontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
        frontGuestScoreLable.adjustsFontSizeToFitWidth = YES;
        frontHomeScoreLable.adjustsFontSizeToFitWidth = YES;
        [self playSound];
    }
}
-(void)hiddenHomeScoreLabelTap:(UIGestureRecognizer *)gesture
{
    if (frontHomeLableScore<99)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.hiddenFrontHomeScoreLable cache:YES];
        [UIView commitAnimations];
        
        
        frontHomeLableScore +=1;
        [hiddenFrontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
        [self playSound];
    }
}
-(void)hiddenGuestScoreLabelTap:(UIGestureRecognizer *)gesture
{
    if (frontGuestLableScore<99)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.hiddenFrontGuestScoreLable cache:YES];
        [UIView commitAnimations];
        
        frontGuestLableScore +=1;
        [hiddenFrontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
        frontGuestScoreLable.adjustsFontSizeToFitWidth = YES;
        frontHomeScoreLable.adjustsFontSizeToFitWidth = YES;
        [self playSound];
    }
}
#pragma mark Audio Initialization method
-(void)initializeAudio{
	NSString *path=[[NSBundle mainBundle]pathForResource:@"pageflip" ofType:@"mp3"];
	myAudio=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL ];
	myAudio.delegate=self;
	myAudio.volume=2.0;
	//[myAudio play];
	//[myAudio stop];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryAmbient
     error: &setCategoryError];
    
    if (setCategoryError) { /* handle the error condition */ }
}
#pragma mark Period lable score change methods
-(void)periodLableScoreUp{
    if (!self.isServer && isBluetooth) {
        return;
    }
	if(periodIndex<9)
		periodIndex+=1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.preiodLabel cache:YES];
    [UIView commitAnimations];
    [self performSelector:@selector(setscorenow) withObject:nil afterDelay:0.0];
    
    
    [self playSound];
    
    if( self.isServer && isBluetooth )
    {
        [self.game periodNumberChangeServer: periodIndex];
    } else {
        return;
    }
    
}
-(void)setscorenow{
    [preiodLabel setText:[NSString stringWithFormat:@"%d",periodIndex]];
    
}
-(void)periodLableScoreDown{
    if (!self.isServer && isBluetooth) {
        return;
    }
	
	if (periodIndex>1) {
		periodIndex-=1;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.preiodLabel cache:YES];
        [UIView commitAnimations];
        [self performSelector:@selector(setscorenow) withObject:nil afterDelay:0.0];
        
        if( self.isServer && isBluetooth )
        {
            [self.game periodNumberChangeServer: periodIndex];
        } else {
            return;
        }
        
	}
}
#pragma mark Scrollview move methods
-(void)MainScrollViewRight{
}
-(void)MainScrollViewLeft{
    
}
-(void)moveScrollViewRight{
	
	if ([frontHomeLableName isEqualToString:@"frontHomeScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:frontHomeScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontHomeScoreLable];
		
		[self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:backHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:hiddenBackHomeScoreLable withScore:backHomeLableScore];
    }
	if([frontHomeLableName isEqualToString:@"backHomeScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:backHomeScoreLable];
        [scrollView bringSubviewToFront:hiddenBackHomeScoreLable];
		
		[self setAlignmentForLable:backHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:hiddenBackHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
	}
    
    if ([frontGuestLableName isEqualToString:@"frontGuestScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:frontGuestScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontGuestScoreLable];
		
		[self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:backGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:hiddenBackGuestScoreLable withScore:backGuestLableScore];
		
        
    }
	if([frontGuestLableName isEqualToString:@"backGuestScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:backGuestScoreLable];
        [scrollView bringSubviewToFront:hiddenBackGuestScoreLable];
		
		[self setAlignmentForLable:backGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:hiddenBackGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
		
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    NSLog(@"the scroll view center is %f",scrollView.center.x);
    
	
	[self playSound];
    if (VolleyBallCourtChanged==NO && VolleyBallViewBigger==YES) {
        VolleyBallCourtChanged=YES;
        
        if( self.isServer && isBluetooth)
        {
            [self.game rightSwipeServer: 101];
        }
        
        if( !self.isServer && isBluetooth)
        {
            return;
        }
        
        int XpositionForHome=frontHomeScoreLable.frame.origin.x;
        int XpositionForGuest=frontGuestScoreLable.frame.origin.x;
        
        
        [frontGuestScoreLable setFrame:CGRectMake(XpositionForHome, frontHomeScoreLable.frame.origin.y, frontHomeScoreLable.frame.size.width,frontHomeScoreLable.frame.size.height)];
        
        
        
        [frontHomeScoreLable setFrame:CGRectMake(XpositionForGuest, frontGuestScoreLable.frame.origin.y, frontGuestScoreLable.frame.size.width, frontGuestScoreLable.frame.size.height)];
        
        //        [homeTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        //        [guestTextField setFrame:CGRectMake(285 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        //        [guestTextField setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        //        [homeTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        
        [homeTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        [guestTextField setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        
    }
    [UIView commitAnimations];
}
-(void)moveScrollViewLeft{
	
    if ([frontHomeLableName isEqualToString:@"frontHomeScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:frontHomeScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontHomeScoreLable];
		
		[self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:backHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:hiddenBackHomeScoreLable withScore:backHomeLableScore];
    }
	if([frontHomeLableName isEqualToString:@"backHomeScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:backHomeScoreLable];
        [scrollView bringSubviewToFront:hiddenBackHomeScoreLable];
		
		[self setAlignmentForLable:backHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:hiddenBackHomeScoreLable withScore:backHomeLableScore];
		[self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
		[self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
	}
    
    if ([frontGuestLableName isEqualToString:@"frontGuestScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:frontGuestScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontGuestScoreLable];
		
		[self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:backGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:hiddenBackGuestScoreLable withScore:backGuestLableScore];
		
        
    }
	if([frontGuestLableName isEqualToString:@"backGuestScoreLable"]) {
		
		//getting back lable to front
		[scrollView bringSubviewToFront:backGuestScoreLable];
        [scrollView bringSubviewToFront:hiddenBackGuestScoreLable];
		
		[self setAlignmentForLable:backGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:hiddenBackGuestScoreLable withScore:backGuestLableScore];
		[self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
		[self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
		
	}
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
	
    NSLog(@"the scroll view center is %f",scrollView.center.x);
    
	[self playSound];
    if (VolleyBallCourtChanged==YES && VolleyBallViewBigger==YES) {
        VolleyBallCourtChanged=NO;
        
        if( self.isServer && isBluetooth)
        {
            [self.game leftSwipeServer: 101];
        }
        if( !self.isServer && isBluetooth)
        {
            return;
        }
        
        
        int XpositionForHome=frontHomeScoreLable.frame.origin.x;
        int XpositionForGuest=frontGuestScoreLable.frame.origin.x;
        
        
        [frontGuestScoreLable setFrame:CGRectMake(XpositionForHome, frontHomeScoreLable.frame.origin.y, frontHomeScoreLable.frame.size.width,frontHomeScoreLable.frame.size.height)];
        
        
        
        [frontHomeScoreLable setFrame:CGRectMake(XpositionForGuest, frontGuestScoreLable.frame.origin.y, frontGuestScoreLable.frame.size.width, frontGuestScoreLable.frame.size.height)];
        [guestTextField setFrame:CGRectMake(24 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        [homeTextField setFrame:CGRectMake(290 * scoreboardWidthRate, 251 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
        
    }
    
    
    [UIView commitAnimations];
    
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.carousel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    
    _carousel.delegate = nil;
	_carousel.dataSource = nil;
    
	[suspendedLableName release];
	//[keyBrdDoneBtnView release];
    [frontHomeLableName release];
    [frontGuestLableName release];
	[hiddenBackHomeScoreLable release];
	[hiddenFrontHomeScoreLable release];
	[hiddenBackGuestScoreLable release];
	[hiddenFrontGuestScoreLable release];
	[hiddenHomeTextField release];
	[hiddenGuestTextField release];
	[guestLableImageName release];
	[homeLableImageName release];
	[backHomeScoreLable release];
	[frontHomeScoreLable release];
	[backGuestScoreLable release];
	[frontGuestScoreLable release];
	[scrollView release];
	[preiodLabel release];
	[homeTextField release];
	[guestTextField release];
	[presentLable release];
    [super dealloc];
}
#pragma mark PlaySound method
-(void)playSound
{
}
#pragma mark Button clicke events
-(IBAction)doneButtonClick:(id)sender
{
    
	[homeTextField resignFirstResponder];
	[guestTextField resignFirstResponder];
	[hiddenHomeTextField resignFirstResponder];
	[hiddenGuestTextField resignFirstResponder];
	
	// scroll view back down
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	CGRect rect = self.view.frame;
	rect.origin.y = 0;  //scroll to
	self.view.frame = rect;
	[UIView commitAnimations];
    
}
- (IBAction)settingsButtonClick:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
    
    [UIView beginAnimations:nil context:nil];
  	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationOptionCurveEaseIn forView:self.navigationController.view cache:YES];
    [UIView commitAnimations];
	
    UIDevice  *thisDevice = [UIDevice currentDevice];
    Theme3SettingsViewController_iPhone *theme3SettingsViewController;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    theme3SettingsViewController = [[Theme3SettingsViewController_iPhone alloc]  initWithNibName:@"Theme3SettingsViewController_iPad" bundle:nil];
    theme3SettingsViewController.delegateSetting = self;
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    theme3SettingsViewController.defaultsKey = @"SwatchColor";
    theme3SettingsViewController.guestKey = @"GuestColor";
    
#else
    // We re-use the current value set to the background of this demonstration view
    theme3SettingsViewController.HomeColor = frontHomeScoreLable.backgroundColor;
    theme3SettingsViewController.GuestColor = frontGuestScoreLable.backgroundColor;
    
#endif
    
    NSLog(@"Setting Dialog");
    //    [self presentModalViewController:theme3SettingsViewController animated:YES];
    //    [self presentViewController:theme3SettingsViewController animated:NO completion:nil];
    [self.view addSubview: theme3SettingsViewController.view];
    
    float height = 768;
    float width = 1024;
    
    [theme3SettingsViewController.view setFrame:CGRectMake(0, height, width, height)];
    [UIView beginAnimations:nil context:NULL];
    [theme3SettingsViewController.view setFrame:CGRectMake(0, 0, width, height)];
    [UIView commitAnimations];
    
    
}
- (IBAction)resetButtonClick:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1  forKey:@"Scorebaordnumber"];
    [prefs synchronize];
	UIActionSheet *resetActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reset Names",@"Reset Score", @"Reset Both", nil];
    //Revmob reset
    
    [resetActionSheet setTag:ACTION_SHEET_TAG];
    [resetActionSheet showInView:self.view];
    [resetActionSheet release];
}
#pragma mark -
#pragma mark UIAction sheet delegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked Button Index:%d", buttonIndex);
    
    switch (buttonIndex) {
        case 0:
            [self resetNames];
            
            break;
        case 1:
            [self resetScore];
            
            break;
        case 2:
			[self resetBoth];
            break;
            
        default:
            NSLog(@"clicked Button Index:%d", buttonIndex);
            break;
    }
}

#pragma mark Reset button methods
-(void)resetNames
{
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==1){
        
        homeTextField.text=@"Home";
        guestTextField.text=@"Guest";
        hiddenHomeTextField.text=@"Home";
        hiddenGuestTextField.text=@"Guest";
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==2){
        
        guestTextFieldDigital.text=@"Guest";
        homeTextFieldDigital.text=@"Home";
        
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==3){
        guestTextFieldTheme1.text=@"Guest";
        homeTextFieldTheme1.text=@"Home";
        
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==4){
        guestTextFieldTheme2.text=@"Guest";
        homeTextFieldTheme2.text=@"Home";
        
        NSLog(@"its the fourth scoreboard");
        
    }
    else{
        guestTextFieldTheme3.text=@"Guest";
        homeTextFieldTheme3.text=@"Home";
        
        NSLog(@"its the fifth scoreboard");
    }
}

-(void)ScoreReset
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!!" message:@"Are you sure to reset score?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//    [alert setTag: 901];
//    
//    [alert show];
//    [alert release];
    
    [self resetScore];
}

-(void)AllReset
{
    
    HomeBackLeftViewTheme3.backgroundColor = [UIColor whiteColor];
    HomeBackRightViewTheme3.backgroundColor = [UIColor whiteColor];
    
    GuestBackLeftViewTheme3.backgroundColor = [UIColor whiteColor];
    GuestBackRightViewTheme3.backgroundColor = [UIColor whiteColor];
    [self resetBoth];
    
    int avalue=[[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"];
    
    if (avalue==1) {
        periodIndex=1;
        [preiodLabel setText:[NSString stringWithFormat:@"%d",periodIndex]];
        
    }
    
    if (avalue==3) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutesTheme1"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"secondsTheme1"];
    }
    
    
    if (avalue==2) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"minutes"];
        [[NSUserDefaults standardUserDefaults] setInteger:00 forKey:@"seconds"];
    }
    
    
    
}

- (void)FaceBookShare
{
    [self FaceBookIconClicked];
}

- (void)startBluetooth
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    UIDevice  *thisDevice = [UIDevice currentDevice];
    BluetoothViewController *bluetoothViewController = [[BluetoothViewController alloc]  initWithNibName:@"BluetoothViewController_iPad" bundle:nil];
    [self.navigationController pushViewController:bluetoothViewController animated:NO];
    [bluetoothViewController release];
}

- (void)TwitterShare
{
    [self TwitterIconClicked];
}

-(void)resetScore
{
	//resetting the lables and that valuee as it was when the application started
	
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==1){
        frontHomeLableScore=0;
        backHomeLableScore=1;
        frontGuestLableScore=0;
        backGuestLableScore=1;
        
        
        frontHomeLableName=@"frontHomeScoreLable";
        frontGuestLableName=@"frontGuestScoreLable";
        
        [scrollView bringSubviewToFront:frontHomeScoreLable];
        [scrollView bringSubviewToFront:frontGuestScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontHomeScoreLable];
        [scrollView bringSubviewToFront:hiddenFrontGuestScoreLable];
        periodIndex=1;
        [preiodLabel setText:[NSString stringWithFormat:@"%d",periodIndex]];
        
        [self setAlignmentForLable:hiddenBackHomeScoreLable withScore:backHomeLableScore];
        [self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
        [self setAlignmentForLable:hiddenBackGuestScoreLable withScore:backGuestLableScore];
        [self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
        [self setAlignmentForLable:backHomeScoreLable withScore:backHomeLableScore];
        [self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
        [self setAlignmentForLable:backGuestScoreLable withScore:backGuestLableScore];
        [self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
        
    }
    else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==2){
        
        homeScoreIndex=0;
        guestScoreIndex=0;
        [self ChangeColor];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==3){
        
        homeScoreIndexTheme1=0;
        guestScoreIndexTheme1=0;
        [self Theme1ColorChange];
    }
    else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==4){
        NSLog(@"its the fourth scoreboard");
        HomescoreIndexTheme2=0;
        GuestScoreIndexTheme2=0;
        [self Theme2ColorChange];
    }
    else
    {
        HomescoreIndexTheme3 = 0;
        GuestScoreIndexTheme3 = 0;
        [self Theme3ColorChange];
    }
    
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitID with your
    // interstitial ad unit id.
    
    self.dfpInterstitial = [[[GADInterstitial alloc] init] autorelease];
    self.dfpInterstitial.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitID with your
    // interstitial ad unit id.
    self.dfpInterstitial.adUnitID = @"ca-app-pub-2827613882829649/2406163157";
    
    // Load the interstitial with an ad request.
    [self.dfpInterstitial loadRequest:[GADRequest request]];

}
-(void)resetBoth
{
    [self resetScore];
    [self resetNames];
}
-(void)setAlignmentForLable:(UILabel *)aScoreLable withScore:(int)aScore
{
	[aScoreLable setText:[NSString stringWithFormat:@"%d",aScore]];
	
	if (aScore>9)
		[aScoreLable setTextAlignment:UITextAlignmentCenter];
	else
		[aScoreLable setTextAlignment:UITextAlignmentCenter];
}

#pragma mark -
#pragma mark Text field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[homeTextField resignFirstResponder];
	[guestTextField resignFirstResponder];
	[hiddenHomeTextField resignFirstResponder];
	[hiddenGuestTextField resignFirstResponder];
    
    [guestTextFieldDigital resignFirstResponder];
    [homeTextFieldDigital resignFirstResponder];
    
    [homeTextFieldTheme1 resignFirstResponder];
    [guestTextFieldTheme1 resignFirstResponder];
    
    [homeTextFieldTheme2 resignFirstResponder];
    [guestTextFieldTheme2 resignFirstResponder];
    
    [homeTextFieldTheme3 resignFirstResponder];
    [guestTextFieldTheme3 resignFirstResponder];
    
    [guestTextFieldDigital resignFirstResponder];
    [homeTextFieldDigital resignFirstResponder];
    
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
	if (textField.inputAccessoryView == nil) {
        
        [Tutorial setHidden:YES];
        
		// Loading the AccessoryView nib file sets the accessoryView outlet.
		//textField.inputAccessoryView = keyBrdDoneBtnView;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3	];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView commitAnimations];
    
    if (Theme2ViewBigger == YES || Theme3ViewBigger == YES) {
        if (textField!=guestTextFieldTheme2||textField!=homeTextFieldTheme2) {
            //self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
        }
        if (textField != guestTextFieldTheme3 || textField != homeTextFieldTheme3) {
            //self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    else{
        if (isBluetooth) {
            self.view.frame = CGRectMake(150 * scoreboardWidthRate , 0, self.view.frame.size.width, self.view.frame.size.height);
        } else {
            self.view.frame = CGRectMake(0 , -150 * scoreboardHeightRate, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
	if ([homeTextField.text isEqualToString:@""] ) {
		homeTextField.text =@"Home";
	}
	if ([guestTextField.text isEqualToString:@""] ) {
		guestTextField.text =@"Guest";
	}
	
	if ([hiddenHomeTextField.text isEqualToString:@""] ) {
		hiddenHomeTextField.text =@"Home";
	}
	if ([hiddenGuestTextField.text isEqualToString:@""] ) {
		hiddenGuestTextField.text =@"Guest";
	}
    if ([homeTextFieldDigital.text isEqualToString:@""]) {
        homeTextFieldDigital.text=@"Home";
        
    }
    if ([homeTextFieldTheme1.text isEqualToString:@""]) {
        homeTextFieldTheme1.text=@"Home";
        
    }
    
    if ([homeTextFieldTheme2.text isEqualToString:@""]) {
        homeTextFieldTheme2.text=@"Home";
    }
    
    if ([homeTextFieldTheme3.text isEqualToString:@""]) {
        homeTextFieldTheme3.text=@"Home";
    }
    
    if([guestTextFieldDigital.text isEqualToString:@""]){
        [guestTextFieldDigital setText:@"Guest"];
        
    }
    if([guestTextFieldTheme1.text isEqualToString:@""]){
        [guestTextFieldTheme1 setText:@"Guest"];
    }
    
    if([guestTextFieldTheme2.text isEqualToString:@""]){
        [guestTextFieldTheme2 setText:@"Guests"];
    }
    
    if([guestTextFieldTheme3.text isEqualToString:@""]){
        [guestTextFieldTheme3 setText:@"Guests"];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [Tutorial setHidden:NO];
    
    if ((textField.tag % 2) == 1) {
        [self.game rightLabelNameChangeServer: textField.text];
    } else {
        [self.game leftLabelNameChangeServer: textField.text];
    }
    
    return YES;
}

#pragma mark Hidden score change methods
-(void)hiddenFrontHomeScoreLableScoreUp;
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.hiddenFrontHomeScoreLable cache:YES];
    [UIView commitAnimations];
    
    frontHomeLableScore +=1;
    [hiddenFrontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
    [self playSound];
    
}

-(void)hiddenFrontHomeScoreLableScoreDown;
{
    
    if (frontHomeLableScore>-9) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.hiddenFrontHomeScoreLable cache:YES];
        [UIView commitAnimations];
        frontHomeLableScore -=1;
        [hiddenFrontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
        [self playSound];
    }
    
}

-(void)hiddenFrontGuestScoreLableScoreUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.hiddenFrontGuestScoreLable cache:YES];
    [UIView commitAnimations];
    
    frontGuestLableScore +=1;
    [hiddenFrontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
    [self playSound];
}

-(void)hiddenFrontGuestScoreLableScoreDown
{
    if (frontGuestLableScore>-9) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.hiddenFrontGuestScoreLable cache:YES];
        [UIView commitAnimations];
        frontGuestLableScore -=1;
        [hiddenFrontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
        [self playSound];
    }
    
}
#pragma mark Score change methods
-(void)frontHomeScoreLableScoreUp
{
    if( self.isServer )
    {
        [self.game homeScoreServerChange: frontHomeLableScore + 1];
    } else {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontHomeScoreLable cache:YES];
    [UIView commitAnimations];
    
    
    
    frontHomeLableScore +=1;
    
    [frontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
    [self playSound];
    
}
-(void)frontHomeScoreLableScoreDown
{
    if (frontHomeLableScore>-9) {
        if( self.isServer )
        {
            [self.game homeScoreServerChange: frontHomeLableScore - 1];
        } else {
            return;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.frontHomeScoreLable cache:YES];
        [UIView commitAnimations];
        frontHomeLableScore -=1;
        [frontHomeScoreLable setText:[NSString stringWithFormat:@"%d",frontHomeLableScore]];
        [self playSound];
    }
    
}

-(void)frontGuestScoreLableScoreUp
{
    if( self.isServer )
    {
        [self.game guestScoreServerChange: frontGuestLableScore + 1];
    } else {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontGuestScoreLable cache:YES];
    [UIView commitAnimations];
    
    frontGuestLableScore +=1;
    [frontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
    [self playSound];
    
}

-(void)frontGuestScoreLableScoreDown
{
    if (frontGuestLableScore>-9) {
        if( self.isServer )
        {
            [self.game guestScoreServerChange: frontGuestLableScore - 1];
        } else {
            return;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.frontGuestScoreLable cache:YES];
        [UIView commitAnimations];
        frontGuestLableScore -=1;
        [frontGuestScoreLable setText:[NSString stringWithFormat:@"%d",frontGuestLableScore]];
        [self playSound];
    }
    
}
-(void)frontHomeScoreLableInitialization
{
    //creating the the lable with same properties
    frontHomeScoreLable = [[UILabel alloc] initWithFrame:CGRectMake((HOMESCORE_LABLE_XPOSITION-38) * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION+52) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH-29) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT-41) * scoreboardHeightRate)];
    
    NSLog(@"..................%d,and%d", GUESTSCORE_LABLE_WIDTH-26, GUESTSCORE_LABLE_HEIGHT-4);
    
    //    [frontHomeScoreLable  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.jpg"]]];
    [frontHomeScoreLable  setBackgroundColor:[UIColor blueColor]];
    [frontHomeScoreLable setFont:[UIFont systemFontOfSize:(LABLE_FONTSIZE - 10) * scoreboardHeightRate]];
    [self setAlignmentForLable:frontHomeScoreLable withScore:frontHomeLableScore];
    [frontHomeScoreLable setUserInteractionEnabled:YES];
    [frontHomeScoreLable setTextColor:[UIColor whiteColor]];
    frontHomeScoreLable.layer.anchorPoint=CGPointMake(0, 0);
    [frontHomeScoreLable setFrame:CGRectMake(467 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
    // [frontHomeScoreLable setAlpha:0.3];
    
    //adding swipe guesture to the lable
    UISwipeGestureRecognizer *frontHomeScoreLableSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frontHomeScoreLableScoreUp)] autorelease];
    frontHomeScoreLableSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [frontHomeScoreLable addGestureRecognizer:frontHomeScoreLableSwipeUp];
    
    //adding swipe guesture to the lable
    UISwipeGestureRecognizer *frontHomeScoreLableSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frontHomeScoreLableScoreDown)] autorelease];
    frontHomeScoreLableSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [frontHomeScoreLable addGestureRecognizer:frontHomeScoreLableSwipeDown];
    
    
    [scrollView addSubview:frontHomeScoreLable];
    
    [scrollView bringSubviewToFront:frontHomeScoreLable];
    [scrollView bringSubviewToFront:hiddenFrontHomeScoreLable];
}

-(void)frontGuestScoreLableInitialization
{
    
    frontGuestScoreLable = [[UILabel alloc] initWithFrame:CGRectMake((GUESTSCORE_LABLE_XPOSITION - 13) * scoreboardWidthRate, GUESTSCORE_LABLE_YPOSITION * scoreboardHeightRate , (GUESTSCORE_LABLE_WIDTH + 18) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 40) * scoreboardHeightRate)];
    
    
    //    [frontGuestScoreLable  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red.jpg"]]];
    [frontGuestScoreLable  setBackgroundColor:[UIColor redColor]];
    //    [frontGuestScoreLable setFont:[UIFont fontWithName:@"Arial" size:LABLE_FONTSIZE-40]];
    [frontGuestScoreLable setFont:[UIFont systemFontOfSize:(LABLE_FONTSIZE - 10) * scoreboardHeightRate]];
    [self setAlignmentForLable:frontGuestScoreLable withScore:frontGuestLableScore];
    [frontGuestScoreLable setUserInteractionEnabled:YES];
    [frontGuestScoreLable setTextColor:[UIColor whiteColor]];
    //    frontGuestScoreLable.layer.anchorPoint = CGPointMake(0, 0);
    
    
    [frontGuestScoreLable setFrame:CGRectMake(255 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 106) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 23.2) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
    //frontGuestScoreLable.alpha=0.4;
    
    //adding swipe guesture to the lable
    UISwipeGestureRecognizer *frontGuestScoreLableSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frontGuestScoreLableScoreUp)] autorelease];
    frontGuestScoreLableSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [frontGuestScoreLable addGestureRecognizer:frontGuestScoreLableSwipeUp];
    
    //adding swipe guesture to the lable
    UISwipeGestureRecognizer *frontGuestScoreLableSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frontGuestScoreLableScoreDown)] autorelease];
    frontGuestScoreLableSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [frontGuestScoreLable addGestureRecognizer:frontGuestScoreLableSwipeDown];
    
    [scrollView addSubview:frontGuestScoreLable];
    
    [scrollView bringSubviewToFront:frontGuestScoreLable];
    [scrollView bringSubviewToFront:hiddenFrontGuestScoreLable];
}

-(void)hiddenFrontHomeScoreLableInitialization
{
    //    //creating the the lable with same properties
    //    hiddenFrontHomeScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(GUESTSCORE_LABLE_XPOSITION * scoreboardWidthRate,GUESTSCORE_LABLE_YPOSITION * scoreboardHeightRate, GUESTSCORE_LABLE_WIDTH * scoreboardWidthRate, GUESTSCORE_LABLE_HEIGHT * scoreboardHeightRate)];
    //
    //    //    [hiddenFrontHomeScoreLable  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.jpg"]]];
    //    [hiddenFrontHomeScoreLable  setBackgroundColor:[UIColor blueColor]];
    //    [hiddenFrontHomeScoreLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:LABLE_FONTSIZE * scoreboardHeightRate]];
    //    [self setAlignmentForLable:hiddenFrontHomeScoreLable withScore:frontHomeLableScore];
    //    [hiddenFrontHomeScoreLable setUserInteractionEnabled:YES];
    //    [hiddenFrontHomeScoreLable setTextColor:[UIColor whiteColor]];
    //    hiddenFrontHomeScoreLable.layer.anchorPoint=CGPointMake(0,0);
    //
    //    //adding swipe guesture to the lable
    //    UISwipeGestureRecognizer *hiddenFrontHomeScoreLableSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFrontHomeScoreLableScoreUp)] autorelease];
    //    hiddenFrontHomeScoreLableSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    //    [hiddenFrontHomeScoreLable addGestureRecognizer:hiddenFrontHomeScoreLableSwipeUp];
    //
    //    //adding swipe guesture to the lable
    //    UISwipeGestureRecognizer *hiddenFrontHomeScoreLableSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFrontHomeScoreLableScoreDown)] autorelease];
    //    hiddenFrontHomeScoreLableSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    //    [hiddenFrontHomeScoreLable addGestureRecognizer:hiddenFrontHomeScoreLableSwipeDown];
    //
    //
    //    [scrollView addSubview:hiddenFrontHomeScoreLable];
    //    [hiddenFrontHomeScoreLable setHidden:YES];
    
}
-(void)hiddenFrontGuestScoreLableInitialization
{
    //    //creating the the lable with same properties
    //    hiddenFrontGuestScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(HOMESCORE_LABLE_XPOSITION * scoreboardWidthRate, HOMESCORE_LABLE_YPOSITION * scoreboardHeightRate, HOMESCORE_LABLE_WIDTH * scoreboardWidthRate, HOMESCORE_LABLE_HEIGHT * scoreboardHeightRate)];
    //    //    [hiddenFrontGuestScoreLable  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red.jpg"]]];
    //    [hiddenFrontGuestScoreLable  setBackgroundColor:[UIColor redColor]];
    //    [hiddenFrontGuestScoreLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:LABLE_FONTSIZE * scoreboardHeightRate]];
    //    [self setAlignmentForLable:hiddenFrontGuestScoreLable withScore:frontGuestLableScore];
    //    [hiddenFrontGuestScoreLable setUserInteractionEnabled:YES];
    //    [hiddenFrontGuestScoreLable setTextColor:[UIColor whiteColor]];
    //    hiddenFrontGuestScoreLable.layer.anchorPoint=CGPointMake(0,0);
    //
    //    //adding swipe guesture to the lable
    //    UISwipeGestureRecognizer *hiddenFrontGuestScoreLableSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFrontGuestScoreLableScoreUp)] autorelease];
    //    hiddenFrontGuestScoreLableSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    //    [hiddenFrontGuestScoreLable addGestureRecognizer:hiddenFrontGuestScoreLableSwipeUp];
    //
    //    //adding swipe guesture to the lable
    //    UISwipeGestureRecognizer *hiddenFrontGuestScoreLableSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFrontGuestScoreLableScoreDown)] autorelease];
    //    hiddenFrontGuestScoreLableSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    //    [hiddenFrontGuestScoreLable addGestureRecognizer:hiddenFrontGuestScoreLableSwipeDown];
    //
    //    [scrollView addSubview:hiddenFrontGuestScoreLable];
    //    [hiddenFrontGuestScoreLable setHidden:YES];
    
}

-(IBAction)rightScollButtonClick:(id)sender
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    [scrollView setCenter:CGPointMake((scrollView.center.x+240) * scoreboardWidthRate, scrollView.center.y * scoreboardHeightRate)];
    [UIView commitAnimations];
    [self playSound];
}

-(IBAction)leftScrollButtonClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    [scrollView setCenter:CGPointMake((scrollView.center.x-240) * scoreboardWidthRate, scrollView.center.y * scoreboardHeightRate)];
    [UIView commitAnimations];
    [self playSound];
    
    
}
#pragma mark hans GameDelegate
- (void)boardisServer:(BOOL) isServer
{
    self.isServer = isServer;
}

- (void)clientHomeScoreIncreased:(NSString *) scoreString
{
    
    int score = [scoreString integerValue];
    
    if (self.isServer) {
        return;
    }
    
    if (gCurrentViewNum == 101) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        if (score > frontHomeLableScore) {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontHomeScoreLable cache:YES];
        } else {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.frontHomeScoreLable cache:YES];
        }
        [UIView commitAnimations];
        
        frontHomeLableScore = score;
        [frontHomeScoreLable setText:[NSString stringWithFormat:@"%d", score]];
        [self playSound];
        
        return;
    }
    if (gCurrentViewNum == 102) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		
		[self setupImage:hiddenRightHomeImageView :secondDigit];
		[self setupImage:rightHomeImageView :secondDigit];
		
		
		
		if (firstDigit!=0)
		{
			[self setupImage:hiddenLeftHomeImageView :firstDigit];
			[self setupImage:leftHomeImageView :firstDigit];
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4){
                hiddenLeftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftHomeImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
		}
		
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHome)];
		[UIView commitAnimations];
		
		homeScoreFirstDigit = firstDigit;
        
        return;
    }
    if (gCurrentViewNum == 103) {
        
        int temp = score;
		
		int secondDigit = temp %10;
		temp = temp / 10;
		int firstDigit = temp;
		
		
		[self setupImageTheme1:hiddenRightHomeImageViewTheme1 :secondDigit];
		[self setupImageTheme1:rightHomeImageViewTheme1 :secondDigit];
		
		if (firstDigit!=0)
		{
			[self setupImageTheme1:hiddenLeftHomeImageViewTheme1 :firstDigit];
			[self setupImageTheme1:leftHomeImageViewTheme1 :firstDigit];
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==1){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
                hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftHomeImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme1)];
		[UIView commitAnimations];
		
		homeScoreFirstDigitTheme1=firstDigit;
        
        return;
    }
    if (gCurrentViewNum == 104) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme2Home:Theme2RightHomeImageView :secondDigit];
		
		if (firstDigit != 0)
		{
			//[self setupImageTheme1:hiddenLeftHomeImageViewTheme1 :firstDigit];
			[self setupImageTheme2Home:Theme2LeftHomeImageview:firstDigit];
            
		}
		else
		{
			if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==1){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineRed0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==2){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineBlue0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==3){
                // hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineYellow0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumberHome"]==4){
                //hiddenLeftHomeImageViewTheme1.image = [UIImage imageNamed:@"lineWhite0.png"];
                Theme2LeftHomeImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme2)];
		[UIView commitAnimations];
		
		homeScoreFirstDigitTheme2 = firstDigit;
        
        return;
    }
    if (gCurrentViewNum == 105) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
        
        BOOL isDownFlip;
        isDownFlip = HomescoreIndexTheme3 > score ? YES : NO;
        
        if ([self.homeRightFlipView isKindOfClass:[JDFlipImageView class]])
        {
            JDFlipImageView *flipImageView = (JDFlipImageView*)self.homeRightFlipView;
            
            [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigit]] setFlip:isDownFlip];
        }
        
        //		if (firstDigit != 0)
        
        
		if ((secondDigit == 0 && isDownFlip == NO) || (secondDigit == 9 && isDownFlip == YES))
		{
			
            if ([self.homeLeftFlipView isKindOfClass:[JDFlipImageView class]])
            {
                JDFlipImageView *flipImageView = (JDFlipImageView*)self.homeLeftFlipView;
                
                [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigit]] setFlip:isDownFlip];
            }
		}
		else
		{
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpHomeTheme3)];
		[UIView commitAnimations];
		
		homeScoreFirstDigitTheme3 = firstDigit;
        HomescoreIndexTheme3 = score;
        return;
    }
}
- (void)clientGuestScoreIncreased:(NSString *) scoreString
{
    int score = [scoreString integerValue];
    if (self.isServer) {
        return;
    }
    
    if (gCurrentViewNum == 101) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.85];
        if (score > frontGuestLableScore) {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.frontGuestScoreLable cache:YES];
        } else {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.frontGuestScoreLable cache:YES];
        }
        [UIView commitAnimations];
        [frontGuestScoreLable setText:[NSString stringWithFormat:@"%d", score]];
        frontGuestLableScore = score;
        [self playSound];
        return;
    }
    
    if (gCurrentViewNum == 102) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImage:hiddenRightGuestImageView :secondDigit];
		[self setupImage:rightGuestImageView :secondDigit];
		
		
		if (firstDigit!=0)
		{
			[self setupImage:hiddenLeftGuestImageView :firstDigit];
			[self setupImage:leftGuestImageView :firstDigit];
		}
		else
		{
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==1){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dot-0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dot-0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==2){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotBlue0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotBlue0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==3){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotYellow0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotYellow0.png"];
            }
            else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"DigitalThemeNumber"]==4){
                hiddenLeftGuestImageView.image = [UIImage imageNamed:@"dotWhite0.png"];
                leftGuestImageView.image = [UIImage imageNamed:@"dotWhite0.png"];
            }
            
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuest)];
		[UIView commitAnimations];
		
		guestScoreFirstDigit = firstDigit;
        
        return;
    }
    if (gCurrentViewNum == 103) {
        int temp = score;
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme1:hiddenRightGuestImageViewTheme1 :secondDigit];
		[self setupImageTheme1:rightGuestImageViewTheme1 :secondDigit];
		
		if (firstDigit!=0)
		{
			[self setupImageTheme1:hiddenLeftGuestImageViewTheme1 :firstDigit];
			[self setupImageTheme1:leftGuestImageViewTheme1 :firstDigit];
		}
		else
		{
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==1){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==2){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==3){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme1ThemeNumber"]==4){
                hiddenLeftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
                leftGuestImageViewTheme1.image = [UIImage imageNamed:@"digital-0.png"];
            }
            
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme1)];
		[UIView commitAnimations];
		
		guestScoreFirstDigitTheme1 = firstDigit;
        
        return;
    }
    
    if (gCurrentViewNum == 104) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
		[self setupImageTheme2:Theme2RightGuestImageView :secondDigit];
		
		
		if (firstDigit!=0)
		{
			[self setupImageTheme2:Theme2LeftGuestImageview :firstDigit];
		}
		else
		{
            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==1){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==2){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
            else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==3){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }else     if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Theme2ThemeNumber"]==4){
                Theme2LeftGuestImageview.image = [UIImage imageNamed:@"line-0.png"];
            }
		}
		
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme2)];
		[UIView commitAnimations];
		
		guestScoreFirstDigitTheme2 = firstDigit;
        return;
    }
    if (gCurrentViewNum == 105) {
        int temp = score;
		
		int secondDigit = temp % 10;
		temp = temp / 10;
		int firstDigit = temp;
		
        BOOL isDownFlip;
        isDownFlip = GuestScoreIndexTheme3 > score ? YES : NO;
        
        if ([self.guestRightFlipView isKindOfClass:[JDFlipImageView class]])
        {
            JDFlipImageView *flipImageView = (JDFlipImageView*) self.guestRightFlipView;
            
            [flipImageView setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", secondDigit]] setFlip:isDownFlip];
            
        }
		
		if ((secondDigit == 0 && isDownFlip == NO) || (secondDigit == 9 && isDownFlip == YES))
		{
            if ([self.guestLeftFlipView isKindOfClass:[JDFlipImageView class]])
            {
                JDFlipImageView *flipImageView1 = (JDFlipImageView*)self.guestLeftFlipView;
                
                [flipImageView1 setImageAnimated:[UIImage imageNamed:[NSString stringWithFormat: @"sb%d.png", firstDigit]] setFlip:isDownFlip];
            }
		}
		else
		{
        }
		//start animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dimUpGuestTheme3)];
		[UIView commitAnimations];
        
		guestScoreFirstDigitTheme3 = firstDigit;
        
        GuestScoreIndexTheme3 = score;
        return;
    }
    
}

- (void)clientBoardIndexChanged:(NSString *) score
{
    gCurrentViewNum = [score integerValue];
}

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)clientBoardLeftSwiped: (NSString *) scoreboardNumString
{
    int scoreboardNum = [scoreboardNumString intValue];
    if (scoreboardNum == 101)
    {
        //        [self moveScrollViewLeft];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        NSLog(@"the scroll view center is %f", scrollView.center.x);
        
        [self playSound];
        if ( VolleyBallViewBigger == YES) {
            
            VolleyBallCourtChanged = NO;
            
            int XpositionForHome=frontHomeScoreLable.frame.origin.x;
            int XpositionForGuest=frontGuestScoreLable.frame.origin.x;
            
            
            [frontGuestScoreLable setFrame:CGRectMake(XpositionForHome, frontHomeScoreLable.frame.origin.y, frontHomeScoreLable.frame.size.width,frontHomeScoreLable.frame.size.height)];
            
            [frontHomeScoreLable setFrame:CGRectMake(XpositionForGuest, frontGuestScoreLable.frame.origin.y, frontGuestScoreLable.frame.size.width, frontGuestScoreLable.frame.size.height)];
            
            [homeTextField setFrame:CGRectMake(285 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            [guestTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            
        } else {
            
            VolleyBallCourtChanged = NO;
            
            [frontHomeScoreLable setFrame:CGRectMake(464 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 105) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 25) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
            
            [frontGuestScoreLable setFrame:CGRectMake(254 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 105) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 25) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
            
            [homeTextField setFrame:CGRectMake(228 * scoreboardWidthRate, 205 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextField setFrame:CGRectMake(12 * scoreboardWidthRate, 205 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
        }
        
        [UIView commitAnimations];
        
    }
    if (scoreboardNum == 102)
    {
        
        if (DigitalViewBigger == YES) {
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            int height = 160 * scoreboardHeightRate;
            int width = 98 * scoreboardWidthRate;
            int Yposition = 100 * scoreboardHeightRate;
            
            DigitalScoreboardCourtChnage = NO;
            
            [hiddenRightGuestImageView setFrame:CGRectMake(366 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 276 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 613 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(523 * scoreboardWidthRate, Yposition, width, height)];
            
            [guestTextFieldDigital setFrame:GuestBorderDigital.frame];
            [homeTextFieldDigital setFrame:HomeBorderDigital.frame];
            
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            int Yvalue=80 * scoreboardHeightRate;
            int width=76 * scoreboardWidthRate;
            int height=150 * scoreboardWidthRate;
            
            DigitalScoreboardCourtChnage = NO;
            
            [hiddenLeftGuestImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
            [hiddenRightGuestImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
            [leftHomeImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
            [rightHomeImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
            
            
            [homeTextFieldDigital setFrame:HomeBorderDigital.frame];
            [guestTextFieldDigital setFrame:GuestBorderDigital.frame];
            
            [UIView commitAnimations];
        }
    }
    
    if (scoreboardNum == 103)
    {
        if (Theme1Bigger==YES) {
            
            int H = 138 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 132 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme1CourtChange = NO;
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(364 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(33 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [guestTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [GuestBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate,395,686)];
            [HomeBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate, 395,686)];
            
            [UIView commitAnimations];
        } else {
            int H = 113 * scoreboardHeightRate;
            int W = 64 * scoreboardWidthRate;
            int Y = 107 * scoreboardHeightRate;
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme1CourtChange = NO;
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(27 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(90.3 * scoreboardWidthRate, Y, W, H)];
            
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(226 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(289 * scoreboardWidthRate, Y, W, H)];
            
            [guestTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [homeTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];

            [GuestBorderDigitalTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [HomeBorderDigitalTheme1 setFrame:CGRectMake(223 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
            [UIView commitAnimations];
        }
        
    }
    if (scoreboardNum == 104)
    {
        if (Theme2ViewBigger == YES) {
            
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme2CourtChange = NO;
            
            int H=Theme2LeftGuestImageview.frame.size.height;
            int W=Theme2LeftGuestImageview.frame.size.width;
            int Y=Theme2LeftGuestImageview.frame.origin.y;
            
            [Theme2LeftGuestImageview setFrame:CGRectMake(18 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(118 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
            [UIView commitAnimations];
            
        } else {
            int H = 150 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 55 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            Theme2CourtChange = NO;
            
            [Theme2LeftGuestImageview setFrame:CGRectMake(19 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(99 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(199 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(279 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(200 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(46 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [UIView commitAnimations];
        }
        
    }
    if (scoreboardNum == 105)
    {
        if (Theme3ViewBigger == YES) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            if (Theme3CourtChange == NO) {
                Theme3CourtChange = YES;
            
            int H = 210 * scoreboardHeightRate;
            int W = 103 * scoreboardWidthRate;
            int Y = 78 * scoreboardHeightRate;
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            //            [Flip3LeftHomeImageview setFrame:CGRectMake(255, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(124 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(124 * scoreboardWidthRate, Y, W, H)];
            
            
            [guestTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            [homeTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
                
                
            }
            [UIView commitAnimations];
            
        } else {
            int H = 150 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 65 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme3CourtChange = YES;
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(274 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(274 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(108 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(108 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
            [guestTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            
            [UIView commitAnimations];
        }
    }
}

- (void)clientBoardRightSwiped: (NSString *) scoreboardNumString
{
    int scoreboardNum = [scoreboardNumString intValue];
    if (scoreboardNum == 101)
    {
        //        [self moveScrollViewLeft];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        
        NSLog(@"the scroll view center is %f", scrollView.center.x);
        
        [self playSound];
        if ( VolleyBallViewBigger == YES) {
            
            VolleyBallCourtChanged = YES;
            
            int XpositionForHome=frontHomeScoreLable.frame.origin.x;
            int XpositionForGuest=frontGuestScoreLable.frame.origin.x;
            
            
            [frontHomeScoreLable setFrame:CGRectMake(XpositionForGuest, frontHomeScoreLable.frame.origin.y, frontHomeScoreLable.frame.size.width, frontHomeScoreLable.frame.size.height)];
            
            [frontGuestScoreLable setFrame:CGRectMake(XpositionForHome, frontGuestScoreLable.frame.origin.y, frontGuestScoreLable.frame.size.width, frontGuestScoreLable.frame.size.height)];
            
            [guestTextField setFrame:CGRectMake(285 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            [homeTextField setFrame:CGRectMake(20 * scoreboardWidthRate, 248 * scoreboardHeightRate, 170 * scoreboardWidthRate, 32 * scoreboardHeightRate)];
            
        } else {
            
            VolleyBallCourtChanged = YES;
            
            [frontGuestScoreLable setFrame:CGRectMake(464 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 105) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 25) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
            
            [frontHomeScoreLable setFrame:CGRectMake(254 * scoreboardWidthRate, (GUESTSCORE_LABLE_YPOSITION + 105) * scoreboardHeightRate, (GUESTSCORE_LABLE_WIDTH + 25) * scoreboardWidthRate, (GUESTSCORE_LABLE_HEIGHT + 22) * scoreboardHeightRate)];
            
            [guestTextField setFrame:CGRectMake(228 * scoreboardWidthRate, 205 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [homeTextField setFrame:CGRectMake(12 * scoreboardWidthRate, 205 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
        }
        
        [UIView commitAnimations];
        
    }
    if (scoreboardNum == 102)
    {
        
        if (DigitalViewBigger == YES) {
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            int height = 160 * scoreboardHeightRate;
            int width = 98 * scoreboardWidthRate;
            int Yposition = 100 * scoreboardHeightRate;
            
            DigitalScoreboardCourtChnage = YES;
            
            
            [hiddenRightGuestImageView setFrame:CGRectMake(613 * scoreboardWidthRate, Yposition, width, height)];
            [hiddenLeftGuestImageView setFrame:CGRectMake( 523 * scoreboardWidthRate, Yposition, width, height)];
            
            [rightHomeImageView setFrame:CGRectMake( 366 * scoreboardWidthRate, Yposition, width, height)];
            [leftHomeImageView setFrame:CGRectMake(276 * scoreboardWidthRate, Yposition, width, height)];
            
            [guestTextFieldDigital setFrame:HomeBorderDigital.frame];
            [homeTextFieldDigital setFrame:GuestBorderDigital.frame];

            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            int Yvalue=80 * scoreboardHeightRate;
            int width=76 * scoreboardWidthRate;
            int height=150 * scoreboardWidthRate;
            
            DigitalScoreboardCourtChnage = YES;
            
            [hiddenLeftGuestImageView setFrame:CGRectMake(466.0 * scoreboardWidthRate, Yvalue, width, height)];
            [hiddenRightGuestImageView setFrame:CGRectMake(536 * scoreboardWidthRate, Yvalue, width, height)];
            [leftHomeImageView setFrame:CGRectMake(270 * scoreboardWidthRate, Yvalue, width, height)];
            [rightHomeImageView setFrame:CGRectMake(339.5 * scoreboardWidthRate, Yvalue, width, height)];
            
            
            [guestTextFieldDigital setFrame:HomeBorderDigital.frame];
            [homeTextFieldDigital setFrame:GuestBorderDigital.frame];
            
            
            [UIView commitAnimations];
        }
    }
    
    if (scoreboardNum == 103)
    {
        
        if (Theme1Bigger==YES) {
            
            int H = 138 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 132 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme1CourtChange = YES;
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(33 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(114 * scoreboardWidthRate, Y, W, H)];
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(283 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(364* scoreboardWidthRate, Y, W, H)];
            
            [guestTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            [homeTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [GuestBackViewTheme1 setFrame:CGRectMake(290 * scoreboardWidthRate, 107 * scoreboardHeightRate,195,186)];
            [HomeBackViewTheme1 setFrame:CGRectMake(30 * scoreboardWidthRate, 107 * scoreboardHeightRate, 195,186)];
            
            
            [UIView commitAnimations];
        } else {
            
            int H = 113 * scoreboardHeightRate;
            int W = 64 * scoreboardWidthRate;
            int Y = 107 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme1CourtChange = YES;
            
            [hiddenLeftGuestImageViewTheme1 setFrame:CGRectMake(27 * scoreboardWidthRate, Y, W, H)];
            [hiddenRightGuestImageViewTheme1 setFrame:CGRectMake(90.3 * scoreboardWidthRate, Y, W, H)];
            
            
            [leftHomeImageViewTheme1 setFrame:CGRectMake(226 * scoreboardWidthRate, Y, W, H)];
            [rightHomeImageViewTheme1 setFrame:CGRectMake(289 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme1 setFrame:GuestBorderDigitalTheme1.frame];
            [guestTextFieldTheme1 setFrame:HomeBorderDigitalTheme1.frame];
            
            [GuestBorderDigitalTheme1 setFrame:CGRectMake(24 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [HomeBorderDigitalTheme1 setFrame:CGRectMake(223 * scoreboardWidthRate, 230 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];

            [UIView commitAnimations];
            
        }
        
    }
    if (scoreboardNum == 104)
    {
        if (Theme2ViewBigger == YES) {
            
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme2CourtChange = YES;
            
            int H = Theme2LeftGuestImageview.frame.size.height;
            int W = Theme2LeftGuestImageview.frame.size.width;
            int Y = Theme2LeftGuestImageview.frame.origin.y;
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(19 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(118 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftGuestImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(358 * scoreboardWidthRate, Y, W, H)];
            
            
            [guestTextFieldTheme2 setFrame:CGRectMake(285 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [homeTextFieldTheme2 setFrame:CGRectMake(45 * scoreboardWidthRate, 10 * scoreboardHeightRate, 150 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            
            [UIView commitAnimations];
            
        } else {
            int H = 150 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 55 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme2CourtChange = YES;
            
            
            [Theme2LeftHomeImageview setFrame:CGRectMake(19 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightHomeImageView setFrame:CGRectMake(99 * scoreboardWidthRate, Y, W, H)];
            
            [Theme2LeftGuestImageview setFrame:CGRectMake(199 * scoreboardWidthRate, Y, W, H)];
            [Theme2RightGuestImageView setFrame:CGRectMake(279 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme2 setFrame:CGRectMake(46 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [guestTextFieldTheme2 setFrame:CGRectMake(200 * scoreboardWidthRate, 4 * scoreboardHeightRate, 135 * scoreboardWidthRate, 25 * scoreboardHeightRate)];
            [UIView commitAnimations];
            
        }
        
    }
    if (scoreboardNum == 105)
    {
        if (Theme3ViewBigger == YES) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme3CourtChange = NO;
            
            int H = 210 * scoreboardHeightRate;
            int W = 103 * scoreboardWidthRate;
            int Y = 78 * scoreboardHeightRate;
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(24 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(130 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(258 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(365 * scoreboardWidthRate, Y, W, H)];
            
            [homeTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            [guestTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
            
            
            [UIView commitAnimations];
            
        } else {
            
            int H = 150 * scoreboardHeightRate;
            int W = 82 * scoreboardWidthRate;
            int Y = 65 * scoreboardHeightRate;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            Theme3CourtChange = NO;
            
            [Theme3LeftGuestImageview setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
            [self.guestLeftFlipView setFrame:CGRectMake(35 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightGuestImageView setFrame:CGRectMake(112 * scoreboardWidthRate, Y, W, H)];
            [self.guestRightFlipView setFrame:CGRectMake(112 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3LeftHomeImageview setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
            [self.homeLeftFlipView setFrame:CGRectMake(201 * scoreboardWidthRate, Y, W, H)];
            
            [Theme3RightHomeImageView setFrame:CGRectMake(278 * scoreboardWidthRate, Y, W, H)];
            [self.homeRightFlipView setFrame:CGRectMake(278 * scoreboardWidthRate, Y, W, H)];
            
            
            [homeTextFieldTheme3 setFrame:HomeBorderDigitalTheme3.frame];
            [guestTextFieldTheme3 setFrame:GuestBorderDigitalTheme3.frame];
            
            [UIView commitAnimations];
            
        }
    }
}

- (void) clientTimeSetting:(NSString *) time
{
    int timeNum = [time intValue];
    int timeNum1, timeNum2, timeNum3, timeNum4;
    timeNum1 = timeNum / 1000;
    timeNum2 = (timeNum % 1000) / 100;
    timeNum3 = (timeNum % 100) / 10;
    timeNum4 = timeNum % 10;
    
    [tutorialImageView1 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"green%d.png", timeNum1]]];
    [tutorialImageView2 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"green%d.png", timeNum2]]];
    [tutorialImageView3 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"green%d.png", timeNum3]]];
    [tutorialImageView4 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"green%d.png", timeNum4]]];
    
}

- (void) clientTime2Setting:(NSString *) time
{
    int timeNum = [time intValue];
    int timeNum1, timeNum2, timeNum3, timeNum4;
    timeNum1 = timeNum / 1000;
    timeNum2 = (timeNum % 1000) / 100;
    timeNum3 = (timeNum % 100) / 10;
    timeNum4 = timeNum % 10;
    
    [tutorialImageViewTheme11 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"orange%d.png", timeNum1]]];
    [tutorialImageViewTheme12 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"orange%d.png", timeNum2]]];
    [tutorialImageViewTheme13 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"orange%d.png", timeNum3]]];
    [tutorialImageViewTheme14 setImage:[UIImage imageNamed: [NSString stringWithFormat: @"orange%d.png", timeNum4]]];
}

- (void) clientBoardPeriod:(NSString *) period
{
    if (gCurrentViewNum == 101) {
        [preiodLabel setText: period];
    }
    
    if (gCurrentViewNum == 103) {
        int periodNum = [period intValue];
        PeriodButtonNumber = periodNum;
        if (PeriodButtonNumber==1) {
            [PeriodButton3 setHidden:YES];
            [PeriodButton2 setHidden:YES];
            [PeriodButton1 setHidden:NO];
            
        }
        else if(PeriodButtonNumber==2){
            [PeriodButton3 setHidden:YES];
            [PeriodButton2 setHidden:NO];
            [PeriodButton1 setHidden:NO];
        }
        else if(PeriodButtonNumber==3){
            [PeriodButton3 setHidden:NO];
            [PeriodButton2 setHidden:NO];
            [PeriodButton1 setHidden:NO];
        }
        else if(PeriodButtonNumber==4){
            [PeriodButton3 setHidden:YES];
            [PeriodButton2 setHidden:YES];
            [PeriodButton1 setHidden:YES];
        }
        if(PeriodButtonNumber<4){
            PeriodButtonNumber++;
        }
        else{
            PeriodButtonNumber=1;
            
        }
        
    }
}

- (void) clientBoardLeftLabelName:(NSString *) name
{
    if (gCurrentViewNum == 101) {
        guestTextField.text = name;
    }
    if (gCurrentViewNum == 102) {
        guestTextFieldDigital.text = name;
    }
    if (gCurrentViewNum == 103) {
        guestTextFieldTheme1.text = name;
    }
    if (gCurrentViewNum == 104) {
        guestTextFieldTheme2.text = name;
    }
    if (gCurrentViewNum == 105) {
        guestTextFieldTheme3.text = name;
    }
}

- (void) clientBoardRightLabelName:(NSString *) name
{
    if (gCurrentViewNum == 101) {
        homeTextField.text = name;
    }
    if (gCurrentViewNum == 102) {
        homeTextFieldDigital.text = name;
    }
    if (gCurrentViewNum == 103) {
        homeTextFieldTheme1.text = name;
    }
    if (gCurrentViewNum == 104) {
        homeTextFieldTheme2.text = name;
    }
    if (gCurrentViewNum == 105) {
        homeTextFieldTheme3.text = name;
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 903) {
        if (buttonIndex == 0)
        {
            // Stop any pending performSelector:withObject:afterDelay: messages.
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            
            [self.game quitGameWithReason:QuitReasonUserQuit];
            isBluetooth = NO;
        }
    }
}

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 901) {
        if (buttonIndex == 0) {
            NSLog(@"score reset");
            [self resetScore];
        } else
        {
            NSLog(@"No");
        }
    }
}
- (void)HomeColorViewController:(Theme3SettingsViewController_iPhone *)colorPicker didSelectColor:(UIColor *)color {
    
    NSLog(@"Color: %d", color);
    
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.defaultsKey];
    
    
    if ([colorPicker.defaultsKey isEqualToString:@"SwatchColor"]) {
        
        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==1){
            frontHomeScoreLable.backgroundColor = color;
        }
        else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==2){
//            homeBackImageView.backgroundColor = color;
            leftHomeImageView.backgroundColor = color;
            rightHomeImageView.backgroundColor = color;

        }
        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==3){
//            HomeBackViewTheme1.backgroundColor = color;
            leftHomeImageViewTheme1.backgroundColor = color;
            rightHomeImageViewTheme1.backgroundColor = color;

        }
        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==4){
//            HomeBackViewTheme2.backgroundColor = color;
            Theme2LeftHomeImageview.backgroundColor = color;
            Theme2RightHomeImageView.backgroundColor = color;
        }
        else
        {
            HomeBackLeftViewTheme3.backgroundColor = color;
            HomeBackRightViewTheme3.backgroundColor = color;
        }
        //        colorSwatch.backgroundColor = color;
    }
    
#else
    // No storage & check, just assign back the color
    HomeBackLeftViewTheme3.backgroundColor = color;
    HomeBackRightViewTheme3.backgroundColor = color;
    
#endif
    
}
//- (void)GuestColorViewController:(Theme3SettingsViewController_iPhone *)colorPicker didSelectColor:(UIColor *)color {
//    NSLog(@"Color: %d", color);
//
//#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
//    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
//    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.guestKey];
//
//    if ([colorPicker.guestKey isEqualToString:@"GuestColor"]) {
//
//        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==1){
//            frontGuestScoreLable.backgroundColor = color;
//        }
//        else  if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==2){
//            guestBackImageView.backgroundColor = color;
//        }
//        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==3){
//            GuestBackViewTheme1.backgroundColor = color;
//        }
//        else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scorebaordnumber"]==4){
//            GuestBackViewTheme2.backgroundColor = color;
//        }
//        else
//        {
//            GuestBackLeftViewTheme3.backgroundColor = color;
//            GuestBackRightViewTheme3.backgroundColor = color;
//        }
//    }
//#else
//    // No storage & check, just assign back the color
//    colorSwatch.backgroundColor = color;
//#endif

//}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"carouselDidEndScrollingAnimation");
    isAvaiableThemeTap = YES;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    NSLog(@"carouselWillBeginDragging");
    isAvaiableThemeTap = NO;
}


@end
