# Data::ExampleDatasets Raku package

[![SparkyCI](http://sparrowhub.io:2222/project/gh-antononcube-Raku-Data-ExampleDatasets/badge)](http://sparrowhub.io:2222)

Raku package for (obtaining) example datasets.

Currently, this repository contains only [datasets metadata](./resources/dfRdatasets.csv).
The datasets are downloaded from the repository 
[Rdatasets](https://github.com/vincentarelbundock/Rdatasets/),
[VAB1].

------

## Usage examples

### Setup

Here we load the Raku modules
[`Data::Generators`](https://modules.raku.org/dist/Data::Generators:cpan:ANTONOV),
[`Data::Summarizers`](https://github.com/antononcube/Raku-Data-Summarizers),
and this module,
[`Data::ExampleDatasets`](https://github.com/antononcube/Raku-Data-ExampleDatasets):

```perl6
use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;
```
```
# (Any)
```

### Get a dataset by using an identifier

Here we get a dataset by using an identifier and display part of the obtained dataset:

```perl6
my @tbl = example-dataset('Baumann', :headers);
say to-pretty-table(@tbl[^6]);
```
```
#ERROR: If the first argument is an array then it is expected that it can be coerced into a array-of-hashes, array-of-positionals, or hash-of-hashes, which in turn can be coerced into a full two dimensional array.
# Nil
```

Here we summarize the dataset obtained above:

```perl6
records-summary(@tbl)
```
```
#ERROR: No such method 'value' for invocant of type 'Array'.  Did you mean
#ERROR: 'values'?
# Nil
```

**Remark**:  The values for the first argument of `example-dataset` correspond to the values 
of the columns “Item” and “Package”, respectively, in the
[metadata dataset](https://vincentarelbundock.github.io/Rdatasets/articles/data.html) 
from the GitHub repository “Rdatasets”, [VAB1]. 
See the datasets metadata sub-section below.

The first argument of `example-dataset` can take as values:


- Strings that correspond to the column "Items" of the metadata dataset

  - E.g. `example-dataset("mtcars")`

- Strings that correspond to the columns "Package" and "Items" of the metadata dataset
    
  - E.g. `example-dataset("COUNT::titanic")`

- Regexes

  - E.g. `example-dataset(/ .* mann $ /)`

- `Whatever` or `WhateverCode`

### Get a dataset by using an URL

Here we get a dataset by using an URL and display a summary of the obtained dataset:

```perl6
my $url = 'https://raw.githubusercontent.com/antononcube/Raku-Data-Reshapers/main/resources/dfTitanic.csv';
my @tbl2 = example-dataset($url, :headers);
records-summary(@tbl2);
```
```
# +-----------------+----------------+---------------------+-------------------+---------------+
# | id              | passengerClass | passengerAge        | passengerSurvival | passengerSex  |
# +-----------------+----------------+---------------------+-------------------+---------------+
# | Min    => 1     | 3rd => 709     | Min    => -1        | died     => 809   | male   => 843 |
# | 1st-Qu => 327.5 | 1st => 323     | 1st-Qu => 10        | survived => 500   | female => 466 |
# | Mean   => 655   | 2nd => 277     | Mean   => 23.550038 |                   |               |
# | Median => 655   |                | Median => 20        |                   |               |
# | 3rd-Qu => 982.5 |                | 3rd-Qu => 40        |                   |               |
# | Max    => 1309  |                | Max    => 80        |                   |               |
# +-----------------+----------------+---------------------+-------------------+---------------+
```

### Datasets metadata

Here we:
1. Get the dataset of the datasets metadata
2. Filter it to have only datasets with 13 rows
3. Keep only the columns "Item", "Title", "Rows", and "Cols"
4. Display it in "pretty table" format

```perl6
my @tblMeta = get-datasets-metadata();
@tblMeta = @tblMeta.grep({ $_<Rows> == 13}).map({ $_.grep({ $_.key (elem) <Item Title Rows Cols>}).Hash });
say to-pretty-table(@tblMeta)
```
```
# +------+------------+------+--------------------------------------------------------------------+
# | Cols |    Item    | Rows |                               Title                                |
# +------+------------+------+--------------------------------------------------------------------+
# |  4   | Snow.pumps |  13  |    John Snow's Map and Data on the 1854 London Cholera Outbreak    |
# |  7   |    BCG     |  13  |                          BCG Vaccine Data                          |
# |  5   |   cement   |  13  |                  Heat Evolved by Setting Cements                   |
# |  2   |  kootenay  |  13  |   Waterflow Measurements of Kootenay River in Libby and Newgate    |
# |  5   | Newhouse77 |  13  | Medical-Care Expenditure: A Cross-National Survey (Newhouse, 1977) |
# |  2   |   Saxony   |  13  |                         Families in Saxony                         |
# +------+------------+------+--------------------------------------------------------------------+
```

### Keeping downloaded data

By default the data is obtained over the web from
[Rdatasets](https://github.com/vincentarelbundock/Rdatasets/),
but `example-dataset` has an option to keep the data "locally."
(The data is saved in `XDG_DATA_HOME`, see 
[[JS1](https://modules.raku.org/dist/XDG::BaseDirectory:cpan:JSTOWE)].)

This can be demonstrated with the following timings of a dataset with ~1300 rows:

```raku
my $startTime = now;
my $data = example-dataset( / 'COUNT::titanic' $ / ):keep;
my $endTime = now;
say "Geting the data first time took { $endTime - $startTime } seconds";
```
```
# Geting the data first time took 2.90335873 seconds
```

```raku
$startTime = now;
$data = example-dataset( / 'COUNT::titanic' $/ ):keep;
$endTime = now;
say "Geting the data second time took { $endTime - $startTime } seconds";
```
```
# Geting the data second time took 1.559416817 seconds
```

------

## References

### Functions, packages, repositories

[AAf1] Anton Antonov,
[`ExampleDataset`](https://resources.wolframcloud.com/FunctionRepository/resources/ExampleDataset),
(2020),
[Wolfram Function Repository](https://resources.wolframcloud.com/FunctionRepository).

[VAB1] Vincent Arel-Bundock,
[Rdatasets](https://github.com/vincentarelbundock/Rdatasets/),
(2020),
[GitHub/vincentarelbundock](https://github.com/vincentarelbundock).

[JS1] Jonathan Stowe,
[`XDG::BaseDirectory`](https://modules.raku.org/dist/XDG::BaseDirectory:cpan:JSTOWE),
(last updated on 2021-03-31),
[Raku Modules](https://modules.raku.org/).


### Interactive interfaces

[AAi1] Anton Antonov,
[Example datasets recommender interface](https://antononcube.shinyapps.io/ExampleDatasetsRecommenderInterface/),
(2021),
[Shinyapps.io](https://antononcube.shinyapps.io/).