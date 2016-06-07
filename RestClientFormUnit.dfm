object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'CL.mORMot REST HTTP test'
  ClientHeight = 469
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
    469)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelAuthenticationMode: TLabel
    Left = 37
    Top = 38
    Width = 74
    Height = 13
    Caption = 'Authentication:'
  end
  object LabelProtocol: TLabel
    Left = 68
    Top = 11
    Width = 43
    Height = 13
    Caption = 'Protocol:'
  end
  object LabelAuthNotAvailable: TLabel
    Left = 399
    Top = 38
    Width = 164
    Height = 13
    Caption = 'not available with current Protocol'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    StyleElements = [seClient, seBorder]
  end
  object Label1: TLabel
    Left = 799
    Top = 11
    Width = 80
    Height = 13
    Caption = 'Server and port:'
  end
  object Label2: TLabel
    Left = 780
    Top = 38
    Width = 99
    Height = 13
    Caption = 'Login and password:'
  end
  object EditServerAdress: TEdit
    Left = 885
    Top = 8
    Width = 99
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
    TextHint = 'Server adress (IP or HostName)'
  end
  object EditServerPort: TEdit
    Left = 990
    Top = 8
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '777'
    TextHint = 'Port'
  end
  object ButtonStartStop: TButton
    Left = 1061
    Top = 16
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
    Top = 75
    Width = 577
    Height = 54
    Caption = 'IRestMethods (InstanceImplementation = sicSingle)'
    TabOrder = 3
    object ButtonMethHelloWorld: TButton
      Left = 8
      Top = 19
      Width = 81
      Height = 23
      Caption = 'HelloWorld'
      TabOrder = 0
      OnClick = ButtonMethHelloWorldClick
    end
    object ButtonMethSum: TButton
      Left = 95
      Top = 19
      Width = 50
      Height = 23
      Caption = 'Sum'
      TabOrder = 1
      OnClick = ButtonMethSumClick
    end
    object ButtonGetCustomRecord: TButton
      Left = 151
      Top = 19
      Width = 137
      Height = 23
      Caption = 'GetCustomRecord'
      TabOrder = 2
      OnClick = ButtonGetCustomRecordClick
    end
    object ButtonMethSendCustomRecord: TButton
      Left = 294
      Top = 19
      Width = 115
      Height = 23
      Caption = 'SendCustomRecord'
      TabOrder = 3
      OnClick = ButtonMethSendCustomRecordClick
    end
    object ButtonMethSendMultipleCustomRecords: TButton
      Left = 415
      Top = 19
      Width = 154
      Height = 23
      Caption = 'SendMultipleCustomRecords'
      TabOrder = 4
      OnClick = ButtonMethSendMultipleCustomRecordsClick
    end
  end
  object ComboBoxAuthentication: TComboBox
    Left = 117
    Top = 35
    Width = 276
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'No authentication'
    OnChange = ComboBoxAuthenticationChange
    Items.Strings = (
      'No authentication'
      '// URI'
      '// SignedURI'
      'Default'
      '// None'
      '// HttpBasic'
      '// SSPI')
  end
  object MemoLog: TMemo
    Left = 8
    Top = 135
    Width = 1158
    Height = 298
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
    Top = 439
    Width = 38
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'CLS'
    TabOrder = 6
    OnClick = ButtonCLSClick
  end
  object CheckBoxAutoScroll: TCheckBox
    Left = 57
    Top = 441
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
    Top = 441
    Width = 203
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'disable log (for max performance test)'
    TabOrder = 8
    OnClick = CheckBoxDisableLogClick
  end
  object ComboBoxProtocol: TComboBox
    Left = 117
    Top = 8
    Width = 276
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 9
    Text = 'HTTP ( socket )'
    OnChange = ComboBoxProtocolChange
    Items.Strings = (
      'HTTP ( socket )'
      'HTTP ( fast http.sys )'
      'WebSocket ( bidirectional, JSON )'
      'WebSocket ( bidirectional, binary )'
      'WebSocket ( bidirectional, binary + AES-CFB 256)'
      '// Named pipe')
  end
  object EditUserLogin: TEdit
    Left = 885
    Top = 35
    Width = 99
    Height = 21
    TabOrder = 10
    Text = 'User'
    TextHint = 'Login'
  end
  object EditUserPassword: TEdit
    Left = 990
    Top = 35
    Width = 65
    Height = 21
    TabOrder = 11
    Text = 'synopse'
    TextHint = 'Password'
  end
  object TimerRefreshLogMemo: TTimer
    OnTimer = TimerRefreshLogMemoTimer
    Left = 56
    Top = 144
  end
end
