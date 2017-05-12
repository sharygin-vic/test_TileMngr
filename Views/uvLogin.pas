unit uvLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmLogin = class(TForm)
    lblHostName: TLabel;
    edHostName: TEdit;
    edDatabase: TEdit;
    lblDatabase: TLabel;
    edUser: TEdit;
    lblUser: TLabel;
    edPassword: TEdit;
    lblPassword: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLogin: TfmLogin;

implementation

{$R *.dfm}

end.
