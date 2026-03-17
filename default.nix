{
  lib,
  buildEnv,

  stdenvNoCC,
  fclones,
  minify,

  # keep-sorted start
  aig,
  aligator,
  biped-stabilizer,
  coal,
  crocoddyl,
  eiquadprog,
  flex-joints,
  hpp-affordance,
  hpp-baxter,
  hpp-bezier-com-traj,
  hpp-centroidal-dynamics,
  hpp-constraints,
  hpp-core,
  hpp-doc,
  hpp-environments,
  hpp-gepetto-viewer,
  hpp-gui,
  hpp-manipulation,
  hpp-manipulation-urdf,
  hpp-pinocchio,
  hpp-plot,
  hpp-practicals,
  hpp-romeo,
  hpp-statistics,
  hpp-tools,
  hpp-tutorial,
  hpp-universal-robot,
  hpp-util,
  multicontact-api,
  ndcurves,
  pinocchio,
  proxsuite,
  python3Packages,
  tsid,
# keep-sorted end
}:

let
  env = buildEnv {
    name = "gepetto-doc";
    extraOutputsToInstall = [ "doc" ];
    pathsToLink = [ "/share/doc" ];
    paths = [
      # keep-sorted start
      aig
      aligator
      biped-stabilizer
      coal
      crocoddyl
      eiquadprog
      flex-joints
      hpp-affordance
      hpp-baxter
      hpp-bezier-com-traj
      hpp-centroidal-dynamics
      hpp-constraints
      hpp-core
      hpp-doc
      hpp-environments
      hpp-gepetto-viewer
      hpp-gui
      hpp-manipulation
      hpp-manipulation-urdf
      hpp-pinocchio
      hpp-plot
      hpp-practicals
      hpp-romeo
      hpp-statistics
      hpp-tools
      hpp-tutorial
      hpp-universal-robot
      hpp-util
      multicontact-api
      ndcurves
      pinocchio
      proxsuite
      python3Packages.eigenpy
      tsid
      # keep-sorted end
    ];
  };
in
stdenvNoCC.mkDerivation {
  name = "gepetto-doc";
  dontUnpack = true;

  nativeBuildInputs = [
    fclones
    minify
  ];

  postInstall = ''
    mkdir $out
    cp -rL ${env}/share/doc/* $out

    cd $out
    # TODO: pinocchio+crocoddyl latex issues
    # find . -type f -name \*.log | tee | grep . && exit 1
    find . -type d -name MathJax | tee | grep . && exit 1

    chmod -R +w .
    find . -maxdepth 3 -mindepth 3 -type f -exec sed -i -e "s=$NIX_STORE/.*/share/doc=../..=g" {} +
    find . -maxdepth 4 -mindepth 4 -type f -exec sed -i -e "s=$NIX_STORE/.*/share/doc=../../..=g" {} +

    # TODO (proxsuite)
    sed -i "s/'The solver's/'The solver\\\'s/" $(grep -rl "'The solver's")

    echo "dedup & minify"
    fclones group . | fclones link
    minify -ri .

    echo "<html><head><title>Gepetto Doc</title></head><body><ul>" > index.html
    for prj in *
    do
      [[ $prj == index.html ]] && continue
      echo "<li><a href=\"$prj/doxygen-html/index.html\">$prj</a></li>" >> index.html
    done
    echo "</ul></body></html>" >> index.html
  '';

  meta = {
    description = "Merged doxygen output from our projects and their dependencies";
    homepage = "https://github.com/gepetto/nix";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
}
