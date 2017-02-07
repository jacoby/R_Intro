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

use utf8 ;
binmode STDOUT, ':utf8' ;

# next step, add Getopt::Long into the mix
my $config_file = $ENV{HOME} . '/.twitter.cnf' ;
my $config      = LoadFile($config_file) ;
my $json        = JSON::XS->new->pretty ;

my $user = 'jacobydave' ;

# GET key and secret from http://twitter.com/apps
my $twit = Net::Twitter->new(
    traits          => [qw/API::RESTv1_1/],
    consumer_key    => $config->{consumer_key},
    consumer_secret => $config->{consumer_secret},
    ssl             => 1,
    ) ;

# You'll save the token and secret in cookie, config file or session database
my ( $access_token, $access_token_secret ) ;
( $access_token, $access_token_secret ) = restore_tokens($user) ;

if ( $access_token && $access_token_secret ) {
    $twit->access_token($access_token) ;
    $twit->access_token_secret($access_token_secret) ;
    }

unless ( $twit->authorized ) {

    # You have no auth token
    # go to the auth website.
    # they'll ask you if you wanna do this, then give you a PIN
    # input it here and it'll register you.
    # then save your token vals.

    say "Authorize this app at ", $twit->get_authorization_url,
        ' and enter the PIN#' ;
    my $pin = <STDIN> ;    # wait for input
    chomp $pin ;
    my ( $access_token, $access_token_secret, $user_id, $screen_name )
        = $twit->request_access_token( verifier => $pin ) ;
    save_tokens( $user, $access_token, $access_token_secret ) ;
    }

# my @list_of_lists = $twit->get_lists() ;
# say Dumper @list_of_lists ;
# my $list = '66780092' ; # greater lafayette
my $list = '66779514' ;    #perl

my @list = get_list_members( $twit, $list ) ;
my %list = map { $_ => 1 } @list ;
my $data ;

for my $japh (@list) {
    my @following = get_following( $twit, $japh ) ;
    say $japh ;
    for my $following (@following) {
        next unless $list{$following} ;
        say STDERR join "\t", ( $list{$following} ? 1 : 0 ), $following ;
        $data->{$japh}{$following} = 1 ;
        }
    }

if ( open my $fh, '>', 'output.json' ) {
    say $fh $json->encode($data) ;
    }

exit ;

#========= ========= ========= ========= ========= ========= =========
sub get_list_members {
    my ( $twit, $list ) = @_ ;
    my @list ;

    my $l      = 1 ;
    my $cursor = -1 ;
    while ( $l == 1 ) {
        my $members
            = $twit->list_members( { list_id => $list, cursor => $cursor } ) ;
        $cursor = $members->{next_cursor_str} ;
        my $users = $members->{users} ;
        my @users = map { $_->{id} } @$users ;
        push @list, @users ;
        $l = 0 if scalar @users < 20 ;
        }
    return @list ;
    }

#========= ========= ========= ========= ========= ========= =========
sub get_following {
    my ( $twit, $id ) = @_ ;
    my @list ;
    my $l      = 1 ;
    my $cursor = -1 ;
    while ( $l == 1 ) {
        my $followers
            = $twit->friends_ids( { id => $id, cursor => $cursor } ) ;
        $cursor = $followers->{next_cursor_str} ;
        my $users = $followers->{ids} ;
        my @users = @$users ;
        push @list, @users ;
        $l = 0 if scalar @users < 20 ;
        sleep 300 ;
        }
    return @list ;
    }

#========= ========= ========= ========= ========= ========= =========

sub restore_tokens {
    my ($user) = @_ ;
    my ( $access_token, $access_token_secret ) ;
    if ( $config->{tokens}{$user} ) {
        $access_token        = $config->{tokens}{$user}{access_token} ;
        $access_token_secret = $config->{tokens}{$user}{access_token_secret} ;
        }
    return $access_token, $access_token_secret ;
    }

sub save_tokens {
    my ( $user, $access_token, $access_token_secret ) = @_ ;
    $config->{tokens}{$user}{access_token}        = $access_token ;
    $config->{tokens}{$user}{access_token_secret} = $access_token_secret ;
    DumpFile( $config_file, $config ) ;
    return 1 ;
    }
