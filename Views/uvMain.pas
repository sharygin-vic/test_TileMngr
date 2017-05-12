unit uvMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFormMain = class(TForm)
    StatusBar1: TStatusBar;
    pnlTool: TPanel;
    btnAdd: TBitBtn;
    scrlTiles: TScrollBox;
    pnlTiles: TPanel;
    lblTilesCount: TLabel;
    edTileName: TEdit;
    btnSave: TBitBtn;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure tailsReposition;
  end;

var
  FormMain: TFormMain;

implementation

uses uvFrmTile;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  scrlTiles.Constraints.MinWidth := 3 * FrameTileMinWidth;
  scrlTiles.Constraints.MinHeight := FrameTileHeight + 1;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  pnlTiles.Hide;
  tailsReposition;
  pnlTiles.Show;
end;

procedure TFormMain.tailsReposition;
var
  i, maxNum, curPosX, curPosY, tileWidth, tileHeight : integer;
  curTile : TFrameTile;
const
  countColumn = 3;
begin
  maxNum := pnlTiles.ControlCount - 1;
  if maxNum >= 0 then
  begin
    //pnlTiles.Hide;
    curTile := TFrameTile(pnlTiles.Controls[0]);
    tileWidth := pnlTiles.ClientWidth div countColumn;
    tileHeight := curTile.Height;
    curPosX := 0;
    curPosY := 0;
    for i := 0 to maxNum do
    begin
      curTile := TFrameTile(pnlTiles.Controls[i]);
      (TFrameTile(curTile)).setPosition(curPosX * tileWidth, curPosY * tileHeight, tileWidth);
      inc(curPosX);
      if curPosX = countColumn then
      begin
        curPosX := 0;
        inc(curPosY);
      end;
    end;

    pnlTiles.SetBounds(0, 0, scrlTiles.ClientWidth, (curPosY+1) * tileHeight);
    //pnlTiles.Show;
  end;
end;

end.
