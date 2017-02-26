#!/usr/bin/perl
#
# v.0.1
#

# Needs to Generate in a random order, two words, with a Capital in Each, mispelled, with a 2digit number and 1-3 Special Characters
#

use strict;
use List::Util qw/shuffle/;

our $cfg = {
	num_words => 2,
	word_file => '/usr/share/dict/words',
	word_regex => qr/(\w{6,8})/i,
	caps => 1 ,
	misspelled => 1,
       	digits => 1,
	digits_len => 2,
	num_digits => 1,
	chars => 1,
	chars_str => '~`!@#$%^&*-_=+\/.,;:|',
	chars_min => 1,
	chars_max => 3};



srand;
open RAW_WORDS, $cfg->{word_file};
our @words = map {($_ =~ $cfg->{word_regex}) ? $1: () } <RAW_WORDS>;
our $total_words = scalar @words;
sub get_tmpcfg(){
	my $tmp_cfg = {};
	foreach my $key (keys %{$cfg}){
		$tmp_cfg->{$key} = $cfg->{$key} if($key !~ /_(?:min|max)/);
	}
	#find num chars
	$tmp_cfg->{num_chars} = $cfg->{chars_min} + int(rand($cfg->{chars_max} - $cfg->{chars_min} + 1 ));
	return $tmp_cfg;
}

sub generate_password {
	## Takes no Args
	my $totals = {};
	##Make tmp_cfg
	my $tmp_cfg = get_tmpcfg();
	my @list = ();
	#Generate words
	my ($line,$snip,$capped,$len,$i,$j);
	for($i = 0; $i < $tmp_cfg->{num_words}; $i++){
		$line = int(rand($total_words));
		## replace some characters
		#
		$line =  $words[$line];
		$len = length $line;
		$j = int(rand($len));
		$snip = substr $line, $j, int(rand($len - $j));	
		$capped = $snip;
	        $capped =~ tr/a-zA-Z/A-Za-z/;
		$line = join ($capped, split($snip,$line));
		push @list, $line;
	}
	#Generate Number
	$line = '';
	for($i = 0; $i < $tmp_cfg->{num_digits}; $i++){
		for($j = 0; $j < $tmp_cfg->{digits_len}; $j++){
			$line .= int(rand(10));
		}
		push @list, $line;
	}
	#Generate Special Chars
	for($i = 0; $i < $tmp_cfg->{num_chars}; $i ++){
		$line = substr $tmp_cfg->{chars_str}, int(rand(length($tmp_cfg->{chars_str}))),1;
		push @list, $line;
	}
	@list = shuffle @list;
	print ((join "",@list)."\n");

}

my $num_password = ($ARGV[0] or 1);
for(my $i = 0; $i < $num_password; $i++){
	generate_password();
}



