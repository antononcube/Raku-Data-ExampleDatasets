use HTTP::UserAgent;
use Text::CSV;
use URL::Find;
use XDG::BaseDirectory :terms;

unit module Data::ExampleDatasets;

#===========================================================

# See the BEGIN blocks below.
my @metadataDataset;
my %packageItemToCSV;
my %packageItemToDOC;

#===========================================================
#| Get item to CSV URL data mapping.
sub get-item-to-csv-url(-->Hash) is export {

    if so %packageItemToCSV {
        return %packageItemToCSV;
    } else {
        my $temp = get-datasets-metadata().map({  $_.grep({ $_.key (elem) <Package Item CSV> }).Hash });
        %packageItemToCSV = $temp.map({ $_<Package> ~ '::' ~ $_<Item> => $_<CSV> }).Hash;
        return %packageItemToCSV;
    }
}

#| Get item to DOC URL data mapping.
sub get-item-to-doc-url(-->Hash) is export {

    if so %packageItemToDOC {
        return %packageItemToDOC;
    } else {
        my $temp = get-datasets-metadata().map({  $_.grep({ $_.key (elem) <Package Item Doc> }).Hash });
        %packageItemToDOC = $temp.map({ $_<Package> ~ '::' ~ $_<Item> => $_<Doc> }).Hash;
        return %packageItemToDOC;
    }
}


#===========================================================
#| Get the dataset. Returns Array[Hash] or Array[Array].
our sub get-datasets-metadata(Bool :$deepcopy = False --> Array) is export {

    if so @metadataDataset {
        return $deepcopy ?? @metadataDataset.deepmap(*.clone) !! @metadataDataset;
    } else {

        my $fileHandle = %?RESOURCES<dfRdatasets.csv>;

        # Instead of just calling the following line let us delegate to
        # my @tbl = $csv.csv(in => $fileHandle.Str, :$headers);
        my $content = slurp $fileHandle;
        @metadataDataset = csv-string-to-dataset($content);
        return $deepcopy ?? @metadataDataset.deepmap(*.clone) !! @metadataDataset;

        ## It 7-10 faster to use this ad-hoc code than the standard Text::CSV workflow.
        ## But in order to use it the separator in the CSV file has to be changed. (Some titles have commas in them.)
        ## Note that these points are mute, since we optimize with BEGIN. (See end of file.)
        #my @colNames = ["Package", "Item", "Title", "Rows", "Cols", "n_binary", "n_character", "n_factor", "n_logical", "n_numeric", "CSV", "Doc"];
        #my $fileHandle = %?RESOURCES<dfRDatasets.csv>;
        #my Str @metaRecords = $fileHandle.lines;
        #my @tbl = @metaRecords[1 .. *- 1].map({ %( @colNames Z=> $_.split(',')) });
        #
        #return @tbl
    }
}
#| Ingests the resource file "dfRDatasets.csv" of Data::ExampleDatasets.


#============================================================
# General / generic interface
#============================================================

#| Imports CSV files or URLs with CSV data.
sub example-dataset($sourceSpec = Whatever, Bool :$keep = False, *%args --> List) is export {
    if $sourceSpec ~~ Str and find-urls($sourceSpec) {

        # Get the URL content
        my $content = get-url-data($sourceSpec, timeout => %args<timeout> // 10);

        # It would have been nice to 'just' call the Text::CSV function csv,
        # but since many of the R data sets have row names column with an empty
        # first field in the header, csv complains/fails.
        # Also, Text::CSV does not have types and automatic type detection yet.
        # Hence, I have to have my own parsing function, csv-string-to-dataset.
        # my %args2 = %args;
        # %args2<timeout>:delete;
        # return csv(in=> [|$content], |%args2)

        # Ingest it
        return csv-string-to-dataset($content, |%args)

    } else {

        # Get the metadata (hopefully not too slow)
        # my @dfMeta = get-datasets-metadata();

        # Make a search index
        #my %items = @dfMeta.map({ $_<Item> }) Z=> ^@dfMeta.elems;
        my %itemToURLs = get-item-to-csv-url();

        # Retrieve if known or Whatever
        my %catRes;
        if $sourceSpec.isa(Whatever) or  $sourceSpec.isa(WhateverCode) {

            my $rx = %itemToURLs.keys.pick ~ ' $';
            return example-dataset( $rx, :$keep, |%args)

        } elsif $sourceSpec ~~ Str {

            if not so $sourceSpec.contains(':') {

                %catRes = %itemToURLs.categorize({ so $_.key ~~ / .* '::' $sourceSpec / });

            } elsif so $sourceSpec ~~ / .* '::' .* / {

                my $rx = $sourceSpec.split('::').join('..');

                %catRes = %itemToURLs.categorize({ so $_.key ~~ / <$rx> / });

            } else {

                %catRes = %itemToURLs.categorize({ so $_.key ~~ / <$sourceSpec> / });

            }

        } elsif $sourceSpec ~~ Regex {
            %catRes = %itemToURLs.categorize({ so $_.key ~~ $sourceSpec });
        }

        if not %catRes{True}:exists {
            note 'No datasets found with the given source spec.';
            return Nil;
        } elsif %catRes{True}.elems > 1 {
            note "Found more than one dataset with the given spec: \n", %catRes{True}.join("\n");
            return Nil;
        }

        my $csvURL = %catRes{True}.first.value;
        my $datasetName = $csvURL ~~ / '/' (<.alnum>+) '.csv' /;
        $datasetName = $datasetName.values.Str;

        my $dirName = data-home.Str ~ '/raku/Data/ExampleDatasets';
        my $fname = $dirName ~ '/' ~ %catRes{True}[0].key ~ '.csv';

        if $keep and not $dirName.IO.e {
            my $path = IO::Path.new($dirName);
            if not mkdir($path) {
                die "Cannot create the directory: $dirName."
            }
        }

        if $fname.IO.e {
            my $content = slurp $fname;
            return csv-string-to-dataset($content, |%args)
        }

        my @res = example-dataset($csvURL, |%args);

        if $keep {
            # Write to a CSV file in the resources directory
            csv(in => @res, out => $fname, sep => ',');
        }

        return @res;

    }
}

#============================================================
# Get data from a URL
#============================================================

#| Gets the data from a specified URL.
sub get-url-data(Str $url, UInt :$timeout= 10) is export {
    my $ua = HTTP::UserAgent.new;
    $ua.timeout = $timeout;

    my $response = $ua.get($url);

    if not $response.is-success {
        # say $response.content.WHAT;
        die $response.status-line;
    }
    return  $response.content
}

#============================================================
# Parse CSV string to dataset
#============================================================
# Take from https://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Raku
multi is-number-w-ws(Str $term --> Bool) {
    try { $term.Numeric };
    $! ?? False !! True
}
multi is-number-w-ws(Numeric $field --> Bool) { True }
multi is-number-w-ws(| --> Bool) { False }

sub is-number-wo-ws(Str $term --> Bool) {
    ?($term ~~ / \S /) && $term.Numeric !~~ Failure;
}

#| Parses a specified CSV string into array-of-hashmaps or array-of-arrays.
sub csv-string-to-dataset(Str $source, :@na-symbols = ['NA'], Bool :$no-nameless = True, *%args --> Array) is export {

    my %args2 = %args;
    %args2<headers>:delete;
    %args2<types>:delete;
    %args2<auto-types>:delete;
    my $csv = Text::CSV.new(|%args2);
    my @data = $source.lines;

    # Types is not implemented yet
    if %args<types>:exists {
        note 'Text::CSV does not have an implementation of types setting yet.';
        # $csv.types(|%args<types>)
    }
    my @tbl;

    if %args<headers> // True {
        my @header = $csv.getline(@data[0]);
        @tbl = do for @data[1 .. *- 1] -> $row {
            # This is an MVP solution to automatic types.
            # But it might just good enough, since at R datasets have columns with the same type.
            my @parsedRow = do if %args<auto-types> // True {
                $csv.getline($row).List.map({ is-number-w-ws($_) ?? $_.Numeric !! $_ }).List
            } else {
                $csv.getline($row).List;
            }
            %( @header Z=> @parsedRow)
        }
    } else {
        @tbl = do for @data -> $row {
            # This is an MVP solution to automatic types.
            if %args<auto-types> // True {
                $csv.getline($row).List.map({ (so is-number-w-ws($_)) ?? $_.Numeric !! $_ }).List
            } else {
                $csv.getline($row).List;
            }
        }
    }

    # Drop empty first column
    if $no-nameless {
        @tbl = @tbl.map({ $_.grep({ .key ne '' }).hash }).Array
    }

    # Process NA's
    if @na-symbols.elems > 0 {
        @tbl = @tbl.deepmap({ $_ (elem) @na-symbols ?? Nil !! $_ });
    }

    return @tbl;
}

#============================================================
# Optimization
#============================================================
@metadataDataset = BEGIN { get-datasets-metadata() }

%packageItemToCSV = BEGIN { get-item-to-csv-url() }

%packageItemToDOC = BEGIN { get-item-to-doc-url() }
