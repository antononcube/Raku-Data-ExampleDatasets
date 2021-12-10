use HTTP::UserAgent;
use Text::CSV;
use URL::Find;

#===========================================================

#| Get the dataset. Returns Positional[Hash] or Positional[Array].
our sub get-datasets-metadata(Str:D :$headers = 'auto', --> Positional) is export {

    my $csv = Text::CSV.new;
    my $fileHandle = %?RESOURCES<dfRDatasets.csv>;

    my @tbl = $csv.csv(in => $fileHandle.Str, :$headers);

    return @tbl;
}
#| Ingests the resource file "dfRDatasets.csv" of Data::ExampleDatasets.


#============================================================
# General / generic interface
#============================================================

#| Imports CSV files or URLs with CSV data.
sub import-csv-to-dataset(Str $source, *%args) is export {
    if find-urls($source) {

        # Get the URL content
        my $content = get-url-data($source, timeout => %args<timeout> // 10);

        # Ingest it
        return csv-string-to-dataset($content, sep => %args<sep> // ',', headers => %args<headers> // True)

    } else {

        # Get the metadata (hopefully not too slow)
        my @dfMeta = get-datasets-metadata();

        # Make a search index
        my %items = @dfMeta.map({ $_<Item> }) Z=> ^@dfMeta.elems;

        # Retrieve if known
        if %items{$source}:exists {
            return import-csv-to-dataset(@dfMeta[%items{$source}]<CSV>, |%args)
        } else {
            die "Unknown source."
        }
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

#| Parses a specified CSV string into array-of-hashmaps or array-of-arrays.
sub csv-string-to-dataset(Str $source, Str :$sep = ",", Bool :$headers= True) is export {

    my $csv = Text::CSV.new(:$sep);
    my @data = $source.lines;

    my @tbl;

    if $headers {
        my @header = $csv.getline(@data[0]);
        @tbl = do for @data[1 .. *- 1] -> $row {
            %( @header Z=> $csv.getline($row).list)
        }
    } else {
        @tbl = do for @data -> $row {
            $csv.getline($row).list
        }
    }

    return @tbl;
}
