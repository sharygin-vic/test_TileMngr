unit umTileData;

interface

type
  TDataState = (dsOk, dsDel, dsIns);

  TTileDataModel = class
    private
      fId : integer;
      fName : String;
      fDataState : TDataState;

    public
      constructor Create;  overload;
      constructor Create(aId : integer; aName : String); overload;

      property ID : integer read fId;
      property Name : String read fName;
      property DataState : TDataState read fDataState write fDataState;
  end;

implementation

  constructor TTileDataModel.Create(aId : integer; aName : String);
  begin
    fId := aId;
    fName := aName;
    fDataState := dsOk;
  end;

  constructor TTileDataModel.Create();
  begin
    fId := -1;
    fName := '';
    fDataState := dsOk;
  end;

end.
