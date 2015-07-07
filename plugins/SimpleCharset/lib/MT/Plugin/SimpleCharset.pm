package MT::Plugin::SimpleCharset;

use strict;
use warnings;
use Encode;

sub _convert {
    my ( $ref, $to, $from ) = @_;
    $to ||= MT->instance->config('PublishCharset');
    $from ||= MT->instance->config('PublishCharset');

    # Nothing to do if same
    return 1 if lc($to) eq lc($from);

    $$ref = Encode::encode_utf8($$ref) if Encode::is_utf8($$ref);
    Encode::from_to($$ref, $from, $to);

    1;
}

sub on_build_page {
    my ( $cb, %args ) = @_;

    # Arguments
    my $file = $args{file} || return 1;
    my $r = $args{content} || return 1;

    # File extension
    my ( $extension ) = $file =~ /\.(\w+)$/;
    return 1 unless $extension;

    # Extensions dictionary
    my $by_ext = MT->instance->config('CharsetByExt')
        || return 1;
    return 1 if $by_ext !~ /$extension/;

    my @pairs = split(/\s*;\s*/, $by_ext);
    my %extentions;
    foreach my $p ( @pairs ) {
        my ( $ext, $charset ) = split(/\s*:\s*/, $p, 2);

        # Convert charset
        if ( $ext and $charset and $ext eq $extension ) {
            _convert($r, $charset);
            return 1;
        }
    }

    1;
}

sub tag_charset {
    my ( $ctx, $args, $cond ) = @_;

    # Build and convert
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    defined ( my $out = $builder->build($ctx, $tokens, $cond) )
        || return $ctx->error($builder->errstr);

    _convert(\$out, $args->{to}, $args->{from});

    $out;
}

1;