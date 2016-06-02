object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'CL.mORMot REST HTTP test'
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
  object LabelAuthenticationMode: TLabel
    Left = 250
    Top = 11
    Width = 103
    Height = 13
    Caption = 'Authentication mode:'
  end
  object EditServerAdress: TEdit
    Left = 8
    Top = 8
    Width = 113
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
    TextHint = 'Server adress (IP or HostName)'
  end
  object EditServerPort: TEdit
    Left = 127
    Top = 8
    Width = 113
    Height = 21
    TabOrder = 1
    Text = '777'
    TextHint = 'Port'
  end
  object ButtonStartStop: TButton
    Left = 1061
    Top = 14
    Width = 105
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Start client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = ButtonStartStopClick
  end
  object GroupBoxIRestMethods: TGroupBox
    Left = 8
    Top = 35
    Width = 577
    Height = 49
    Caption = 'IRestMethods (InstanceImplementation = sicSingle)'
    TabOrder = 3
    object ButtonMethHelloWorld: TButton
      Left = 8
      Top = 16
      Width = 81
      Height = 23
      Caption = 'HelloWorld'
      TabOrder = 0
      OnClick = ButtonMethHelloWorldClick
    end
    object ButtonMethSum: TButton
      Left = 95
      Top = 16
      Width = 50
      Height = 23
      Caption = 'Sum'
      TabOrder = 1
      OnClick = ButtonMethSumClick
    end
    object ButtonGetCustomRecord: TButton
      Left = 151
      Top = 16
      Width = 137
      Height = 23
      Caption = 'GetCustomRecord'
      TabOrder = 2
      OnClick = ButtonGetCustomRecordClick
    end
    object ButtonMethSendCustomRecord: TButton
      Left = 294
      Top = 16
      Width = 115
      Height = 23
      Caption = 'SendCustomRecord'
      TabOrder = 3
      OnClick = ButtonMethSendCustomRecordClick
    end
    object ButtonMethSendMultipleCustomRecords: TButton
      Left = 415
      Top = 16
      Width = 154
      Height = 23
      Caption = 'SendMultipleCustomRecords'
      TabOrder = 4
      OnClick = ButtonMethSendMultipleCustomRecordsClick
    end
  end
  object ComboBoxAuthMode: TComboBox
    Left = 359
    Top = 8
    Width = 116
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
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
  object MemoLog: TMemo
    Left = 8
    Top = 90
    Width = 1158
    Height = 335
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object ButtonCLS: TButton
    Left = 10
    Top = 431
    Width = 38
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'CLS'
    TabOrder = 6
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
    TabOrder = 7
  end
  object CheckBoxDisableLog: TCheckBox
    Left = 133
    Top = 433
    Width = 203
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'disable log (for max performance test)'
    TabOrder = 8
    OnClick = CheckBoxDisableLogClick
  end
  object TimerRefreshLogMemo: TTimer
    OnTimer = TimerRefreshLogMemoTimer
    Left = 56
    Top = 104
  end
end
