use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => "App-benchart",
    VERSION_FROM => "bin/benchart",
    EXE_FILES    => ["bin/benchart"],
);
