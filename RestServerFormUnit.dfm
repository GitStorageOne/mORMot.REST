object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SRV.mORMot REST HTTP test'
  ClientHeight = 667
  ClientWidth = 1083
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
    1083
    667)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelPortCap: TLabel
    Left = 866
    Top = 28
    Width = 24
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Port:'
  end
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
    Left = 448
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
  object EditPort: TEdit
    Left = 896
    Top = 25
    Width = 60
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 0
    Text = '777'
  end
  object ButtonStartStop: TButton
    Left = 968
    Top = 19
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
    Top = 232
    Width = 1065
    Height = 399
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
    Top = 637
    Width = 38
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'CLS'
    TabOrder = 3
    OnClick = ButtonCLSClick
  end
  object CheckBoxAutoScroll: TCheckBox
    Left = 57
    Top = 639
    Width = 69
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'auto scroll'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object ComboBoxAuthentication: TComboBox
    Left = 117
    Top = 35
    Width = 276
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 5
    Text = 'No authentication'
    OnChange = ComboBoxAuthenticationChange
    Items.Strings = (
      'No authentication'
      '// URI'
      '// SignedURI'
      '// Default'
      '// None'
      '// HttpBasic'
      '// SSPI')
  end
  object ButtonShowAuthorizationInfo: TButton
    Left = 399
    Top = 36
    Width = 42
    Height = 19
    Caption = 'Info'
    TabOrder = 6
    OnClick = ButtonShowAuthorizationInfoClick
  end
  object CheckBoxDisableLog: TCheckBox
    Left = 133
    Top = 639
    Width = 203
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'disable log (for max performance test)'
    TabOrder = 7
    OnClick = CheckBoxDisableLogClick
  end
  object ComboBoxProtocol: TComboBox
    Left = 117
    Top = 8
    Width = 276
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 8
    Text = 'HTTP ( socket )'
    OnChange = ComboBoxProtocolChange
    Items.Strings = (
      'HTTP ( socket )'
      'HTTP ( fast http.sys - require admin rights else socket )'
      'WebSocket ( bidirectional, JSON )'
      'WebSocket ( bidirectional, binary )'
      'WebSocket ( bidirectional, binary + AES-CFB 256)'
      '// Named pipe')
  end
  object GroupBoxMethodGroupConfiguration: TGroupBox
    Left = 164
    Top = 62
    Width = 520
    Height = 164
    Caption = 'Method / Group configuration'
    Enabled = False
    TabOrder = 9
    object ListViewMethodGroups: TListView
      Left = 10
      Top = 16
      Width = 503
      Height = 110
      Columns = <
        item
          Caption = ' Method'
          Width = 150
        end
        item
          Caption = ' Allow group by name'
          Width = 160
        end
        item
          Caption = ' Deny group by name'
          Width = 160
        end>
      Items.ItemData = {
        05D30100000500000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
        000A480065006C006C006F0057006F0072006C00640014550073006500720073
        002C00410064006D0069006E006900730074007200610074006F007200730058
        DFC21F00000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000000353007500
        6D0014550073006500720073002C00410064006D0069006E0069007300740072
        00610074006F007200730088E1C21F00000000FFFFFFFFFFFFFFFF01000000FF
        FFFFFF000000000F47006500740043007500730074006F006D00520065006300
        6F00720064000E410064006D0069006E006900730074007200610074006F0072
        007300F8E1C21F00000000FFFFFFFFFFFFFFFF01000000FFFFFFFF0000000010
        530065006E00640043007500730074006F006D005200650063006F0072006400
        0E410064006D0069006E006900730074007200610074006F007200730030E2C2
        1F00000000FFFFFFFFFFFFFFFF01000000FFFFFFFF0000000019530065006E00
        64004D0075006C007400690070006C00650043007500730074006F006D005200
        650063006F007200640073000E410064006D0069006E00690073007400720061
        0074006F0072007300C0E1C21FFFFFFFFFFFFFFFFFFFFF}
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object ButtonSaveRoleConfiguration: TButton
      Left = 463
      Top = 130
      Width = 50
      Height = 25
      Caption = 'Save'
      TabOrder = 1
    end
    object EditAllowGroupNames: TEdit
      Left = 136
      Top = 132
      Width = 160
      Height = 21
      TabOrder = 2
      TextHint = 'Allow group name'
    end
    object EditDenyAllowGroupNames: TEdit
      Left = 298
      Top = 132
      Width = 159
      Height = 21
      TabOrder = 3
      TextHint = 'Deny group name'
    end
  end
  object RadioGroupAuthorizationPolicy: TRadioGroup
    Left = 8
    Top = 62
    Width = 150
    Height = 73
    Caption = 'Authorization policy'
    Enabled = False
    ItemIndex = 0
    Items.Strings = (
      'Allow all'
      'Deny all'
      'Follow groups settings')
    TabOrder = 10
  end
  object GroupBoxUsers: TGroupBox
    Left = 690
    Top = 62
    Width = 383
    Height = 164
    Caption = 'Users'
    Enabled = False
    TabOrder = 11
    object ListViewUsers: TListView
      Left = 9
      Top = 16
      Width = 365
      Height = 110
      Columns = <
        item
          Caption = ' User'
          Width = 160
        end
        item
          Caption = ' Group'
          Width = 160
        end>
      Items.ItemData = {
        05780000000200000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
        000441006C00650078000555007300650072007300704BC41F00000000FFFFFF
        FFFFFFFFFF01000000FFFFFFFF00000000044A006F0068006E000E410064006D
        0069006E006900730074007200610074006F0072007300E04BC41FFFFFFFFF}
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object EditUserGroup: TEdit
      Left = 192
      Top = 132
      Width = 126
      Height = 21
      TabOrder = 1
      TextHint = 'Group'
    end
    object ButtonSaveUsers: TButton
      Left = 324
      Top = 130
      Width = 50
      Height = 25
      Caption = 'Save'
      TabOrder = 2
    end
    object EditUserName: TEdit
      Left = 64
      Top = 132
      Width = 126
      Height = 21
      TabOrder = 3
      TextHint = 'User'
    end
    object ButtonAddUser: TButton
      Left = 9
      Top = 130
      Width = 24
      Height = 25
      Caption = '+'
      TabOrder = 4
    end
    object ButtonDeleteUser: TButton
      Left = 34
      Top = 130
      Width = 24
      Height = 25
      Caption = '-'
      TabOrder = 5
    end
  end
  object TimerRefreshLogMemo: TTimer
    OnTimer = TimerRefreshLogMemoTimer
    Left = 56
    Top = 240
  end
end
