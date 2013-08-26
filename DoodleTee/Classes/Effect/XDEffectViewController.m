//
//  XDEffectViewController.m
//  DoodleTee
//
//  Created by xieyajie on 13-7-5.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

#import "XDEffectViewController.h"
#import "XDFinishShowViewController.h"
#import "AKSegmentedControl.h"

#import "XDImagePicker.h"
#import "XDDrawPicker.h"
#import "XDTextPicker.h"

#import "XDShareMethods.h"
#import "LocalDefault.h"

#define kTagTopSegmentedControl 0
#define kTagNormalBottomSegmentedControl 1
#define kTagActionBottomSegmentedControl 2

#define kEffectTypeShowViewHeight 45

typedef enum{
    XDEffectTypeNone,
    XDEffectTypeImage,//图像
    XDEffectTypeDraw,//涂鸦
    XDEffectTypeText//文字
}XDEffectType;

@interface XDEffectViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, AKSegmentedControlDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AKSegmentedControl *_topSegmentedControl; //顶部操作栏
    UIView *_bottomView;          //底部操作栏
    
    AKSegmentedControl *_normalSegmentedControl;    //默认情况下底部选项卡
    AKSegmentedControl *_actionSegmentedControl;   //选择某种选项后出现的底部选项卡
    UIButton *_buttonUndo;  //选择某种选项后出现的底部选项卡左侧按钮
    
    UIScrollView *_clothBgView;   ///背景（衣服图片）
    UIScrollView *_effectTypeShowView; //编辑样式展示
    
    UIView *_effectView; //编辑区域
    
    XDEffectType _currentEffectType;
    NSInteger _imageTypeSelectedIndex;
    NSInteger _drawTypeSelectedIndex;
    NSInteger _textTypeSelectedIndex;
    
    UITapGestureRecognizer *_tapGesture;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) XDImagePicker *imagePicker;
@property (nonatomic, strong) XDDrawPicker *drawPicker;
@property (nonatomic, strong) XDTextPicker *textPicker;

@property (nonatomic, strong) UIView *selectedTypeBgView;

@end

@implementation XDEffectViewController

@synthesize imagePickerController = _imagePickerController;

@synthesize imagePicker = _imagePicker;
@synthesize drawPicker = _drawPicker;
@synthesize textPicker = _textPicker;

@synthesize selectedTypeBgView = _selectedTypeBgView;

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
    
    [self configurationAbility];
    
    [self layoutClothBackground];
    [self.view addSubview:_clothBgView];
    
    [self layoutTopSegmentedControl];
    [self.view addSubview:_topSegmentedControl];
    
    [self layoutBottomView];
    [self.view addSubview:_bottomView];
    
    [self layoutEffectTypeShowView];
    [self.view addSubview:_effectTypeShowView];
    
    [self layoutEffectView];
    [_clothBgView addSubview:_effectView];
    
    [_topSegmentedControl setSelectedIndex:0];
    [self imageAction];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
    
    if ([self respondsToSelector:@selector(setActionBottomViewUndoButtonForBack:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setActionBottomViewUndoButtonForBack:) name:kNotificationSetButton object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get

- (UIImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];//图像选取器
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
    }
    return _imagePickerController;
}

- (XDImagePicker *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[XDImagePicker alloc] initWithEffectViewSize:CGSizeMake(_effectView.frame.size.width, _effectView.frame.size.height)];
    }
    
    return _imagePicker;
}

- (XDDrawPicker *)drawPicker
{
    if (_drawPicker == nil) {
        _drawPicker = [[XDDrawPicker alloc] initWithEffectViewSize:CGSizeMake(_effectView.frame.size.width, _effectView.frame.size.height)];
    }
    
    return _drawPicker;
}

- (XDTextPicker *)textPicker
{
    if (_textPicker == nil) {
        _textPicker = [[XDTextPicker alloc] initWithEffectViewSize:CGSizeMake(_effectView.frame.size.width, _effectView.frame.size.height)];
    }
    
    return _textPicker;
}

- (UIView *)selectedTypeBgView
{
    if (_selectedTypeBgView == nil) {
        _selectedTypeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _effectTypeShowView.frame.size.width / 5, kEffectTypeShowViewHeight)];
        _selectedTypeBgView.backgroundColor = [UIColor blueColor];
        _selectedTypeBgView.alpha = 0.8;
    }
    
    return _selectedTypeBgView;
}

#pragma mark - Notification

- (void)keyboardWillShow: (NSNotification *)aNotification
{
    _clothBgView.scrollEnabled = YES;
}

- (void)keyboardWillHide: (NSNotification *)aNotification
{
    [_clothBgView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, _clothBgView.frame.size.height) animated:YES];
    _clothBgView.scrollEnabled = NO;
}

- (void)setActionBottomViewUndoButtonForBack:(NSNotification *)aNotification
{
    BOOL isBack = [[aNotification object] boolValue];
    if (isBack) {
        [_buttonUndo setTitle:@"返回" forState:UIControlStateNormal];
    }
    else{
        [_buttonUndo setTitle:@"重来" forState:UIControlStateNormal];
    }
}

#pragma mark - UIGestureRecognizer action

//tap
- (void)tapEffectTypeShowView: (UITapGestureRecognizer *)sender
{
    NSInteger index = 0;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //判断点击的是那个选项
        CGPoint location = [sender locationInView:_effectTypeShowView];
        index = location.x / (_effectTypeShowView.frame.size.width / 5);
        
        //若是未选中状态
        if (_currentEffectType == XDEffectTypeImage && _imageTypeSelectedIndex != index) {
            _imageTypeSelectedIndex = index;
            [self imageEffectWithType:index];
        }
        else if (_currentEffectType == XDEffectTypeDraw && _drawTypeSelectedIndex != index)
        {
            _drawTypeSelectedIndex = index;
            [self drawEffectWithType:index];
        }
        else if(_currentEffectType == XDEffectTypeText && _textTypeSelectedIndex != index)
        {
            _textTypeSelectedIndex = index;
            [self textEffectWithType:index];
        }
    }
}

#pragma mark - UIIMagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [XDShareMethods dismissViewController:self animated:YES completion:^{
            if (_imageTypeSelectedIndex == -1) {
                _imageTypeSelectedIndex = 0;
            }
            self.imagePicker.image = image;
            [self imageEffectWithType:_imageTypeSelectedIndex];
            [self hideNormalBottomSegmentedControl];
        }];//关闭模态视图控制器
        
//        [self dismissViewControllerAnimated:YES completion:^{
//            if (_imageTypeSelectedIndex == -1) {
//                _imageTypeSelectedIndex = 0;
//            }
//            self.imagePicker.image = image;
//            [self imageEffectWithType:_imageTypeSelectedIndex];
//            [self hideNormalBottomSegmentedControl];
//        }];
    }
}

#pragma mark - AKSegmentedControl Delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl.tag == kTagTopSegmentedControl) {
        switch (index) {
            case 0:
                if (_imageTypeSelectedIndex == -1) {
                    [self hideActionBottomSegmentedControl];
                }
                [self imageAction];
                break;
            case 1:
                [self hideNormalBottomSegmentedControl];
                [self drawAction];
                break;
            case 2:
                [self hideNormalBottomSegmentedControl];
                [self textAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagNormalBottomSegmentedControl)
    {
        switch (index) {
            case 0:
                [self backAction];
                break;
            case 1:
                [self photoAlbumAction];
                break;
            case 2:
                [self cameraAction];
                break;
                
            default:
                break;
        }
    }
    else if (segmentedControl.tag == kTagActionBottomSegmentedControl)
    {
        switch (index) {
            case 0:
                [self clearAction];
                break;
            case 1:
                [self doneAction];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark - initialize data

//设置属性值
- (void)configurationAbility
{
    _imageTypeSelectedIndex = -1;
    _drawTypeSelectedIndex = 0;
    _textTypeSelectedIndex = 0;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
}


#pragma mark - layout subviews

- (void)layoutTopSegmentedControl
{
    _topSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 42.5)];
    _topSegmentedControl.tag = kTagTopSegmentedControl;
    [_topSegmentedControl setDelegate:self];
    [self initTopSegmentedView];
}

- (void)initTopSegmentedView
{
    CGFloat width = _topSegmentedControl.frame.size.width / 3;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"functionBarBg.png"];
    [_topSegmentedControl setBackgroundImage:backgroundImage];
    [_topSegmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [_topSegmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_topSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage imageNamed:@"effect_segmented_pressed_left.png"];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage imageNamed:@"effect_segmented_pressed_center.png"];
    UIImage *buttonBackgroundImagePressedRight = [UIImage imageNamed:@"effect_segmented_pressed_right.png"];
    
    //图像处理
    UIButton *buttonProcess = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _topSegmentedControl.frame.size.height)];
    buttonProcess.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonProcess.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonProcess setTitle:@"图像" forState:UIControlStateNormal];
    [buttonProcess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonProcess.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonProcess setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonProcess setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    
    UIImage *buttonProcessImageNormal = [UIImage imageNamed:@"effect_photograph_icon.png"];
    [buttonProcess setImage:buttonProcessImageNormal forState:UIControlStateNormal];
    [buttonProcess setImage:buttonProcessImageNormal forState:UIControlStateSelected];
    
    //自定义绘图
    UIButton *buttonDraw = [[UIButton alloc] initWithFrame:CGRectMake(buttonProcess.frame.origin.x + buttonProcess.frame.size.width, 0, width, _topSegmentedControl.frame.size.height)];
    buttonDraw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonDraw.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonDraw setTitle:@"涂鸦" forState:UIControlStateNormal];
    [buttonDraw setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDraw.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDraw setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonDraw setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    
    UIImage *buttonDrawImageNormal = [UIImage imageNamed:@"effect_draw_icon.png"];
    [buttonDraw setImage:buttonDrawImageNormal forState:UIControlStateNormal];
    [buttonDraw setImage:buttonDrawImageNormal forState:UIControlStateSelected];
    
    //添加文字
    UIButton *buttonTitle = [[UIButton alloc] initWithFrame:CGRectMake(buttonDraw.frame.origin.x + buttonDraw.frame.size.width, 0, width, _topSegmentedControl.frame.size.height)];
    buttonTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonTitle setTitle:@"文字" forState:UIControlStateNormal];
    [buttonTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTitle.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonTitle setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    [buttonTitle setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    
    UIImage *buttonTitleImageNormal = [UIImage imageNamed:@"effect_text_icon.png"];
    [buttonTitle setImage:buttonTitleImageNormal forState:UIControlStateNormal];
    [buttonTitle setImage:buttonTitleImageNormal forState:UIControlStateSelected];
    
    [_topSegmentedControl setButtonsArray:@[buttonProcess, buttonDraw, buttonTitle]];
}

- (void)layoutBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.5, self.view.frame.size.width, 62.5)];
    _bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _bottomView.layer.shadowOpacity = 1.0;
    _bottomView.layer.shadowRadius = 10.0;
    _bottomView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBarBg.png"]];
    bottomImgView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height);
    [_bottomView addSubview:bottomImgView];
    
    [self initBottomSegmentedControl];
}

- (void)initBottomSegmentedControl
{
    [self initNormalBottomSegmentedControl];
    [self initActionBottomSegmentedControl];
}

- (void)initNormalBottomSegmentedControl
{
    _normalSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    _normalSegmentedControl.tag = kTagNormalBottomSegmentedControl;
    [_normalSegmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [_normalSegmentedControl setDelegate:self];
    _normalSegmentedControl.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_normalSegmentedControl];
    
    CGFloat width = _normalSegmentedControl.frame.size.width / 3;
    [_normalSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    //返回
    UIButton *buttonback = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonback.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonback.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonback setTitle:@"返回" forState:UIControlStateNormal];
    [buttonback setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonback.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonback setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonBackNormal = [UIImage imageNamed:@"effect_back_icon.png"];
    [buttonback setImage:buttonBackNormal forState:UIControlStateNormal];
    [buttonback setImage:[UIImage imageNamed:@"effect_backSelected_icon.png"] forState:UIControlStateHighlighted];
    
    // 相册
    UIButton *buttonImage = [[UIButton alloc] initWithFrame:CGRectMake(buttonback.frame.origin.x + buttonback.frame.size.width, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonImage.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonImage setTitle:@"相册" forState:UIControlStateNormal];
    [buttonImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonImage.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonImage setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"effect_image_icon.png"];
    [buttonImage setImage:buttonImageNormal forState:UIControlStateNormal];
    
    //相机
    UIButton *buttonCamera = [[UIButton alloc] initWithFrame:CGRectMake(buttonImage.frame.origin.x + buttonImage.frame.size.width, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonCamera.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 13);
    [buttonCamera setTitle:@"相机" forState:UIControlStateNormal];
    [buttonCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCamera.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonCamera setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    
    UIImage *buttonCameraImageNormal = [UIImage imageNamed:@"effect_camera_icon.png"];
    [buttonCamera setImage:buttonCameraImageNormal forState:UIControlStateNormal];
    
    [_normalSegmentedControl setButtonsArray:@[buttonback, buttonImage, buttonCamera]];
}

- (void)initActionBottomSegmentedControl
{
    _actionSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, _bottomView.frame.size.width - 14 * 2, 35)];
    _actionSegmentedControl.tag = kTagActionBottomSegmentedControl;
    [_actionSegmentedControl setSegmentedControlMode: AKSegmentedControlModeButton];
    [_actionSegmentedControl setDelegate:self];
    _actionSegmentedControl.backgroundColor = [UIColor clearColor];
    _actionSegmentedControl.hidden = YES;
    [_bottomView addSubview:_actionSegmentedControl];
    
    CGFloat width = _actionSegmentedControl.frame.size.width / 2;
    [_actionSegmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented_separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"effect_segmented_pressed_left.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"effect_segmented_pressed_right.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
    
    // 重来/返回
    _buttonUndo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, _normalSegmentedControl.frame.size.height)];
    _buttonUndo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_buttonUndo setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonUndo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonUndo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [_buttonUndo setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    
    //提交订单
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(_buttonUndo.frame.origin.x + _buttonUndo.frame.size.width, 0, width, _normalSegmentedControl.frame.size.height)];
    buttonDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonDone setTitle:@"完成" forState:UIControlStateNormal];
    [buttonDone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDone setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    
    [_actionSegmentedControl setButtonsArray:@[_buttonUndo, buttonDone]];
}

- (void)layoutClothBackground
{
    _clothBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _bottomView.frame.size.height)];
    _clothBgView.bounces = NO;
    _clothBgView.showsVerticalScrollIndicator = NO;
    _clothBgView.contentSize = CGSizeMake(_clothBgView.frame.size.width, _clothBgView.frame.size.height * 1.5);
    _clothBgView.scrollEnabled = NO;
    
    UIImageView *cloth = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, _clothBgView.frame.size.width * 1.5, _clothBgView.frame.size.height * 1.5)];
    cloth.center = _clothBgView.center;
    cloth.contentMode = UIViewContentModeScaleAspectFill;
    cloth.image = [UIImage imageNamed:@"clothe_default.png"];
    [_clothBgView addSubview:cloth];
}

- (void)layoutEffectTypeShowView
{
    _effectTypeShowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topSegmentedControl.frame.origin.y + _topSegmentedControl.frame.size.height + 5, self.view.frame.size.width, kEffectTypeShowViewHeight)];
    _effectTypeShowView.backgroundColor = [UIColor blackColor];
    _effectTypeShowView.alpha = 0.7;
    _effectTypeShowView.scrollEnabled = NO;
    
    //添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEffectTypeShowView:)];
    [_effectTypeShowView addGestureRecognizer:tap];
}

- (void)layoutEffectView
{
    CGFloat scale = kEffectTempWidth / kEffectTempHeight;
    CGFloat height = self.view.frame.size.height - 120 - _bottomView.frame.size.height - 20;
    CGFloat width = height * scale;
    _effectView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width) / 2, 120, width, height)];
    _effectView.backgroundColor = [UIColor clearColor];
    _effectView.layer.borderWidth = 1.0f;
    _effectView.layer.borderColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"effect_border.png"]] CGColor];
}

- (void)layoutBackgroundViewForSelectedType:(NSInteger)index
{
    CGFloat width = _effectTypeShowView.frame.size.width / 5;
    [UIView animateWithDuration:.3f animations:^{
        self.selectedTypeBgView.frame = CGRectMake(index * width, 0, width, kEffectTypeShowViewHeight);
        [_effectTypeShowView addSubview:self.selectedTypeBgView];
        [_effectTypeShowView sendSubviewToBack:self.selectedTypeBgView];
    }];
}

#pragma mark - tap

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self.textPicker.effectView resignFirstResponder];
}

#pragma mark - top segmentedControl button

//图像
- (void)imageAction
{
    [self changeEffectViewFromType:_currentEffectType toType:XDEffectTypeImage];
    _currentEffectType = XDEffectTypeImage;
    
    for (UIView *view in _effectTypeShowView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _effectTypeShowView.frame.size.width / 5;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"effect", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, kEffectTypeShowViewHeight);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_effectTypeShowView addSubview:imgView];
    }
    
    if (_imageTypeSelectedIndex > -1) {
        [self layoutBackgroundViewForSelectedType:_imageTypeSelectedIndex];
    }
}

//涂鸦
- (void)drawAction
{
    [self changeEffectViewFromType:_currentEffectType toType:XDEffectTypeDraw];
    _currentEffectType = XDEffectTypeDraw;
    
    for (UIView *view in _effectTypeShowView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _effectTypeShowView.frame.size.width / 5;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"stroke", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, kEffectTypeShowViewHeight);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_effectTypeShowView addSubview:imgView];
    }
    
    if (_drawTypeSelectedIndex > -1) {
        [self.drawPicker drawWithType:_drawTypeSelectedIndex];
        [self layoutBackgroundViewForSelectedType:_drawTypeSelectedIndex];
    }
}

//文字
- (void)textAction
{
    [self changeEffectViewFromType:_currentEffectType toType:XDEffectTypeText];
    _currentEffectType = XDEffectTypeText;
    
    for (UIView *view in _effectTypeShowView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = _effectTypeShowView.frame.size.width / 5;
    for(int i = 0; i < 5; i++)
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"%@_%i.png", @"font", i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(i * width, 0, width, kEffectTypeShowViewHeight);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_effectTypeShowView addSubview:imgView];
    }
    
    if (_textTypeSelectedIndex > -1) {
        [self layoutBackgroundViewForSelectedType:_textTypeSelectedIndex];
    }
}

#pragma mark - bottom normal segmentControl button

//返回
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//相册
- (void)photoAlbumAction
{
    self.imagePicker.isStatic = YES;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
    self.imagePickerController.allowsEditing = NO;//禁止对图片进行编辑
    [XDShareMethods presentViewController:self.imagePickerController animated:YES formViewController:self.navigationController completion:nil];//打开模态视图控制器选择图像
//    [self.navigationController presentViewController:self.imagePickerController animated:YES completion:nil];
}

//相机
- (void)cameraAction
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.isStatic = NO;
        [self hideNormalBottomSegmentedControl];
        
        if (_imageTypeSelectedIndex == -1) {
            _imageTypeSelectedIndex = 0;
        }
        [self.imagePicker startCamera];
        [self imageEffectWithType:_imageTypeSelectedIndex];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - bottom action segmentControl button

//重来
- (void)clearAction
{
    if ([_buttonUndo.titleLabel.text isEqualToString:@"返回"]) {
        [self backAction];
        return;
    }
    
    switch (_currentEffectType) {
        case XDEffectTypeImage:
            _imageTypeSelectedIndex = -1;
            [self.imagePicker clear];
            [self hideActionBottomSegmentedControl];
            break;
        case XDEffectTypeDraw:
            [self.drawPicker clear];
            break;
        case XDEffectTypeText:
            [self.textPicker clear];
            break;
            
        default:
            break;
    }
    
    [_buttonUndo setTitle:@"返回" forState:UIControlStateNormal];
}

//完成
- (void)doneAction
{
    XDFinishShowViewController *finishViewController = [[XDFinishShowViewController alloc] initWithClothImage:[self imageWithEffectView]];
    [self.navigationController pushViewController:finishViewController animated:YES];
}

#pragma mark - change bottom segmentedControl

- (void)hideActionBottomSegmentedControl
{
    _actionSegmentedControl.hidden = YES;
    _normalSegmentedControl.hidden = NO;
}

- (void)hideNormalBottomSegmentedControl
{
    _actionSegmentedControl.hidden = NO;
    _normalSegmentedControl.hidden = YES;
}

#pragma mark - effectType selected

- (void)imageEffectWithType:(XDProcessType)type
{
    [self layoutBackgroundViewForSelectedType:type];
    if (_imageTypeSelectedIndex > -1) {
        [self.imagePicker effectImageToType:type];
    }
}

- (void)drawEffectWithType:(XDDrawType)type
{
    [self layoutBackgroundViewForSelectedType:type];
    if (_drawTypeSelectedIndex > -1) {
        [self.drawPicker drawWithType:type];
    }
}

- (void)textEffectWithType:(XDTextType)type
{
    [self layoutBackgroundViewForSelectedType:type];
    if (_textTypeSelectedIndex > -1) {
        [self.textPicker textWithType:type];
    }
}

#pragma mark - private

- (void)changeEffectViewFromType:(XDEffectType)fromType toType:(XDEffectType)toType
{
    if (fromType == toType) {
        return;
    }
    
    switch (fromType) {
        case XDEffectTypeImage:
            [self.imagePicker.effectView removeFromSuperview];
            break;
        case XDEffectTypeDraw:
            [self.drawPicker.effectView removeFromSuperview];
            break;
        case XDEffectTypeText:
            [self.textPicker.effectView resignFirstResponder];
            [self.textPicker.effectView removeFromSuperview];
            break;
            
        default:
            break;
    }
    
    [self.view removeGestureRecognizer:_tapGesture];
    switch (toType) {
        case XDEffectTypeImage:
            [_effectView addSubview:self.imagePicker.effectView];
            break;
        case XDEffectTypeDraw:
            [_effectView addSubview:self.drawPicker.effectView];
            break;
        case XDEffectTypeText:
        {
            [_effectView addSubview:self.textPicker.effectView];
            [self.view addGestureRecognizer:_tapGesture];
            break;
        }
            
        default:
            break;
    }
}

- (UIImage *)imageWithEffectView
{
    switch (_currentEffectType) {
        case XDEffectTypeImage:
            return self.imagePicker.image;
        case XDEffectTypeDraw:
            return self.drawPicker.effectView.image;
        case XDEffectTypeText:
            return [self.textPicker imageWithContext];
            
        default:
            return nil;
            break;
    }
}

@end
