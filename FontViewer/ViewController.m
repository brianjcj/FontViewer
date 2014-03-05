//
//  ViewController.m
//  FontViewer
//
//  Created by 蒋承军 on 14-3-6.
//  Copyright (c) 2014年 蒋承军. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSString *_text;
    NSMutableArray *_fontFamilies;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _fontFamilies = [NSMutableArray new];
    _text = @"中文字体";

    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self listFonts];
}


- (void) listFonts
{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        //NSLog(@"Family: %@", familyName);
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];

        NSMutableArray *fonts = [NSMutableArray new];
        for( NSString *fontName in fontNames ){
            //NSLog(@"\tFamily: %@", fontName);
            printf( "\tFont: %s \n", [fontName UTF8String] );

            [fonts addObject:[UIFont fontWithName:fontName size:20]];
        }

        [_fontFamilies addObject:fonts];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fontFamilies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fontFamilies[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UIFont *font = _fontFamilies[section][0];
    return font.familyName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    UIFont *font = _fontFamilies[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@,%@", _text, font.fontName, font.familyName];
    cell.textLabel.font = font;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@", font.fontName, font.familyName];

    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = _fontFamilies[indexPath.section][indexPath.row];

    self.navigationItem.title = font.fontName;

}

- (IBAction)changeText:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Text" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1) {
        _text = [alertView textFieldAtIndex:0].text;

        [_tableView reloadData];
    }
}


@end
