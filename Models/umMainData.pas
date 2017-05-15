unit umMainData;

interface

uses Generics.Collections, umTileData, ZConnection, ZDataset;

type
  TAddTileProc<D> = procedure (aTileData : D) of object;

  TTilesDataList<D : TTileDataModel, constructor> = class
  private
    fTilesList : TObjectList<D>;
    ZConnectionDb: TZConnection;
    ZQueryTiles: TZQuery;
    fOnAddTile : TAddTileProc<D>;

    procedure setOnAddTile(aOnAddTile : TAddTileProc<D>);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ConnectDb;
    procedure DisconnectDB;
    procedure DBLoadTiles;
    procedure DBInsertTile(aTileData : D);
    procedure DBDelTile(aTileData : D);
    property  TilesList : TObjectList<D> read fTilesList;
    property  OnAddTile : TAddTileProc<D> write setOnAddTile;
  end;

implementation

uses SysUtils, Forms, Windows, uvLogin, ZDbcIntfs;

constructor TTilesDataList<D>.Create;
begin
  inherited Create;
  fTilesList := TObjectList<D>.Create(true);
end;

destructor TTilesDataList<D>.Destroy;
begin
  fTilesList.Free;
  inherited Destroy;
end;

procedure TTilesDataList<D>.ConnectDb;
begin
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
  ZConnectionDb.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libmariadb.dll';
  ZConnectionDb.TransactIsolationLevel := tiReadCommitted;

  ZConnectionDb.Connect;

  ZQueryTiles := TZQuery.Create(nil);
  ZQueryTiles.Connection := ZConnectionDb;
end;

procedure TTilesDataList<D>.DisconnectDB;
begin
  try
    ZQueryTiles.Close;
    ZConnectionDb.Disconnect;
  except
  end;
end;

procedure TTilesDataList<D>.DBLoadTiles;
var
  i, MaxNum : integer;
  curTileData : D;
begin
  fTilesList.Clear;

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
          curTileData := D.Create;
          curTileData.LoadFrom(ZQueryTiles);
//          fTilesList.Add(curTileData);
          if assigned(fOnAddTile) then
            fOnAddTile(curTileData);
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

procedure TTilesDataList<D>.DBInsertTile(aTileData : D);
begin
  ZQueryTiles.Close;
  ZQueryTiles.sql.Clear;

  aTileData.PreapareInsertQry(ZQueryTiles);

  ZConnectionDb.StartTransaction;
  try
    ZQueryTiles.ExecSQL;
    ZConnectionDb.Commit;

  except
    ZConnectionDb.Rollback;
    raise;
  end;
end;

procedure TTilesDataList<D>.DBDelTile(aTileData : D);
begin
  ZQueryTiles.Close;
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

procedure TTilesDataList<D>.setOnAddTile(aOnAddTile : TAddTileProc<D>);
begin
  fOnAddTile :=  aOnAddTile;
end;

end.
