//
//  TextSearchViewController.m
//  Text Search
//
//  Created by Wu Peter on 2016/3/2.
//  Copyright © 2016年 Wu Peter. All rights reserved.
//

#import "TextSearchViewController.h"
#import "DataObject.h"

@interface TextSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton              *backButton;
@property (nonatomic, strong) UIButton              *categoryButton;
@property (nonatomic, strong) UITableView           *questionTableView;
@property (nonatomic, strong) UILabel               *questionLabel;
@property (nonatomic, strong) NSLayoutConstraint    *textViewBottomConstraint;
@property (nonatomic, strong) UIButton              *addButton;
@property (nonatomic, strong) NSArray               *searchResult;
@property (nonatomic, strong) NSMutableArray        *dataObjectArray;
@property (nonatomic, strong) NSString              *keyWord;
@property (nonatomic, strong) UISearchBar           *searchBar;
@end

@implementation TextSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getJsonData];
    [self initLayout];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
}


- (void) getJsonData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"all_posts" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    _dataObjectArray = @[].mutableCopy;
    for (NSDictionary *w in jsonDict) {
        DataObject *object = [[DataObject alloc] initWithDataObject:w];
        [_dataObjectArray addObject:object];
    }
}


#pragma mark - Init layout
- (void) initLayout {
    [self setNavigationBarStyle];
    [self initCategoryButton];
    [self setSearchBar];
    [self initQuestionLabel];
    [self initQuestionTableView];
    [self initAddButton];
    [self initNotificationObservers];
}

- (void)initQuestionTableView {
    if (!_questionTableView) {
        _questionTableView = [[UITableView alloc] init];
        [_questionTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _questionTableView.delegate        = self;
        _questionTableView.dataSource      = self;
        _questionTableView.backgroundColor = [UIColor clearColor];
        _questionTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _questionTableView.clipsToBounds   = YES;
        _questionTableView.layoutMargins   = UIEdgeInsetsZero;
        [self.view addSubview:_questionTableView];
        
        NSMutableArray *questionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:0.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionTableView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:0.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionTableView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionTableView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_questionLabel
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:questionTableViewConstraint];
        [self.view layoutIfNeeded];
    }
    [_questionTableView reloadData];
}


- (void)initQuestionLabel {
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        [_questionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _questionLabel.backgroundColor = [UIColor lightGrayColor];
        _questionLabel.font = [UIFont systemFontOfSize:22.0f];
        [self.view addSubview:_questionLabel];
        
        NSMutableArray *questionTextViewConstraint = [[NSMutableArray alloc] init];
        
        [questionTextViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionLabel
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0f constant:0.0f]];
        [questionTextViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:60.0f]];
        [questionTextViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_questionLabel
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:0.0f]];
        _textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_questionLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f constant:0.0f];
       
        
        [self.view addConstraints:questionTextViewConstraint];
        [self.view addConstraint:_textViewBottomConstraint];
    }
    _questionLabel.text = @" Don't see your question?";
}

- (void)initAddButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_addButton setBackgroundColor:[UIColor blueColor]];
        [_addButton setTitle:@"Add it" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.layer.cornerRadius = 5.0f;
        [_addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
        
        NSMutableArray *questionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:35.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_questionLabel
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0f constant:0.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_questionLabel
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:-10.0f]];
        [questionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:70.0f]];
        
        [self.view addConstraints:questionTableViewConstraint];
        [self.view layoutIfNeeded];
    }
}


- (void) setNavigationBarStyle {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.hidesBackButton = YES;
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor grayColor]];
    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSShadowAttributeName: shadow};
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}


- (void) initBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor = [UIColor clearColor];
    _backButton.frame = CGRectMake(0, 0, 25, 25);
    
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_arrow_back"]];
    
    [_backButton setImage:iconImage forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
}

- (void) initCategoryButton {
    _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _categoryButton.backgroundColor = [UIColor clearColor];
    _categoryButton.frame = CGRectMake(0, 0, 25, 25);
    
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_category"]];
    
    [_categoryButton setImage:iconImage forState:UIControlStateNormal];
    [_categoryButton addTarget:self action:@selector(categoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_categoryButton];
    self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
}

- (void) setSearchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 25.0)];
        _searchBar.placeholder = @"Ask";
        _searchBar.delegate = self;
        [_searchBar resignFirstResponder];
        self.navigationItem.titleView = _searchBar;
    }
}

#pragma mark - Button pressed
- (void) backButtonPressed:(id) sender {
    _searchBar.text = @"";
    [_backButton removeFromSuperview];
    _backButton = nil;
    [self initCategoryButton];
    [_searchBar resignFirstResponder];
    _searchResult = [NSArray new];
    _keyWord = @"";
    [_questionTableView reloadData];
}

- (void) categoryButtonPressed:(id) sender {
    NSLog(@"categoryButtonPressed");
}

- (void)addButtonClicked:(id)sender {
    NSLog(@"Add it");
}

#pragma mark - UISearchBar delegate
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _keyWord = searchText;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content CONTAINS[cd] %@",_keyWord];
    _searchResult  = [_dataObjectArray filteredArrayUsingPredicate:predicate];
    [_questionTableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_categoryButton removeFromSuperview];
    _categoryButton = nil;
    [self initBackButton];
}

#pragma mark - Highlight string
- (NSMutableAttributedString *) highlightString:(NSString *)keyword string:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSString *pattern = [NSString stringWithFormat:@"(%@)", keyword];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range = NSMakeRange(0, string.length);
    
    [regex enumerateMatchesInString:string
                            options:kNilOptions
                              range:range
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop)
     {
         NSRange subStringRange = [result rangeAtIndex:1];
         [attributedString addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]
                                  range:subStringRange];
     }];
    
    return attributedString;
}


#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _searchResult.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(self.view.bounds.size.width-20, MAXFLOAT);
    DataObject *searchObject = _searchResult[indexPath.row];
    CGSize labelSize = [searchObject.content sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height + 20;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DataObject *searchObject = _searchResult[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.attributedText = [self highlightString:_keyWord string:searchObject.content];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataObject *searchObject = _searchResult[indexPath.row];
    NSLog(@"%@", searchObject.content);
    NSLog(@"%@", searchObject.title);
    NSLog(@"%lu", searchObject.tractionIndex);
    NSLog(@"%lu", searchObject.wannaknowCount);
    NSLog(@"%@", searchObject.created);
    NSLog(@"%@", searchObject.createdAt);
    NSLog(@"%@", searchObject.updateAt);
    NSLog(@"%lu", searchObject.viewCount);
    NSLog(@"%lu", searchObject.answerCount);
    NSLog(@"%@", searchObject.university);
    NSLog(@"%@", searchObject.objectId);
    NSLog(@"%d", searchObject.anonymous);
    NSLog(@"%@", searchObject.author);
    NSLog(@"%@", searchObject.ACL);
    NSLog(@"%@", searchObject._id);
}



- (void) initNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue* keyboardEndFrameValue = keyboardInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    NSNumber* animationDurationNumber = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber* animationCurveNumber = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         [self.view removeConstraint:_textViewBottomConstraint];
                         _textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_questionLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f constant:-keyboardEndFrame.size.height];
                         [self.view addConstraint:_textViewBottomConstraint];
                         [self.view layoutIfNeeded];
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSNumber* animationDurationNumber = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber* animationCurveNumber = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         [self.view removeConstraint:_textViewBottomConstraint];
                         _textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_questionLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f constant:0.0f];
                         [self.view addConstraint:_textViewBottomConstraint];
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}


@end
