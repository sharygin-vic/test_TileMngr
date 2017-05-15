unit ucFrmTile;

interface

uses uvMain, umTileData, uvITileView;

type
  TRemoveTileProc = procedure (aTile : ITileView) of object;

  TFrmTileController<D : TTileDataModel> =  class  abstract
  protected
    fView: TFormMain;
    fRemoveTileProc : TRemoveTileProc;
    fTileViewFab : ITileViewFab;

    class var NameIndex : integer;

    procedure onTileCloseClick(Sender: ITileView);
    class function getNextNameIndex : integer;
    procedure ShowDataIntoFrame(aFrameTile : ITileView; aTileData : D);  virtual; abstract;
  public
    constructor Create(aView: TFormMain; aTileViewFab : ITileViewFab);
    function makeFrameTile(aTileData : D) : ITileView;
    procedure TileClose(aFrameTile : ITileView);
    procedure InitTileDataModel(aTileData : D); virtual; abstract;

    property  RemoveTileProc : TRemoveTileProc write fRemoveTileProc;
  end;

implementation

uses  SysUtils, ExtCtrls;


class function TFrmTileController<D>.getNextNameIndex : integer;
begin
  inc(NameIndex);
  result := NameIndex;
end;

constructor TFrmTileController<D>.Create(aView: TFormMain; aTileViewFab : ITileViewFab);
begin
  inherited Create;
  fView := aView;
  fTileViewFab := aTileViewFab;
end;

procedure TFrmTileController<D>.TileClose(aFrameTile : ITileView);
begin
  if assigned(fRemoveTileProc) then
    fRemoveTileProc(aFrameTile);
end;

procedure TFrmTileController<D>.onTileCloseClick(Sender: ITileView);
begin
  TileClose(Sender);
end;

function TFrmTileController<D>.makeFrameTile(aTileData : D) : ITileView;
begin
  result := fTileViewFab.getTileViewInstance(fView, fView.pnlTiles);
  result.setTileData(aTileData);

  result.setOnCloseClick(onTileCloseClick);
  result.setControlName('FrameTile' + intToStr(TFrmTileController<D>.getNextNameIndex));

  ShowDataIntoFrame(result, aTileData);
end;



end.
