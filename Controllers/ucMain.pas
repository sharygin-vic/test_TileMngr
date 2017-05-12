unit ucMain;

interface

uses uvMain, uvFrmTile, umTileData, ucFrmTile, Generics.Collections, ZConnection, ZDataset;

type
  TFormMainController = class
  private
    fTilesList : TObjectList<TTileDataModel>;
    fView: TFormMain;
    //fModel: TTileDataModel;
    fFrmTileController : TFrmTileController;
    fdataChanged : boolean;

    ZConnectionDb: TZConnection;
    ZQueryTiles: TZQuery;

    procedure OnBtnAddClick(Sender: TObject);
    procedure OnBtnSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure updateTilesLabel;

    procedure DBLoadTiles;
    procedure DBInsertTile(aTileData : TTileDataModel);
    procedure DBDelTile(aTileData : TTileDataModel);
  public
    constructor Create(aView: TFormMain);
    destructor Destroy; override;
    procedure addTile(aTileData : TTileDataModel);
    procedure removeTile(aTile : TFrameTile);
  end;

const
  MaxTileCount = 21;

implementation

uses  SysUtils,Forms,Windows, ZDbcIntfs, uvLogin;

procedure TFormMainController.updateTilesLabel;
begin
  fView.lblTilesCount.Caption := intToStr(fView.pnlTiles.ControlCount) + '/' + intToStr(MaxTileCount);
end;


constructor TFormMainController.Create(aView: TFormMain);
var
  fmLogin : TfmLogin;
begin
  fView := aView;
  fFrmTileController := TFrmTileController.Create(aView, removeTile);

  fTilesList := TObjectList<TTileDataModel>.Create(true);

  fView.btnAdd.OnClick := OnBtnAddClick;
  fView.btnSave.OnClick := OnBtnSaveClick;
  fView.OnCloseQuery := FormCloseQuery;
  updateTilesLabel;
  //
  ZConnectionDb := TZConnection.Create(nil);

  fmLogin := TfmLogin.Create(nil);
  if fmLogin.ShowModal = id_ok then
  begin
    ZConnectionDb.HostName := fmLogin.edHostName.Text;
    ZConnectionDb.Database := fmLogin.edDatabase.Text;
    ZConnectionDb.User     := fmLogin.edUser.Text;
    ZConnectionDb.Password := fmLogin.edPassword.Text;
  end
  else begin
    ZConnectionDb.HostName := '127.0.0.1';
    ZConnectionDb.Database := 'tilesdb';
    ZConnectionDb.User     := 'root';
    ZConnectionDb.Password := 'mysql';
  end;
  fmLogin.Free;

  ZConnectionDb.Protocol := 'mysql-5';
  ZConnectionDb.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libmariadb.dll';  // 'C:\Work_D_2010\TileMngr\libmariadb.dll';
  ZConnectionDb.TransactIsolationLevel := tiReadCommitted;
  //ZConnectionDb.LoginPrompt := true;
  try
    ZConnectionDb.Connect;

    ZQueryTiles := TZQuery.Create(nil);
    ZQueryTiles.Connection := ZConnectionDb;

    DBLoadTiles;
    fView.tailsReposition;
    updateTilesLabel;
  except
    Application.MessageBox('Неправильные параметры подключения.', 'Ошибка', mb_Ok);
    fView.pnlTool.Enabled := false;
  end;
end;

destructor TFormMainController.Destroy;
begin
  try
    ZQueryTiles.Close;
    ZConnectionDb.Disconnect;
  except
  end;

  fFrmTileController.Free;
  fTilesList.Free;
end;



procedure TFormMainController.addTile(aTileData : TTileDataModel);
var
  tile : TFrameTile;
begin
  tile := fFrmTileController.makeFrameTile(aTileData);
  fTilesList.Add(aTileData);
  fView.tailsReposition;

  updateTilesLabel;
end;

procedure TFormMainController.OnBtnAddClick(Sender: TObject);
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

  TileData := TTileDataModel.Create(-1, fView.edTileName.Text);
  addTile(TileData);
  TileData.DataState := dsIns;
  fdataChanged := true;
end;

procedure TFormMainController.removeTile(aTile : TFrameTile);
begin
  fView.pnlTiles.RemoveControl(aTile);
  aTile.TileData.DataState := dsDel;
  fView.tailsReposition;

  updateTilesLabel;
  fdataChanged := true;
end;

procedure TFormMainController.OnBtnSaveClick(Sender: TObject);
var
  curTileData : TTileDataModel;
  i, maxNum : integer;
begin
  maxNum := fTilesList.Count - 1;

  // insert into DB
  for i := 0 to maxNum do
  begin
    curTileData := fTilesList.Items[i];
    if curTileData.DataState = dsIns then
    begin
      try
        DBInsertTile(curTileData);
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
    curTileData := fTilesList.Items[i];
    if curTileData.DataState = dsDel then
    begin
      try
        DBDelTile(curTileData);
      except
        //TODO переделать на счетчик ошибок и вывод одного окна обо всех неудачах в конце:
        Application.MessageBox('Ошибка записи в базу данных.', 'Внимание', mb_ok) ;
        exit;    // возможн вариант продолжения цикла, но если не выйти, можно попасть на ряд раздражающих мельканий окна об ошибке
      end;
      fTilesList.Remove(curTileData);    // List is owner for items => auto destroy items
    end;
  end;

  DBLoadTiles;
  updateTilesLabel;
  fView.tailsReposition;
  fdataChanged := false;
end;

procedure TFormMainController.DBLoadTiles;
var
  i, MaxNum : integer;
  curTileData : TTileDataModel;
begin
  fTilesList.Clear;     // чистка списка TTileDataModel

  // чистка фреймов на главном окне:
  MaxNum := fView.pnlTiles.ControlCount - 1;
  for i := maxNum downto 0 do
  begin
    fView.pnlTiles.RemoveControl(fView.pnlTiles.Controls[i]);
  end;

  try
    try
      ZQueryTiles.Close;
      ZQueryTiles.sql.Clear;
      ZQueryTiles.sql.Append('select * from tile');
      ZQueryTiles.open;

      MaxNum := ZQueryTiles.RecordCount;
      if MaxNum > 0 then
      begin
        ZQueryTiles.First;
        repeat
          curTileData := TTileDataModel.Create(
              ZQueryTiles.FieldByName('id').AsInteger,
              ZQueryTiles.FieldByName('name').AsString);
          self.addTile(curTileData);
          ZQueryTiles.Next;
          dec(MaxNum);
        until MaxNum = 0;
      end;
    except
      Application.MessageBox('Ошибка чтения из базы данных.', 'Внимание', mb_ok) ;
      //exit;
    end;
  finally
    ZQueryTiles.Close;
  end;
end;

procedure TFormMainController.DBInsertTile(aTileData : TTileDataModel);
begin
  ZQueryTiles.Close;
  ZQueryTiles.sql.Clear;
  ZQueryTiles.sql.Append('insert into tile (name) values (:name);');
  ZQueryTiles.Params[0].AsString := aTileData.Name;

  ZConnectionDb.StartTransaction;
  try
    ZQueryTiles.ExecSQL;
    ZConnectionDb.Commit;
    (*
    DBLoadTiles;  //  костыль - надо бы не перечитывать все для однопользовательской БД,
                  //  а получить ID записи с сервера. Нет времени разбираться.
                  //  Хотя для сетевой работы лучше зарефрешить все-таки на клиенте все
    *)
  except
    ZConnectionDb.Rollback;
    raise;
  end;
end;

procedure TFormMainController.DBDelTile(aTileData : TTileDataModel);
begin
  ZQueryTiles.Close;
//  ZQueryTiles.Open;
  ZQueryTiles.sql.Clear;
  ZQueryTiles.sql.Append('delete from tile where id = :id');
  ZQueryTiles.Params[0].AsInteger := aTileData.id;

  ZConnectionDb.StartTransaction;
  try
    ZQueryTiles.ExecSQL;
    ZConnectionDb.Commit;
  except
    ZConnectionDb.Rollback;
    raise;
  end;
end;

procedure TFormMainController.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not (fdataChanged and (Application.MessageBox('Данные были изменены. Отменить выход?', 'Внимание', mb_YesNo) = id_yes));
end;

end.
