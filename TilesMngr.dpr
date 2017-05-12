program TilesMngr;

uses
  Forms,
  uvMain in 'Views\uvMain.pas' {FormMain},
  uvFrmTile in 'Views\uvFrmTile.pas' {FrameTile: TFrame},
  umTileData in 'Models\umTileData.pas',
  ucMain in 'Controllers\ucMain.pas',
  ucFrmTile in 'Controllers\ucFrmTile.pas',
  uvLogin in 'Views\uvLogin.pas' {fmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  TFormMainController.Create(FormMain);
  Application.Run;
end.
