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
    fIsTilesRepositionEnabled : boolean;
  public
    procedure tailsReposition;
    property IsTilesRepositionEnabled : boolean read fIsTilesRepositionEnabled write fIsTilesRepositionEnabled;
  end;

var
  FormMain: TFormMain;

implementation

uses uvITileView;

{$R *.dfm}

const
  FrameTileMinWidth = 200;
  FrameTileHeight = 70;
  countColumn = 3;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  scrlTiles.Constraints.MinWidth := 3 * FrameTileMinWidth + 20;
  scrlTiles.Constraints.MinHeight := FrameTileHeight + 1;
  fIsTilesRepositionEnabled := true;
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
  curTile : ITileView;
begin
  if fIsTilesRepositionEnabled then
  begin
    maxNum := pnlTiles.ControlCount - 1;
    if maxNum >= 0 then
    begin
      //pnlTiles.Hide;
      curTile := (pnlTiles.Controls[0]) as ITileView;
      tileWidth := pnlTiles.ClientWidth div countColumn;
      tileHeight := curTile.getHeight;
      curPosX := 0;
      curPosY := 0;
      for i := 0 to maxNum do
      begin
        curTile := (pnlTiles.Controls[i]) as ITileView;
        (ITileView(curTile)).setPosition(curPosX * tileWidth, curPosY * tileHeight, tileWidth);
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
end;

end.
