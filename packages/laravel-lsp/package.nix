{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel-lsp";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CcN020PWXY6VjUWCnNwwG+nB7rpZ39R3bH3UCuXqXzo=";
  };

  vendorHash = "sha256-rODoJyeJOiBXVCR6BpSsfqEWu3n3XGFsbvJpOrlbtRA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  composerNoDev = false;
  preInstall = ''
    mv server laravel-lsp
    substituteInPlace composer.json --replace-fail 'builds/laravel-lsp' 'laravel-lsp';
    substituteInPlace config/app.php --replace-fail "app('git.version')" "'v${finalAttrs.version}'"
  '';

  meta = {
    changelog = "https://github.com/laravel/lsp/releases/tag/v${finalAttrs.version}";
    description = "Laravel Language Server";
    homepage = "https://github.com/laravel/lsp";
    license = lib.licenses.mit;
    mainProgram = "laravel-lsp";
    maintainers = [ lib.maintainers.FatBoyXPC ];
  };
})
