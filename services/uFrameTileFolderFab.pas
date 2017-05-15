unit uFrameTileFolderFab;

interface

uses uvITileView, Classes, Controls;

type
  TFrameTileFolderFab = class (TInterfacedObject, ITileViewFab)
    function getTileViewInstance(aOwner : TComponent; aParent : TWinControl) : ITileView;
  end;

implementation

uses uvFrmTileFolder;

function TFrameTileFolderFab.getTileViewInstance(aOwner : TComponent; aParent : TWinControl) : ITileView;
var
  res : TFrameTileFolder;
begin
  res := TFrameTileFolder.Create(aOwner);
  res.Parent := aParent;
  result := res;
end;

end.
