use v6;
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
