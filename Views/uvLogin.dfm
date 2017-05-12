object fmLogin: TfmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
  ClientHeight = 178
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblHostName: TLabel
    Left = 34
    Top = 16
    Width = 53
    Height = 13
    Caption = 'HostName:'
  end
  object lblDatabase: TLabel
    Left = 34
    Top = 43
    Width = 50
    Height = 13
    Caption = 'Database:'
  end
  object lblUser: TLabel
    Left = 34
    Top = 70
    Width = 26
    Height = 13
    Caption = 'User:'
  end
  object lblPassword: TLabel
    Left = 34
    Top = 97
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object edHostName: TEdit
    Left = 102
    Top = 13
    Width = 181
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object edDatabase: TEdit
    Left = 102
    Top = 40
    Width = 181
    Height = 21
    TabOrder = 1
    Text = 'tilesdb'
  end
  object edUser: TEdit
    Left = 102
    Top = 67
    Width = 181
    Height = 21
    TabOrder = 2
    Text = 'root'
  end
  object edPassword: TEdit
    Left = 102
    Top = 94
    Width = 181
    Height = 21
    TabOrder = 3
    Text = 'mysql'
  end
  object btnOk: TButton
    Left = 34
    Top = 130
    Width = 119
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 164
    Top = 130
    Width = 119
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
end
