#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent; # HTTP client
use Compress::Zlib; # bzip decoder

my $BASELINE = 'baseline.html';
my $MODIFIED = 'modified.html';

# Writes to the open file.
sub writeToFile {
	my $URL = shift;
	my $content = shift;
	my $filename = shift;
	open(my $fh, '>', "$filename") or die "Can't open $filename";
	print $fh $content;
	close($fh);
}

# Get the html from a web page and store in the contentAddr variable
sub getHTML {
	my $URL = shift @_;
	my $contentAddr = shift @_;
	my $ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0 (X11; Linux x86_64)'); # Prevent user-agent blocking
	my $can_accept = HTTP::Message::decodable; # Accept gzip
	my $response = $ua->get("$URL", 'Accept-Encoding' => $can_accept,); 
	${$contentAddr} = $response->decoded_content; # Store in 
}

########
# MAIN #
########

my $content = "";
my $baselineHTML = "";
my $counter = 0;

# Get the first parameter
my $URL = shift;

while (1){
	printf "($counter) Fetching webpage... $URL : ";
	getHTML($URL, \$content);
	
	# If first iteration
	if ($baselineHTML eq ""){
		writeToFile($URL, $content, $BASELINE);	
		open FILE, "$BASELINE" or die "Couldn't open file: $!";
		binmode FILE;
		local $/;
		$baselineHTML = <FILE>;
		close FILE;
	}
	
	if ($content ne $baselineHTML){
		printf "Dumping...\n";
		writeToFile($URL, $content, $MODIFIED);
		exit 0;
	} else {
		printf "Matched. Sleeping...\n";
		sleep(60);
	}
	$counter += 1;
}

exit 1
