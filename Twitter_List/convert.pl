#!/usr/bin/env perl

# largely taken verbatim from
# http://search.cpan.org/dist/Net-Twitter/lib/Net/Twitter/Role/OAuth.pm

# Next step is to get the keys and secrets to a config.

use feature qw{ say } ;
use strict ;
use Carp ;
use Data::Dumper ;
use Encode 'decode' ;
use IO::Interactive qw{ interactive } ;
use Net::Twitter ;
use WWW::Shorten 'TinyURL' ;
use YAML::XS qw{ DumpFile LoadFile } ;
use JSON::XS ;
use Text::CSV_XS qw{csv} ;

use utf8 ;
binmode STDOUT, ':utf8' ;

my $json = JSON::XS->new->pretty ;
my $in   = 'output.json' ;
my $out  = 'output.csv' ;
my $nf   = 'names.json' ;
my $names;
if ( open my $fh, '<', $nf ) { 
    my $input = join "\n", <$fh> ;
    $names = $json->decode($input) ;
    }

if ( open my $fh, '<', $in ) {
    my $input = join "\n", <$fh> ;
    my $obj = $json->decode($input) ;
    my $output ;
    my $array ;
    @$array = qw{from to val} ;
    push @$output, $array ;
    for my $k ( sort { $a <=> $b } keys %$obj ) {
        my $follows = $obj->{$k} ;
        for my $l ( sort { $a <=> $b } keys %$follows ) {
            my $v = $follows->{$l} ;
            my $array ;
            push @$array,  $names->{$k} ;
            push @$array,  $names->{$l} ;
            push @$array,  1 ;
            push @$output, $array ;
            }
        }
    say Dumper $output ;
    csv( in => $output, out => 'output.csv' ) ;
    }
else {
    say 'fail' ;
    }

exit ;

