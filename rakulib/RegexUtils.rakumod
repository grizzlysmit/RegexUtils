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
=item1 L<Grammars|#grammars>
=item2 L<grammar FlagsPerl5Modern & action class FlagsPerl5ModernActions|#grammar-flagsperl5modern--action-class-flagsperl5modernactions>
=item2 L<grammar FlagsEMCA262Modern & action class FlagsEMCA262ModernActions|#grammar-flagsemca262modern--action-class-flagsemca262modernactions>
=item2 L<grammar FlagsPerl5Old & action class FlagsPerl5OldActions|#grammar-flagsperl5old--action-class-flagsperl5oldactions>
=item2 L<grammar FlagsEMCA262Old & action class FlagsEMCA262OldActions|#grammar-flagsemca262old--action-class-flagsemca262oldactions>
=item1 L<Methods|#methods>
=item2 L<CreatePerlRegex(…)|#createperlregex>
=item2 L<CreateEMCA262Regex(…)|#createemca262regex>
=item2 L<get-modern-perl5-flags(…)|#get-modern-perl5-flags>
=item2 L<get-old-perl5-flags(…)|#get-old-perl5-flags>
=item2 L<get-modern-emca262-flags(…)|#get-modern-emca262-flags>
=item2 L<get-old-emca262-flags(…)|#get-old-emca262-flags>

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

=head2 Grammars

=end pod

use ECMA262Regex;

=begin pod

=head3 grammar FlagsPerl5Modern & action class FlagsPerl5ModernActions

Support for using a limited range of flags for use with Perl 5 style regexes, 
using B<Raku's> style of regex flags.

=begin code :lang<raku>

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

=end code

=end pod

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

=begin pod

=head3 grammar FlagsEMCA262Modern & action class FlagsEMCA262ModernActions

A grammar and action pair to parse modern style B<Raku> flags and get rid of 
ones that do not fit with ECMA regexes.

=begin code :lang<raku>

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

=end code

=end pod

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

=begin pod

=head3 grammar FlagsPerl5Old & action class FlagsPerl5OldActions

A grammar and action pair to parse old style B<Perl> flags into modern 
B<Raku> flags.

=begin code :lang<raku>

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

=end code

=end pod

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

=begin pod

=head3 grammar FlagsEMCA262Old & action class FlagsEMCA262OldActions

A grammar and action pair to convert B<ECMA262Regex> flags into B<Raku> ones

=begin code :lang<raku>

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

=end code

=end pod

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
    } # method get-old-emca262-flags(Str:D $flags --> Str:D) #

=begin pod

=head2 Methods

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

L<Top of Document|#table-of-contents>

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

L<Top of Document|#table-of-contents>

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

=begin pod

=head3 get-modern-perl5-flags(…)

A method to apply the B<C<RegexUtils::FlagsPerl5Modern>> grammar to a string, 
in order to filter flags.

=begin code :lang<raku>

method get-modern-perl5-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsPerl5ModernActions;
    my $match   = RegexUtils::FlagsPerl5Modern.parse($flags.substr(1), :$actions);
    without $match {
        die "invalid flags";
    }
    return $match.made;
} # method get-modern-perl5-flags(Str:D $flags --> Str:D) #

=end code


=head3 get-old-perl5-flags(…)

Translate old style B<Perl> flags into B<Raku> ones using the grammar action pair

=begin code :lang<raku>

method get-old-perl5-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsPerl5OldActions;
    my $match   = RegexUtils::FlagsPerl5Old.parse($flags, :$actions);
    without $match {
        die "invalid flags $flags";
    }
    return $match.made;
} # method get-old-perl5-flags(Str:D $flags --> Str:D) #

=end code

=head3 get-modern-emca262-flags(…)

Filter modern flags for use with B<EMCA262Regex's>.

=begin code :lang<raku>

method get-modern-emca262-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsEMCA262ModernActions;
    my $match   = RegexUtils::FlagsEMCA262Modern.parse($flags.substr(1), :$actions);
    without $match {
        die "invalid flags";
    }
    return $match.made;
} # method get-modern-emca262-flags(Str:D $flags --> Str:D) #

=end code

=head3 get-old-emca262-flags(…)

Translate old style B<EMCA262Regex> flags into B<Raku> ones.

=begin code :lang<raku>

method get-old-emca262-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsEMCA262OldActions;
    my $match   = RegexUtils::FlagsEMCA262Old.parse($flags, :$actions);
    without $match {
        die "invalid flags $flags";
    }
    return $match.made;
} # method get-old-emca262-flags(Str:D $flags --> Str:D) #

=end code

=end pod
