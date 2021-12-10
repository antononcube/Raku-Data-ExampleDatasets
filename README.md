# Data::ExampleDatasets Raku package

Raku package for (obtaining) example datasets.

Currently this repository does not contains only [datasets metadata](./resources/dfRdatasets.csv).
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

### Get a dataset using identifier

Here we get a dataset by using an identifier and display part of it:

```perl6
my @tbl = example-dataset('Baumann', :headers);
say to-pretty-table(@tbl[^6]);
```
```
# +-------------+-------------+-------+-------------+-----------+-----------+---+
# | post.test.1 | post.test.2 | group | post.test.3 | pretest.1 | pretest.2 |   |
# +-------------+-------------+-------+-------------+-----------+-----------+---+
# |      5      |      4      | Basal |      41     |     4     |     3     | 1 |
# |      9      |      5      | Basal |      41     |     6     |     5     | 2 |
# |      5      |      3      | Basal |      43     |     9     |     4     | 3 |
# |      8      |      5      | Basal |      46     |     12    |     6     | 4 |
# |      10     |      9      | Basal |      46     |     16    |     5     | 5 |
# |      9      |      8      | Basal |      45     |     15    |     13    | 6 |
# +-------------+-------------+-------+-------------+-----------+-----------+---+
```

Here we summarize the dataset obtained above:

```perl6
records-summary(@tbl)
```
```
# +--------------------+--------------------+---------------------+----------------+-------------+--------------------+--------------------+
# | post.test.1        | pretest.2          | post.test.3         |                | group       | pretest.1          | post.test.2        |
# +--------------------+--------------------+---------------------+----------------+-------------+--------------------+--------------------+
# | Min    => 1        | Min    => 1        | Min    => 30        | Min    => 1    | Strat => 22 | Min    => 4        | Min    => 0        |
# | 1st-Qu => 5        | 1st-Qu => 3        | 1st-Qu => 40        | 1st-Qu => 17   | Basal => 22 | 1st-Qu => 8        | 1st-Qu => 5        |
# | Mean   => 8.075758 | Mean   => 5.106061 | Mean   => 44.015152 | Mean   => 33.5 | DRTA  => 22 | Mean   => 9.787879 | Mean   => 6.712121 |
# | Median => 8        | Median => 5        | Median => 45        | Median => 33.5 |             | Median => 9        | Median => 6        |
# | 3rd-Qu => 11       | 3rd-Qu => 6        | 3rd-Qu => 49        | 3rd-Qu => 50   |             | 3rd-Qu => 12       | 3rd-Qu => 8        |
# | Max    => 15       | Max    => 13       | Max    => 57        | Max    => 66   |             | Max    => 16       | Max    => 13       |
# +--------------------+--------------------+---------------------+----------------+-------------+--------------------+--------------------+
```

**Remark**: The known identifiers are from the GitHub repository "Rdatasets", [VAB1].


### Get a dataset using URL

Here we get a dataset by using an URL and display a summary of it:

```perl6
my $url = 'https://raw.githubusercontent.com/antononcube/Raku-Data-Reshapers/main/resources/dfTitanic.csv';
my @tbl2 = example-dataset($url, :headers);
records-summary(@tbl2);
```
```
# +---------------------+-----------------+----------------+---------------+-------------------+
# | passengerAge        | id              | passengerClass | passengerSex  | passengerSurvival |
# +---------------------+-----------------+----------------+---------------+-------------------+
# | Min    => -1        | Min    => 1     | 3rd => 709     | male   => 843 | died     => 809   |
# | 1st-Qu => 10        | 1st-Qu => 327.5 | 1st => 323     | female => 466 | survived => 500   |
# | Mean   => 23.550038 | Mean   => 655   | 2nd => 277     |               |                   |
# | Median => 20        | Median => 655   |                |               |                   |
# | 3rd-Qu => 40        | 3rd-Qu => 982.5 |                |               |                   |
# | Max    => 80        | Max    => 1309  |                |               |                   |
# +---------------------+-----------------+----------------+---------------+-------------------+
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
# +------+--------------------------------------------------------------------+------------+------+
# | Cols |                               Title                                |    Item    | Rows |
# +------+--------------------------------------------------------------------+------------+------+
# |  4   |    John Snow's Map and Data on the 1854 London Cholera Outbreak    | Snow.pumps |  13  |
# |  7   |                          BCG Vaccine Data                          |    BCG     |  13  |
# |  5   |                  Heat Evolved by Setting Cements                   |   cement   |  13  |
# |  2   |   Waterflow Measurements of Kootenay River in Libby and Newgate    |  kootenay  |  13  |
# |  5   | Medical-Care Expenditure: A Cross-National Survey (Newhouse, 1977) | Newhouse77 |  13  |
# |  2   |                         Families in Saxony                         |   Saxony   |  13  |
# +------+--------------------------------------------------------------------+------------+------+
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