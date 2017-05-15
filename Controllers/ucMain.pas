unit ucMain;

interface

uses uvMain, umMainData, uvITileView, umTileData, ucFrmTile;

type
  TFormMainController<D : TTileDataModel, constructor> = class
  private
    fView: TFormMain;
    fModel: TTilesDataList<D>;
    fFrmTileController : TFrmTileController<D>;
    fdataChanged : boolean;

    procedure OnBtnAddClick(Sender: TObject);
    procedure OnBtnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure updateTilesLabel;
  public
    constructor Create(aView: TFormMain; aModel: TTilesDataList<D>; aFrmTileController : TFrmTileController<D>);
    destructor Destroy; override;
    procedure addTile(aTileData : D);
    procedure removeTile(aTile : ITileView);
    procedure DBLoadTiles;
  end;

const
  MaxTileCount = 21;

implementation

uses  SysUtils,Forms,Windows, ZDbcIntfs, uvLogin, controls;

procedure TFormMainController<D>.updateTilesLabel;
begin
  fView.lblTilesCount.Caption := intToStr(fView.pnlTiles.ControlCount) + '/' + intToStr(MaxTileCount);
end;


constructor TFormMainController<D>.Create(aView: TFormMain; aModel: TTilesDataList<D>; aFrmTileController : TFrmTileController<D>);
var
  fmLogin : TfmLogin;
begin
  inherited Create;

  fView := aView;
  fModel := aModel;
  fModel.OnAddTile := self.addTile;
  fFrmTileController := aFrmTileController;
  fFrmTileController.RemoveTileProc := self.removeTile;

  fView.btnAdd.OnClick := OnBtnAddClick;
  fView.btnSave.OnClick := OnBtnSaveClick;
  fView.OnCloseQuery := FormCloseQuery;
  updateTilesLabel;

  try
    fModel.ConnectDb;
    DBLoadTiles;
    fView.tailsReposition;
    updateTilesLabel;
  except
    Application.MessageBox('Неправильные параметры подключения.', 'Ошибка', mb_Ok);
    fView.pnlTool.Enabled := false;
  end;
end;

destructor TFormMainController<D>.Destroy;
begin
  fModel.DisconnectDB;
  inherited Destroy;
end;



procedure TFormMainController<D>.addTile(aTileData : D);
var
  tile : ITileView;
begin
  tile := fFrmTileController.makeFrameTile(aTileData);
  fModel.TilesList.Add(aTileData);
  fView.tailsReposition;
  updateTilesLabel;
end;

procedure TFormMainController<D>.OnBtnAddClick(Sender: TObject);
var
  TileData : TTileDataModel;
begin
  if fView.pnlTiles.ControlCount >= 21 then
  begin
    Application.MessageBox('Больше 21-й папки вставлять нельзя.', 'Внимание', mb_Ok);
    exit;
  end;
  if Length(fView.edTileName.Text) < 3 then
  begin
    Application.MessageBox('В имени папки должно быть больше 2-х символов.', 'Внимание', mb_Ok);
    exit;
  end;

  TileData := D.Create;
  fFrmTileController.InitTileDataModel(TileData);

  addTile(TileData);
  TileData.DataState := dsIns;
  fdataChanged := true;
end;

procedure TFormMainController<D>.removeTile(aTile : ITileView);
begin
  fView.pnlTiles.RemoveControl(aTile as TControl);
  (TTileDataModel(aTile.getTileData)).DataState := dsDel;
  fView.tailsReposition;

  updateTilesLabel;
  fdataChanged := true;
end;

procedure TFormMainController<D>.OnBtnSaveClick(Sender: TObject);
var
  curTileData : TTileDataModel;
  i, maxNum : integer;
begin
  maxNum := fModel.TilesList.Count - 1;

  // insert into DB
  for i := 0 to maxNum do
  begin
    curTileData := fModel.TilesList.Items[i];
    if curTileData.DataState = dsIns then
    begin
      try
        fModel.DBInsertTile(curTileData);
      except
        //TODO переделать на счетчик ошибок и вывод одного окна обо всех неудачах в конце:
        Application.MessageBox('Ошибка записи в базу данных.', 'Внимание', mb_ok) ;
        exit;    // возможн вариант продолжения цикла, но если не выйти, можно попасть на ряд раздражающих мельканий окна об ошибке
      end;
      curTileData.DataState := dsOk;
    end;
  end;

  // del from DB
  for i := maxNum downto 0 do
  begin
    curTileData := fModel.TilesList.Items[i];
    if curTileData.DataState = dsDel then
    begin
      try
        fModel.DBDelTile(curTileData);
      except
        //TODO переделать на счетчик ошибок и вывод одного окна обо всех неудачах в конце:
        Application.MessageBox('Ошибка записи в базу данных.', 'Внимание', mb_ok) ;
        exit;    // возможн вариант продолжения цикла, но если не выйти, можно попасть на ряд раздражающих мельканий окна об ошибке
      end;
      fModel.TilesList.Remove(curTileData);    // List is owner for items => auto destroy items
    end;
  end;

  DBLoadTiles;
  updateTilesLabel;
  fView.tailsReposition;
  fdataChanged := false;
end;

procedure TFormMainController<D>.DBLoadTiles;
var
  i, MaxNum : integer;
  curData : D;
begin
  // чистка фреймов на главном окне:
  MaxNum := fView.pnlTiles.ControlCount - 1;
  for i := maxNum downto 0 do
  begin
    fView.pnlTiles.RemoveControl(fView.pnlTiles.Controls[i]);
  end;
  fView.IsTilesRepositionEnabled := false;
  fModel.DBLoadTiles;
  fView.IsTilesRepositionEnabled := true;
end;


procedure TFormMainController<D>.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not (fdataChanged and (Application.MessageBox('Данные были изменены. Отменить выход?', 'Внимание', mb_YesNo) = id_yes));
end;

end.
