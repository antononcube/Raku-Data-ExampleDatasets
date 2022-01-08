#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use Data::ExampleDatasets;
use Data::Reshapers;

# Load a well known dataset (if the given name is unique.)
say to-pretty-table(example-dataset('mtcars'));

# The identifier of dataset is made of package name, '::', and item name.
# See the metadata table for the package and item names.
say to-pretty-table(example-dataset('COUNT::smoking'));

# There are several datasets with 'iris' parts in their identifiers.
# Hence none is loaded -- message is given.
say example-dataset('iris');

# Using specification with regex gets a dataset:
say to-pretty-table(example-dataset( / iris $ /)[^12]);

# Getting metadata
my $startTime = now;
my @dfMeta = get-datasets-metadata();
my $endTime = now;
say "Ingested metadata with {@dfMeta.elems} rows within {$endTime-$startTime} seconds";

# say to-pretty-table(@dfMeta);


# Ingest from URL
$startTime = now;
my @tbl2 = example-dataset('https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/ACF1.csv');
$endTime = now;
say "Ingested URL data with {@tbl2.elems} rows within {$endTime-$startTime} seconds";

say to-pretty-table(@tbl2);

