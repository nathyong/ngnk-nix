{ stdenv, fetchurl, clang_12, rlwrap }:

stdenv.mkDerivation rec {
  pname = "k";
  version = "unstable-2022_02_09";
  rev = "440a8ea492fdf94cc1ba3736fdbe6b34c487f122";

  src = fetchurl {
    url = "https://codeberg.org/ngn/k/archive/${rev}.tar.gz";
    hash = "sha256-Eel9ZTlpJrfW/LJSK25Q+D2WiAuDUJqE6sFzVN7t2bw=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ clang_12 ];

  makeFlags = [ "k-libc" "CC=clang" ];

  prePatch = ''
    patchShebangs .
  '';

  doCheck = true;

  checkPhase = ''
    make t
  '';

  installPhase = ''
    install -D -m 755 ./k $out/bin/k-base
    install -D -m 644 repl.k $out/share/k/repl.k
    cat | sed -e "s|%OUT%|$out|g" > $out/bin/k <<"EOF"
#!/usr/bin/env sh
if [ $# -ge 1 ] || ! [ -t 0 ]; then
    exec %OUT%/bin/k-base "$@"
else
    exec ${rlwrap}/bin/rlwrap %OUT%/bin/k-base %OUT%/share/k/repl.k
fi
EOF
    chmod +x $out/bin/k
'';
}
