use Test;

use lib './lib';
use lib '.';

use Data::ExampleDatasets;

plan 3;

## 1
isa-ok get-item-to-csv-url(), Hash, "get CSV URLs";

## 2
isa-ok get-item-to-csv-url(), Hash, "get DOC URLs";

## 3
ok get-url-data("https://vincentarelbundock.github.io/Rdatasets/doc/AER/ProgramEffectiveness.html"),
        "program effectiveness";

done-testing;
