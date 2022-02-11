{ stdenv, fetchurl, clang_12, rlwrap, k-git }:

stdenv.mkDerivation rec {
  pname = "k";
  version = "unstable-${k-git.lastModifiedDate}";
  rev = k-git.rev;
  src = k-git;

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
