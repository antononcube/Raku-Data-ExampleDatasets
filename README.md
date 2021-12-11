# Data::ExampleDatasets Raku package

Raku package for (obtaining) example datasets.

Currently this repository does contains only [datasets metadata](./resources/dfRdatasets.csv).
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
# +---+-----------+-----------+-------------+-------------+-------------+-------+
# |   | pretest.1 | pretest.2 | post.test.3 | post.test.1 | post.test.2 | group |
# +---+-----------+-----------+-------------+-------------+-------------+-------+
# | 1 |     4     |     3     |      41     |      5      |      4      | Basal |
# | 2 |     6     |     5     |      41     |      9      |      5      | Basal |
# | 3 |     9     |     4     |      43     |      5      |      3      | Basal |
# | 4 |     12    |     6     |      46     |      8      |      5      | Basal |
# | 5 |     16    |     5     |      46     |      10     |      9      | Basal |
# | 6 |     15    |     13    |      45     |      9      |      8      | Basal |
# +---+-----------+-----------+-------------+-------------+-------------+-------+
```

Here we summarize the dataset obtained above:

```perl6
records-summary(@tbl)
```
```
# +--------------------+-------------+--------------------+--------------------+----------------+--------------------+---------------------+
# | pretest.2          | group       | post.test.1        | post.test.2        |                | pretest.1          | post.test.3         |
# +--------------------+-------------+--------------------+--------------------+----------------+--------------------+---------------------+
# | Min    => 1        | Strat => 22 | Min    => 1        | Min    => 0        | Min    => 1    | Min    => 4        | Min    => 30        |
# | 1st-Qu => 3        | DRTA  => 22 | 1st-Qu => 5        | 1st-Qu => 5        | 1st-Qu => 17   | 1st-Qu => 8        | 1st-Qu => 40        |
# | Mean   => 5.106061 | Basal => 22 | Mean   => 8.075758 | Mean   => 6.712121 | Mean   => 33.5 | Mean   => 9.787879 | Mean   => 44.015152 |
# | Median => 5        |             | Median => 8        | Median => 6        | Median => 33.5 | Median => 9        | Median => 45        |
# | 3rd-Qu => 6        |             | 3rd-Qu => 11       | 3rd-Qu => 8        | 3rd-Qu => 50   | 3rd-Qu => 12       | 3rd-Qu => 49        |
# | Max    => 13       |             | Max    => 15       | Max    => 13       | Max    => 66   | Max    => 16       | Max    => 57        |
# +--------------------+-------------+--------------------+--------------------+----------------+--------------------+---------------------+
```

**Remark**: The known identifiers are from the GitHub repository "Rdatasets", [VAB1].
See the datasets metadata sub-section below.


### Get a dataset by using an URL

Here we get a dataset by using an URL and display a summary of the obtained dataset:

```perl6
my $url = 'https://raw.githubusercontent.com/antononcube/Raku-Data-Reshapers/main/resources/dfTitanic.csv';
my @tbl2 = example-dataset($url, :headers);
records-summary(@tbl2);
```
```
# +----------------+---------------+-------------------+-----------------+---------------------+
# | passengerClass | passengerSex  | passengerSurvival | id              | passengerAge        |
# +----------------+---------------+-------------------+-----------------+---------------------+
# | 3rd => 709     | male   => 843 | died     => 809   | Min    => 1     | Min    => -1        |
# | 1st => 323     | female => 466 | survived => 500   | 1st-Qu => 327.5 | 1st-Qu => 10        |
# | 2nd => 277     |               |                   | Mean   => 655   | Mean   => 23.550038 |
# |                |               |                   | Median => 655   | Median => 20        |
# |                |               |                   | 3rd-Qu => 982.5 | 3rd-Qu => 40        |
# |                |               |                   | Max    => 1309  | Max    => 80        |
# +----------------+---------------+-------------------+-----------------+---------------------+
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
# +--------------------------------------------------------------------+------+------------+------+
# |                               Title                                | Rows |    Item    | Cols |
# +--------------------------------------------------------------------+------+------------+------+
# |    John Snow's Map and Data on the 1854 London Cholera Outbreak    |  13  | Snow.pumps |  4   |
# |                          BCG Vaccine Data                          |  13  |    BCG     |  7   |
# |                  Heat Evolved by Setting Cements                   |  13  |   cement   |  5   |
# |   Waterflow Measurements of Kootenay River in Libby and Newgate    |  13  |  kootenay  |  2   |
# | Medical-Care Expenditure: A Cross-National Survey (Newhouse, 1977) |  13  | Newhouse77 |  5   |
# |                         Families in Saxony                         |  13  |   Saxony   |  2   |
# +--------------------------------------------------------------------+------+------------+------+
```
------

## References

### Functions, repositories

[AAf1] Anton Antonov,
[`ExampleDataset`](https://resources.wolframcloud.com/FunctionRepository/resources/ExampleDataset),
(2020),
[Wolfram Function Repository](https://resources.wolframcloud.com/FunctionRepository).

[VAB1] Vincent Arel-Bundock,
[Rdatasets](https://github.com/vincentarelbundock/Rdatasets/),
(2020),
[GitHub/vincentarelbundock](https://github.com/vincentarelbundock).

### Interactive interfaces

[AAi1] Anton Antonov,
[Example datasets recommender interface](https://antononcube.shinyapps.io/ExampleDatasetsRecommenderInterface/),
(2021),
[Shinyapps.io](https://antononcube.shinyapps.io/).