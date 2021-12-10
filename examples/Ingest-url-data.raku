#!/usr/bin/env perl6

## It 7-10 faster to use this ad-hoc code than the standard Text::CSV worlflow.
#
#my @colNames = ["Package", "Item", "Title", "Rows", "Cols", "n_binary", "n_character", "n_factor", "n_logical", "n_numeric", "CSV", "Doc"];
#my $fileHandle = %?RESOURCES<dfRDatasets.csv>;
#my Str @metaRecords = $fileHandle.lines;
#my @tbl = @metaRecords[1 .. *- 1].map({ %( @colNames Z=> $_.split(',')) });
#
#return @tbl

use lib './lib';
use lib '.';

use Data::ExampleDatasets;
use Data::Reshapers;

my $startTime = now;
my @dfMeta = get-datasets-metadata();
my $endTime = now;
say "Ingested metadata with {@dfMeta.elems} rows within {$endTime-$startTime} seconds";

# say to-pretty-table(@dfMeta);

say to-pretty-table(import-csv-to-dataset('mtcars'));

