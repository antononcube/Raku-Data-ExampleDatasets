#!/usr/bin/env perl6

# I made this file and corresponding workflow because I did not know about BEGIN.

use lib './lib';
use lib '.';

use Data::ExampleDatasets;
use Data::ExampleDatasets::AccessData;
use Data::Reshapers;
use Text::CSV;

my $startTime = now;
my $dfMeta = get-datasets-metadata();
my $endTime = now;
say "Ingested metadata with { $dfMeta.elems } rows within { $endTime - $startTime } seconds";

#say to-pretty-table($dfMeta);

my $packageItemToCSV = select-columns($dfMeta, <Package Item CSV>);
$packageItemToCSV = group-by($packageItemToCSV, <Package Item>, sep => "::");
$packageItemToCSV = $packageItemToCSV.map({ $_.key => $_.value.first<CSV> });


my $packageItemToDOC = select-columns($dfMeta, <Package Item Doc>);
$packageItemToDOC = group-by($packageItemToDOC, <Package Item>, sep => "::");
$packageItemToDOC = $packageItemToDOC.map({ $_.key => $_.value.first<Doc> });

spurt "./AccessData.rakumod",
        'unit module Data::ExampleDatasets::AccessData;' ~ "\n\n" ~
                'sub item-to-csv-url() is export {' ~ "\n" ~ $packageItemToCSV.Hash.raku ~ "\n" ~ '}' ~ "\n\n" ~
                'sub item-to-doc-url() is export {' ~ "\n" ~ $packageItemToDOC.Hash.raku ~ "\n" ~ '}' ~ "\n";


