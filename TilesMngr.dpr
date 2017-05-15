program TilesMngr;

uses
  Forms,
  uvMain in 'Views\uvMain.pas' {FormMain},
  uvFrmTileFolder in 'Views\uvFrmTileFolder.pas' {FrameTileFolder: TFrame},
  umTileData in 'Models\umTileData.pas',
  ucMain in 'Controllers\ucMain.pas',
  ucFrmTile in 'Controllers\ucFrmTile.pas',
  uvLogin in 'Views\uvLogin.pas' {fmLogin},
  umMainData in 'Models\umMainData.pas',
  ucFrmTileFolder in 'Controllers\ucFrmTileFolder.pas',
  umTileDataFolder in 'Models\umTileDataFolder.pas',
  uvITileView in 'Views\uvITileView.pas',
  uFrameTileFolderFab in 'services\uFrameTileFolderFab.pas';

{$R *.res}

var
  FormMainController : TFormMainController<TTileDataFolder>;
  FrmTileController : TFrmTileController<TTileDataFolder>;
  MainModel : TTilesDataList<TTileDataFolder>;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  try
    MainModel := TTilesDataList<TTileDataFolder>.Create();
    FrmTileController := TFrmTileFolderController.Create(FormMain , TFrameTileFolderFab.Create);
    FormMainController := TFormMainController<TTileDataFolder>.Create(FormMain, MainModel, FrmTileController);

    Application.Run;
  finally
    try
      MainModel.Free;
      FrmTileController.Free;
      FormMainController.Free;
    except
    end;
  end;
end.
