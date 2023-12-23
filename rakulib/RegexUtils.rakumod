unit module RegexUtils:ver<0.1.4>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

=begin pod

=begin head2

Table of  Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>
=item2 L<Motivations|#motivations>
=item1 L<Introduction|#introduction>
=item1 L<Introduction|#introduction>
=item1 L<Introduction|#introduction>
=item1 L<Introduction|#introduction>

=NAME Gzz::Text::Utils 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION v0.1.18
=TITLE Gzz::Text::Utils
=SUBTITLE A Raku module to provide text formatting services to Raku programs.

=COPYRIGHT
LGPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/RegexUtils/blob/main/LICENSE>

=head1 Introduction

A Raku module to provide text formatting services to Raku programs.

Including a sprintf front-end Sprintf that copes better with Ansi highlighted
text and implements B<C<%U>> and does octal as B<C<0o123>> or B<C<0O123>> if
you choose B<C<%O>> as I hate ambiguity like B<C<0123>> is it an int with
leading zeros or an octal number.
Also there is B<C<%N>> for a new line and B<C<%T>> for a tab helpful when
you want to use single quotes to stop the B«<num> C«$»» specs needing back slashes.

And a B<C<printf>> alike B<C<Printf>>.

Also it does centring and there is a B<C<max-width>> field in the B<C<%>> spec i.e. B<C<%*.*.*E>>, 
and more.

L<Top of Document|#table-of-contents>

=head2 Motivations

When you embed formatting information into your text such as B<bold>, I<italics>, etc ... and B<colours>
standard text formatting will not work e.g. printf, sprintf etc also those functions don't do centring.

Another important thing to note is that even these functions will fail if you include such formatting
in the B<text> field unless you supply a copy of the text with out the formatting characters in it 
in the B<:ref> field i.e. B<C<left($formatted-text, $width, :ref($unformatted-text))>> or 
B<C<text($formatted-text, $width, :$ref)>> if the reference text is in a variable called B<C<$ref>>
or you can write it as B«C«left($formatted-text, $width, ref => $unformatted-text)»»

L<Top of Document|#able-of-contents>

=head3 Update

Fixed the proto type of B<C<left>> etc is now 

=begin code :lang<raku>
sub left(Str:D $text, Int:D $width is copy, Str:D $fill = ' ',
            :&number-of-chars:(Int:D, Int:D --> Bool:D) = &left-global-number-of-chars,
               Str:D :$ref = strip-ansi($text), Int:D
                                :$max-width = 0, Str:D :$ellipsis = '' --> Str) is export 
=end code

Where B«C«sub strip-ansi(Str:D $text --> Str:D) is export»» is my new function for striping out ANSI escape sequences so we don't need to supply 
B<C<:$ref>> unless it contains codes that B«C«sub strip-ansi(Str:D $text --> Str:D) is export»» cannot strip out, if so I would like to know so
I can update it to cope with these new codes.

L<Top of Document|#table-of-contents>

=end pod

use ECMA262Regex;

grammar RegexUtils::FlagsPerl5Modern {
    token TOP   { <flags> }
    token flags { <flag>+ % ':' }
    token flag  {  \w+ }
}

class RegexUtils::FlagsPerl5ModernActions {
    method TOP($/) { make $<flags>.made }
    method flag($/) {
        given ~$/ {
            when 'i'          {
                                  make ':ignorecase';
                              }
            when 'ignorecase' {
                                  make ':ignorecase';
                              }
            when 'm'          { make ':ignoremark'; }
            when 'ignoremark' { make ':ignoremark'; }
            when 's'          { make ':sigspace';   }
            when 'sigspace'   { make ':sigspace';   }
            default:          { make '';            }
        } 
    }
    method flags($/) {
        my $made-elts = $<flag>».made.join('');
        make $made-elts;
    }
}

grammar RegexUtils::FlagsEMCA262Modern {
    token TOP   { <flags> }
    token flags { <flag>+ % ':' }
    token flag  {  \w+ }
}

class RegexUtils::FlagsEMCA262ModernActions {
    method TOP($/) { make $<flags>.made }
    method flag($/) {
        given ~$/ {
            when 'i'          {
                                  make ':ignorecase';
                              }
            when 'ignorecase' {
                                  make ':ignorecase';
                              }
            when 'g'          { make ':global';     }
            when 'global'     { make ':global';     }
            default:          { make '';            }
        } 
    }
    method flags($/) {
        my $made-elts = $<flag>».made.join('');
        make $made-elts;
    }
}

grammar RegexUtils::FlagsPerl5Old {
    token TOP   { <flags> }
    token flags { <flag>+ % <ww> }
    token flag  { \w }
}

class RegexUtils::FlagsPerl5OldActions {
    method TOP($/) { make $<flags>.made }
    method flag($/) {
        given ~$/ {
            when 'i'          { make ':ignorecase'; }
            when 'm'          { make ':ignoremark'; }
            when 'g'          { make ':global';     }
            when 'x'          { make ':sigspace';   }
            default:          { make '';            }
        }
    }
    method flags($/) {
        my $made-elts = $/<flag>».made.join('');
        make $made-elts;
    }
}

grammar RegexUtils::FlagsEMCA262Old {
    token TOP   { <flags> }
    token flags { <flag>+ % <ww> }
    token flag  { \w }
}

class RegexUtils::FlagsEMCA262OldActions {
    method TOP($/) { make $<flags>.made }
    method flag($/) {
        given ~$/ {
            when 'i'          { make ':ignorecase'; }
            when 'g'          { make ':global';   }
            default:          { make '';            }
        }
    }
    method flags($/) {
        my $made-elts = $/<flag>».made.join('');
        make $made-elts;
    }
}

class RegexUtils {

    method get-modern-perl5-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsPerl5ModernActions;
        my $match   = RegexUtils::FlagsPerl5Modern.parse($flags.substr(1), :$actions);
        without $match {
            die "invalid flags";
        }
        return $match.made;
    } # method get-modern-perl5-flags(Str:D $flags --> Str:D) #

    method get-old-perl5-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsPerl5OldActions;
        my $match   = RegexUtils::FlagsPerl5Old.parse($flags, :$actions);
        without $match {
            die "invalid flags $flags";
        }
        return $match.made;
    } # method get-old-perl5-flags(Str:D $flags --> Str:D) #

    method get-modern-emca262-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsEMCA262ModernActions;
        my $match   = RegexUtils::FlagsEMCA262Modern.parse($flags.substr(1), :$actions);
        without $match {
            die "invalid flags";
        }
        return $match.made;
    } # method get-modern-perl5-flags(Str:D $flags --> Str:D) #

    method get-old-emca262-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsEMCA262OldActions;
        my $match   = RegexUtils::FlagsEMCA262Old.parse($flags, :$actions);
        without $match {
            die "invalid flags $flags";
        }
        return $match.made;
    } # method get-old-perl5-flags(Str:D $flags --> Str:D) #

    method CreatePerlRegex(Str:D $rg, Str:D $flags is copy = '') {
        $flags .=trim;
        if $flags.starts-with(':') {
            $flags = self.get-modern-perl5-flags($flags);
        } elsif $flags ne '' {
            $flags = self.get-old-perl5-flags($flags);
        }
        without $flags {
            $flags = '';
        }
        use MONKEY-SEE-NO-EVAL;
        my Regex:D $rx = EVAL "rx:Perl5$flags/$rg/";
        return $rx;
    }
    method CreateEMCA262Regex(Str:D $str, Str:D $flags is copy = '' --> Regex:D) {
        $flags .=trim;
        if $flags.starts-with(':') {
            $flags = self.get-modern-emca262-flags($flags);
        } elsif $flags ne '' {
            $flags = self.get-old-emca262-flags($flags);
        }
        without $flags {
            $flags = '';
        }
        my Str:D $rg = ECMA262Regex.as-perl6($str);
        use MONKEY-SEE-NO-EVAL;
        my Regex:D $rx = EVAL "rx$flags/$rg/";
        return $rx;
    }
}
