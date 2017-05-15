unit umTileDataFolder;

interface

uses umTileData, ZDataset;

type
  TTileDataFolder = class (TTileDataModel)
  protected
    fName : String;

  public
    constructor Create(aId : integer; aName : String);
    procedure PreapareInsertQry(aQry : TZQuery);  override;
    procedure LoadFrom(aQry : TZQuery); override;

    property Name : String read fName write fName;
  end;

implementation

constructor TTileDataFolder.Create(aId : integer; aName : String);
begin
  inherited Create(aId);
  fName := aName;
end;

procedure TTileDataFolder.PreapareInsertQry(aQry : TZQuery);
begin
  aQry.sql.Append('insert into tile (name) values (:name);');
  aQry.Params[0].AsString := Name;
end;

procedure TTileDataFolder.LoadFrom(aQry : TZQuery);
begin
  fid := aQry.FieldByName('id').AsInteger;
  fName := aQry.FieldByName('name').AsString;
end;

end.
