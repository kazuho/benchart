use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => "App::benchart",
    VERSION_FROM => "benchart",
    EXE_FILES    => ["benchart"],
    PREREQ_PM    => {
        "XML::TreePP" => 0,
    },
);
