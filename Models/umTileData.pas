unit umTileData;

interface

uses ZDataset;

type
  TDataState = (dsOk, dsDel, dsIns);

  TTileDataModel = class
    protected
      fId : integer;
      fDataState : TDataState;

    public
      constructor Create;  overload;
      constructor Create(aId : integer); overload;
      procedure PreapareInsertQry(aQry : TZQuery); virtual; abstract;
      procedure LoadFrom(aQry : TZQuery); virtual; abstract;

      property ID : integer read fId;
      property DataState : TDataState read fDataState write fDataState;
  end;

implementation

  constructor TTileDataModel.Create(aId : integer);
  begin
    inherited Create;
    fId := aId;
    fDataState := dsOk;
  end;

  constructor TTileDataModel.Create();
  begin
    inherited Create;
    fId := -1;
    fDataState := dsOk;
  end;

end.
