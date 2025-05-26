{ lib, buildNpmPackage, }:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.5.0";

  src = ./arrpc;

  npmDepsHash = "sha256-wejDorIhq576hMI6MIshNNMcIqZsneihBPk0eIWXIoQ=";

  dontNpmBuild = true;

  postInstall = ''
    mkdir -p $out/lib/systemd/user
    substitute ${./arrpc.service} $out/lib/systemd/user/arrpc.service \
      --subst-var-by arrpc $out/bin/arrpc
  '';

  meta = {
    changelog =
      "https://github.com/OpenAsar/arrpc/blob/${version}/changelog.md";
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anomalocaris NotAShelf ulysseszhan ];
    mainProgram = "arrpc";
  };
}
