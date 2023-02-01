use v6;
use ECMA262Regex;

grammar RegexUtils::FlagsModern {
    token TOP   { <flags> }
    token flags { <flag>+ % ':' }
    token flag  {  \w+ }
}

class RegexUtils::FlagsModernActions {
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

grammar RegexUtils::FlagsOld {
    token TOP   { <flags> }
    token flags { <flag>+ % <ww> }
    token flag  { \w }
}

class RegexUtils::FlagsOldActions {
    method TOP($/) { make $<flags>.made }
    method flag($/) {
        given ~$/ {
            when 'i'          { make ':ignorecase'; }
            when 'm'          { make ':ignoremark'; }
            when 'x'          { make ':sigspace';   }
            default:          { make '';            }
        }
    }
    method flags($/) {
        my $made-elts = $/<flag>».made.join('');
        make $made-elts;
    }
}

class RegexUtils {

    method get-modern-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsModernActions;
        my $match   = RegexUtils::FlagsModern.parse($flags.substr(1), :$actions);
        without $match {
            die "invalid flags";
        }
        return $match.made;
    } # method get-modern-flags(Str:D $flags --> Str:D) #

    method get-old-flags(Str:D $flags --> Str:D) {
        my $actions = RegexUtils::FlagsOldActions;
        my $match   = RegexUtils::FlagsOld.parse($flags, :$actions);
        without $match {
            die "invalid flags $flags";
        }
        return $match.made;
    } # method get-old-flags(Str:D $flags --> Str:D) #

    method CreatePerlRegex(Str:D $rg, Str:D $flags is copy = '') {
        $flags .=trim;
        if $flags.starts-with(':') {
            $flags = self.get-modern-flags($flags);
        } else {
            $flags = self.get-old-flags($flags);
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
            $flags = self.get-modern-flags($flags);
        } else {
            die "flags must be modern";
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
