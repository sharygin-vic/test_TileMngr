unit uvFrmTileFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, uvITileView;

type
  TFrameTileFolder = class(TFrame, ITileView)
    pnlTile: TPanel;
    lblNameText: TLabel;
    imgFolder: TImage;
    imgClose: TImage;
    procedure imgCloseClick(Sender: TObject);
  private
    fTileData : TObject;
    fOnCloseClick : TCloseTileProc;
    
  public
    procedure setPosition(aLeft, aTop, aWidth : integer);
    function getHeight : integer;
    function getWidth : integer;

    procedure setTileData(aTileData : TObject);
    function getTileData : TObject;

    function getOwner : TComponent;

    procedure setParent(aParent : TWinControl);
    function getParent : TWinControl;

    procedure setControlName(aName : String);
    function getControlName : String;

    procedure setOnCloseClick(aProc : TCloseTileProc);

    function getTileMinWidth : integer;
    function getTileMinHeight : integer;
  end;


implementation

{$R *.dfm}



procedure TFrameTileFolder.setPosition(aLeft, aTop, aWidth : integer);
begin
  Left := aLeft;
  Top := aTop;
  Width := aWidth;
end;

function TFrameTileFolder.getHeight : integer;
begin
  result := Height;
end;


function TFrameTileFolder.getWidth : integer;
begin
  result := Width;
end;

procedure TFrameTileFolder.setTileData(aTileData : TObject);
begin
  fTileData := aTileData;
end;

function TFrameTileFolder.getTileData : TObject;
begin
  result := fTileData;
end;

function TFrameTileFolder.getOwner : TComponent;
begin
  result := owner;
end;

procedure TFrameTileFolder.setParent(aParent : TWinControl);
begin
  parent := aParent;
end;

function TFrameTileFolder.getParent : TWinControl;
begin
  result := parent;
end;

procedure TFrameTileFolder.setControlName(aName : String);
begin
  name := aName;
end;

function TFrameTileFolder.getControlName : String;
begin
  result := name;
end;

procedure TFrameTileFolder.setOnCloseClick(aProc : TCloseTileProc);
begin
  fOnCloseClick := aProc;
end;

procedure TFrameTileFolder.imgCloseClick(Sender: TObject);
begin
  if assigned(fOnCloseClick) then
    fOnCloseClick(self);
end;

function TFrameTileFolder.getTileMinWidth : integer;
begin
  result := Constraints.MinWidth;
end;

function TFrameTileFolder.getTileMinHeight : integer;
begin
  result := Constraints.MinHeight;
end;

end.
