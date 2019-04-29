#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
cd ..

node node_modules/.bin/wiki-mirror-content \
	https://codex.wordpress.org/ \
	~/cp/wp-codex/content/ \
	--subdirs \
	2>&1 \
	| tee archive.log

perl_code=$(cat <<'PL'
	use strict;

	my @files = `find content/ -type f -name '*.html'`;

	for my $file (@files) {
		chomp $file;

		print "stripping comments from $file\n";
		open HTML_R, '<', "$file"
			or die "Can't open $file: $!";
		open HTML_W, '>', "$file.tmp"
			or die "Can't open $file.tmp: $!";

		my $html = do {
			local $/ = undef;
			<HTML_R>;
		};
		$html =~ s/<!--.*-->//gs;

		print HTML_W $html;

		close HTML_R;
		close HTML_W;
		rename "$file.tmp", "$file";
	}
PL
)

perl -we "$perl_code"
