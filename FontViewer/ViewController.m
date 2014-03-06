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

    NSMutableArray *_saveFontFamilies;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _saveFontFamilies = [NSMutableArray new];
    _text = @"中文字体";

    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self listFonts];
}


- (void) listFonts
{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];

        NSMutableArray *fonts = [NSMutableArray new];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );

            [fonts addObject:[UIFont fontWithName:fontName size:18]];
        }

        [_saveFontFamilies addObject:fonts];
    }

    _fontFamilies = [_saveFontFamilies mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate and datasource

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (IBAction)changeText:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Text" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index: %ld", (long)buttonIndex);

    if (buttonIndex == 1) {
        _text = [alertView textFieldAtIndex:0].text;

        [_tableView reloadData];
    }
}


#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _fontFamilies = [_saveFontFamilies mutableCopy];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _fontFamilies = [_saveFontFamilies mutableCopy];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_fontFamilies removeAllObjects];

    NSArray *arr;
    for (NSMutableArray *family in _saveFontFamilies) {
        arr = [family filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.fontName contains[cd] %@", searchString]];
        if (arr.count > 0) {
            [_fontFamilies addObject:arr];
        }

    }

    return YES;
}



@end
