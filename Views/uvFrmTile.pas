unit uvFrmTile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, Buttons, StdCtrls, umTileData;

type
  TFrameTile = class(TFrame)
    pnlTile: TPanel;
    lblNameText: TLabel;
    imgFolder: TImage;
    imgClose: TImage;
  private
    fTileData : TTileDataModel;

    procedure setTileData(aTileData : TTileDataModel);
  public
    procedure setPosition(aLeft, aTop, aWidth : integer);

    property TileData : TTileDataModel read fTileData write setTileData;
  end;

const
  FrameTileMinWidth = 200;
  FrameTileHeight = 70;

implementation

{$R *.dfm}



procedure TFrameTile.setPosition(aLeft, aTop, aWidth : integer);
begin
  Left := aLeft;
  Top := aTop;
  Width := aWidth;
end;

procedure TFrameTile.setTileData(aTileData : TTileDataModel);
begin
  fTileData := aTileData;
  lblNameText.Caption := fTileData.Name;
end;

end.
