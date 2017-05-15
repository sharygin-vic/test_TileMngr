unit ucFrmTileFolder;

interface

uses uvITileView, uvFrmTileFolder, umTileDataFolder, ucFrmTile;

type
  TFrmTileFolderController =  class (TFrmTileController<TTileDataFolder>)
  protected
    procedure ShowDataIntoFrame(aFrameTile : ITileView; aTileData : TTileDataFolder); override;
  public
    procedure InitTileDataModel(aTileData : TTileDataFolder); override;
  end;

implementation

procedure TFrmTileFolderController.ShowDataIntoFrame(aFrameTile : ITileView; aTileData : TTileDataFolder);
begin
  (aFrameTile as TFrameTileFolder).lblNameText.caption := aTileData.Name;
end;

procedure TFrmTileFolderController.InitTileDataModel(aTileData : TTileDataFolder);
begin
  aTileData.Name := fView.edTileName.Text;
end;

end.
