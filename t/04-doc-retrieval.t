use Test;

use lib './lib';
use lib '.';

use Data::ExampleDatasets;

plan 3;

## 1
isa-ok get-item-to-doc-url(), Hash, 'all doc URLs';

## 2
is get-item-to-doc-url().keys.grep(/ .* iris /).sort,
        <datasets::iris datasets::iris3>,
        'expected keys';

## 3
ok get-item-to-doc-url()<datasets::iris3>, 'direct retrieval';

done-testing;
