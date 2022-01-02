use Test;

use lib './lib';
use lib '.';

use Data::ExampleDatasets;

plan 7;

## 1
ok example-dataset( 'mtcars' ), "load mtcars";

## 2
isa-ok example-dataset( 'mtcars' ), Array, "load mtcars and check type";

## 3
isa-ok example-dataset( / 'starwars' /):keep:no-nameless, Array, "load starwars and check type";

## 4
ok example-dataset( / 'COUNT::smoking' $ / ), "load COUNT::titanic";

## 5
ok example-dataset( / 'COUNT::smoking' $ / ):keep, "load COUNT::titanic with keep";

## 6
ok example-dataset( 'https://vincentarelbundock.github.io/Rdatasets/csv/carData/Baumann.csv' ), "load URL";

## 7
nok example-dataset('iris'), "try to get a datasets with 'iris'.";

done-testing;
