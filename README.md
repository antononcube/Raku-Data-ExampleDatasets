# Data::ExampleDatasets Raku package

[![SparrowCI](https://ci.sparrowhub.io/project/gh-antononcube-Raku-Data-ExampleDatasets/badge)](https://ci.sparrowhub.io)

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
# +-----------+-------------+----------+-------------+-------------+-----------+-------+
# | pretest.2 | post.test.3 | rownames | post.test.2 | post.test.1 | pretest.1 | group |
# +-----------+-------------+----------+-------------+-------------+-----------+-------+
# |     3     |      41     |    1     |      4      |      5      |     4     | Basal |
# |     5     |      41     |    2     |      5      |      9      |     6     | Basal |
# |     4     |      43     |    3     |      3      |      5      |     9     | Basal |
# |     6     |      46     |    4     |      5      |      8      |     12    | Basal |
# |     5     |      46     |    5     |      9      |      10     |     16    | Basal |
# |     13    |      45     |    6     |      8      |      9      |     15    | Basal |
# +-----------+-------------+----------+-------------+-------------+-----------+-------+
```

Here we summarize the dataset obtained above:

```perl6
records-summary(@tbl)
```
```
# +----------------+--------------------+-------------+--------------------+--------------------+---------------------+--------------------+
# | rownames       | pretest.1          | group       | post.test.1        | pretest.2          | post.test.3         | post.test.2        |
# +----------------+--------------------+-------------+--------------------+--------------------+---------------------+--------------------+
# | Min    => 1    | Min    => 4        | Strat => 22 | Min    => 1        | Min    => 1        | Min    => 30        | Min    => 0        |
# | 1st-Qu => 17   | 1st-Qu => 8        | DRTA  => 22 | 1st-Qu => 5        | 1st-Qu => 3        | 1st-Qu => 40        | 1st-Qu => 5        |
# | Mean   => 33.5 | Mean   => 9.787879 | Basal => 22 | Mean   => 8.075758 | Mean   => 5.106061 | Mean   => 44.015152 | Mean   => 6.712121 |
# | Median => 33.5 | Median => 9        |             | Median => 8        | Median => 5        | Median => 45        | Median => 6        |
# | 3rd-Qu => 50   | 3rd-Qu => 12       |             | 3rd-Qu => 11       | 3rd-Qu => 6        | 3rd-Qu => 49        | 3rd-Qu => 8        |
# | Max    => 66   | Max    => 16       |             | Max    => 15       | Max    => 13       | Max    => 57        | Max    => 13       |
# +----------------+--------------------+-------------+--------------------+--------------------+---------------------+--------------------+
```

**Remark**:  The values for the first argument of `example-dataset` correspond to the values 
of the columns "Item" and "Package", respectively, in theA
[metadata dataset](https://vincentarelbundock.github.io/Rdatasets/articles/data.html) 
from the GitHub repository "Rdatasets", [VAB1]. 
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
# +----------------+---------------------+---------------+-----------------+-------------------+
# | passengerClass | passengerAge        | passengerSex  | id              | passengerSurvival |
# +----------------+---------------------+---------------+-----------------+-------------------+
# | 3rd => 709     | Min    => -1        | male   => 843 | Min    => 1     | died     => 809   |
# | 1st => 323     | 1st-Qu => 10        | female => 466 | 1st-Qu => 327.5 | survived => 500   |
# | 2nd => 277     | Mean   => 23.550038 |               | Mean   => 655   |                   |
# |                | Median => 20        |               | Median => 655   |                   |
# |                | 3rd-Qu => 40        |               | 3rd-Qu => 982.5 |                   |
# |                | Max    => 80        |               | Max    => 1309  |                   |
# +----------------+---------------------+---------------+-----------------+-------------------+
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
# +------+------+------------+--------------------------------------------------------------------+
# | Rows | Cols |    Item    |                               Title                                |
# +------+------+------------+--------------------------------------------------------------------+
# |  13  |  4   | Snow.pumps |    John Snow's Map and Data on the 1854 London Cholera Outbreak    |
# |  13  |  7   |    BCG     |                          BCG Vaccine Data                          |
# |  13  |  5   |   cement   |                  Heat Evolved by Setting Cements                   |
# |  13  |  2   |  kootenay  |   Waterflow Measurements of Kootenay River in Libby and Newgate    |
# |  13  |  5   | Newhouse77 | Medical-Care Expenditure: A Cross-National Survey (Newhouse, 1977) |
# |  13  |  2   |   Saxony   |                         Families in Saxony                         |
# +------+------+------------+--------------------------------------------------------------------+
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
# Geting the data first time took 0.693845313 seconds
```

```raku
$startTime = now;
$data = example-dataset( / 'COUNT::titanic' $/ ):keep;
$endTime = now;
say "Geting the data second time took { $endTime - $startTime } seconds";
```
```
# Geting the data second time took 0.711934937 seconds
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