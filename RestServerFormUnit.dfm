object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SRV.mORMot REST HTTP test'
  ClientHeight = 461
  ClientWidth = 1174
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1174
    461)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelPortCap: TLabel
    Left = 8
    Top = 14
    Width = 24
    Height = 13
    Caption = 'Port:'
  end
  object LabelAuthenticationMode: TLabel
    Left = 112
    Top = 14
    Width = 103
    Height = 13
    Caption = 'Authentication mode:'
  end
  object EditPort: TEdit
    Left = 38
    Top = 11
    Width = 60
    Height = 21
    TabOrder = 0
    Text = '777'
  end
  object ButtonStartStop: TButton
    Left = 1061
    Top = 14
    Width = 105
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Start server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonStartStopClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 53
    Width = 1158
    Height = 372
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ButtonCLS: TButton
    Left = 10
    Top = 431
    Width = 38
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'CLS'
    TabOrder = 3
    OnClick = ButtonCLSClick
  end
  object CheckBoxAutoScroll: TCheckBox
    Left = 57
    Top = 433
    Width = 69
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'auto scroll'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object ComboBoxAuthMode: TComboBox
    Left = 221
    Top = 11
    Width = 116
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 5
    Text = 'No authentication'
    OnChange = ComboBoxAuthModeChange
    Items.Strings = (
      'No authentication'
      'URI'
      'SignedURI'
      'Default'
      'None'
      'HttpBasic'
      'SSPI')
  end
  object ButtonShowAuthInfo: TButton
    Left = 343
    Top = 12
    Width = 42
    Height = 19
    Caption = 'Info'
    TabOrder = 6
    OnClick = ButtonShowAuthInfoClick
  end
  object CheckBoxDisableLog: TCheckBox
    Left = 133
    Top = 433
    Width = 203
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'disable log (for max performance test)'
    TabOrder = 7
    OnClick = CheckBoxDisableLogClick
  end
  object CheckBoxUseHTTPsys: TCheckBox
    Left = 920
    Top = 14
    Width = 135
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'Use HTTP.SYS'#13#10'Require run as admin'
    TabOrder = 8
    WordWrap = True
    OnClick = CheckBoxDisableLogClick
  end
  object TimerRefreshLogMemo: TTimer
    OnTimer = TimerRefreshLogMemoTimer
    Left = 56
    Top = 64
  end
end
