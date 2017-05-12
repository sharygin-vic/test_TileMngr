unit ucFrmTile;

interface

uses uvMain, uvFrmTile, umTileData;

type
  TRemoveProc = procedure (aTile : TFrameTile) of object;

  TFrmTileController = class
  private
    fView: TFormMain;
    //fModel: TTileDataModel;
    fRemoveProc : TRemoveProc;

    procedure onTileCloseClick(Sender: TObject);
  public
    constructor Create(aView: TFormMain; aRemoveProc : TRemoveProc);
    function makeFrameTile(aTileData : TTileDataModel) : TFrameTile;
    procedure TileClose(aFrameTile : TFrameTile);
  end;

implementation

uses  SysUtils, ExtCtrls;

const
  nextTileNameNum : integer = 1;

constructor TFrmTileController.Create(aView: TFormMain; (*aModel: TTileDataModel;*) aRemoveProc : TRemoveProc);
begin
  fView := aView;
  //fModel := aModel;
  fRemoveProc := aRemoveProc;
end;

procedure TFrmTileController.TileClose(aFrameTile : TFrameTile);
begin
  if assigned(fRemoveProc) then
    fRemoveProc(aFrameTile);
end;

procedure TFrmTileController.onTileCloseClick(Sender: TObject);
begin
  TileClose( TFrameTile((TImage(Sender)).Owner));
end;

function TFrmTileController.makeFrameTile(aTileData : TTileDataModel) : TFrameTile;
begin
  result := TFrameTile.Create(fView);
  result.Parent := fView.pnlTiles;
  result.TileData := aTileData;
  result.imgClose.OnClick := onTileCloseClick;
  result.Name := 'frameTile' + intToStr(nextTileNameNum);
  inc(nextTileNameNum);
end;

end.
