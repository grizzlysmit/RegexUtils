class RegexUtils:ver<0.1.4>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)> {

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
=item1 L<CreatePerlRegex(…)|#createperlregex>
=item1 L<CreateEMCA262Regex(…)|#createemca262regex>

=NAME Gzz::Text::Utils 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION v0.1.4
=TITLE RegexUtils
=SUBTITLE A Raku module that provides helpers for Regex stuff both Perl5 and EMCA262Regex

=COPYRIGHT
LGPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/RegexUtils/blob/main/LICENSE>

=head1 Introduction

A B<Raku> module that provides helpers for B<C<Regex>> stuff both B<C<Perl5>> and B<C<EMCA262Regex>>.

L<Top of Document|#table-of-contents>

=head2 Motivations

I have a program which exists as a B<C<Mod_Perl>> web program,and a B<Raku> command line version.
The B<C<Mod_Perl>> version also uses B<JavaScript> and <JavaScript/EMCA> regexes I found that there 
was an all most perfect solution for the use of these regexes in the B<C<EMCA262Regex>> module, but
I still needed to convert the strings to regexes as I wanted to add options, 
B<C<RegexUtils::CreateEMCA262Regex>> is my solution to this problem I then added
B<C<RegexUtils::CreatePerlRegex>> for doing the same for B<Perl5> regexes.

L<Top of Document|#able-of-contents>

=end pod

use ECMA262Regex;

    grammar FlagsPerl5Modern {
        token TOP   { <flags> }
        token flags { <flag>+ % ':' }
        token flag  {  \w+ }
    }

    class FlagsPerl5ModernActions {
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

    grammar FlagsEMCA262Modern {
        token TOP   { <flags> }
        token flags { <flag>+ % ':' }
        token flag  {  \w+ }
    }

    class FlagsEMCA262ModernActions {
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

    grammar FlagsPerl5Old {
        token TOP   { <flags> }
        token flags { <flag>+ % <ww> }
        token flag  { \w }
    }

    class FlagsPerl5OldActions {
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

    grammar FlagsEMCA262Old {
        token TOP   { <flags> }
        token flags { <flag>+ % <ww> }
        token flag  { \w }
    }

    class FlagsEMCA262OldActions {
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
    } # method get-modern-emca262-flags(Str:D $flags --> Str:D) #

    method get-old-emca262-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsEMCA262OldActions;
        my $match   = RegexUtils::FlagsEMCA262Old.parse($flags, :$actions);
        without $match {
            die "invalid flags $flags";
        }
        return $match.made;
    } # method get-old-perl5-flags(Str:D $flags --> Str:D) #

=begin pod

=head3 CreatePerlRegex(…)

Creates a Perl5 regex from a string with some options suported.

B<Note:> not all raku flags are supported due to diffrences
between the flags in the two languages.

Here is some exaple use.

=begin code :lang<raku>

[0] > use RegexUtils;
Nil
[1] > my $regex-perl5 = RegexUtils.CreatePerlRegex('^fo+\n$', ':ignorecase');
rx:Perl5:ignorecase/^fo+\n$/
[2] > so 'Fooo' ~~ $regex-perl5;
False
[3] > so "Fooo\n" ~~ $regex-perl5;
True
[4] > say $regex-perl5;
rx:Perl5:ignorecase/^fo+\n$/

=end code

=end pod

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

=begin pod

=head3 CreateEMCA262Regex(…)

Creates a regex from a string containing a EMCA262Regex with some options suported.

B<C<CreateEMCA262Regex>> converts a B<EMCA262 Regex> to a raku one. using the
L<EMCA262Regex|https://modules.raku.org/dist/ECMA262Regex:zef:zef:jnthn> package 
and applies flags to it.

Here is some exaple use.

=begin code :lang<raku>

[0] > use RegexUtils;
Nil
[1] > my $regex-emca = RegexUtils.CreateEMCA262Regex('^[f][o]+\n', ':ignorecase');
rx:ignorecase/^<[f]><[o]>+\n/
[2] > so "Fooo\n" ~~ $regex-emca;
True
[3] > so " Fooo\n" ~~ $regex-emca;
False

=end code

B<Note:> C<ignorecase> only works for cases  like below due to how B<C<EMCA262Regex>>
translates the charater constants, this is a problem that needs solving.

e.g. 

=begin code :lang<raku>

[0] > use RegexUtils;
Nil
[1] > my $regex-emca = RegexUtils.CreateEMCA262Regex('^fo+\n', ':ignorecase');
rx:ignorecase/^\x66\x6F+\n/
[2] > so "Fooo\n" ~~ $regex-emca;
False

=end code

=end pod

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
