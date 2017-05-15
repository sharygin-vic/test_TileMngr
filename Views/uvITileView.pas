unit uvITileView;

interface

uses  Classes, Controls;

type
  ITileView = interface;
  TCloseTileProc = procedure(sender : ITileView) of object;

  ITileView = interface
    ['{45779DA7-F5E0-4BBE-B6C0-BE658749610E}']
    procedure setPosition(aLeft, aTop, aWidth : integer);
    function getHeight : integer;
    function getWidth : integer;

    procedure setTileData(aTileData : TObject);
    function getTileData : TObject;

    function getOwner : TComponent;

    procedure setParent(aParent : TWinControl);
    function getParent : TWinControl;

    procedure setControlName(aName : String);
    function getControlName : String;

    procedure setOnCloseClick(aProc : TCloseTileProc);

    function getTileMinWidth : integer;
    function getTileMinHeight : integer;

  end;

  ITileViewFab = interface
    ['{579D736D-BDB9-41AF-9DF5-02D7BD9A70A1}']
    function getTileViewInstance(aOwner : TComponent; aParent : TWinControl) : ITileView;
  end;

implementation

end.
