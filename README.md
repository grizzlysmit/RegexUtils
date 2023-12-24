Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

  * [Introduction](#introduction)

    * [Motivations](#motivations)

  * [Grammars](#grammars)

    * [grammar FlagsPerl5Modern & action class FlagsPerl5ModernActions](#grammar-flagsperl5modern--action-class-flagsperl5modernactions)

    * [grammar FlagsEMCA262Modern & action class FlagsEMCA262ModernActions](#grammar-flagsemca262modern--action-class-flagsemca262modernactions)

    * [grammar FlagsPerl5Old & action class FlagsPerl5OldActions](#grammar-flagsperl5old--action-class-flagsperl5oldactions)

    * [grammar FlagsEMCA262Old & action class FlagsEMCA262OldActions](#grammar-flagsemca262old--action-class-flagsemca262oldactions)

  * [Methods](#methods)

    * [CreatePerlRegex(…)](#createperlregex)

    * [CreateEMCA262Regex(…)](#createemca262regex)

    * [get-modern-perl5-flags(…)](#get-modern-perl5-flags)

    * [get-old-perl5-flags(…)](#get-old-perl5-flags)

    * [get-modern-emca262-flags(…)](#get-modern-emca262-flags)

    * [get-old-emca262-flags(…)](#get-old-emca262-flags)

NAME
====

Gzz::Text::Utils 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

v0.1.4

TITLE
=====

RegexUtils

SUBTITLE
========

A Raku module that provides helpers for Regex stuff both Perl5 and EMCA262Regex

COPYRIGHT
=========

LGPL V3.0+ [LICENSE](https://github.com/grizzlysmit/RegexUtils/blob/main/LICENSE)

Introduction
============

A **Raku** module that provides helpers for **`Regex`** stuff both **`Perl5`** and **`EMCA262Regex`**.

[Top of Document](#table-of-contents)

Motivations
-----------

I have a program which exists as a **`Mod_Perl`** web program,and a **Raku** command line version. The **`Mod_Perl`** version also uses **JavaScript** and <JavaScript/EMCA> regexes I found that there was an all most perfect solution for the use of these regexes in the **`EMCA262Regex`** module, but I still needed to convert the strings to regexes as I wanted to add options, **`RegexUtils::CreateEMCA262Regex`** is my solution to this problem I then added **`RegexUtils::CreatePerlRegex`** for doing the same for **Perl5** regexes.

[Top of Document](#able-of-contents)

Grammars
--------

### grammar FlagsPerl5Modern & action class FlagsPerl5ModernActions

Support for using a limited range of flags for use with Perl 5 style regexes, using **Raku's** style of regex flags.

```raku
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
```

[Top of Document](#table-of-contents)

### grammar FlagsEMCA262Modern & action class FlagsEMCA262ModernActions

A grammar and action pair to parse modern style **Raku** flags and get rid of ones that do not fit with ECMA regexes.

```raku
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
```

[Top of Document](#table-of-contents)

### grammar FlagsPerl5Old & action class FlagsPerl5OldActions

A grammar and action pair to parse old style **Perl** flags into modern **Raku** flags.

```raku
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
```

[Top of Document](#table-of-contents)

### grammar FlagsEMCA262Old & action class FlagsEMCA262OldActions

A grammar and action pair to convert **ECMA262Regex** flags into **Raku** ones

```raku
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
```

[Top of Document](#table-of-contents)

Methods
-------

### CreatePerlRegex(…)

Creates a Perl5 regex from a string with some options suported.

**Note:** not all raku flags are supported due to diffrences between the flags in the two languages.

Here is some exaple use.

```raku
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
```

[Top of Document](#table-of-contents)

### CreateEMCA262Regex(…)

Creates a regex from a string containing a EMCA262Regex with some options suported.

**`CreateEMCA262Regex`** converts a **EMCA262 Regex** to a raku one. using the [EMCA262Regex](https://modules.raku.org/dist/ECMA262Regex:zef:zef:jnthn) package and applies flags to it.

Here is some exaple use.

```raku
[0] > use RegexUtils;
Nil
[1] > my $regex-emca = RegexUtils.CreateEMCA262Regex('^[f][o]+\n', ':ignorecase');
rx:ignorecase/^<[f]><[o]>+\n/
[2] > so "Fooo\n" ~~ $regex-emca;
True
[3] > so " Fooo\n" ~~ $regex-emca;
False
```

**Note:** `ignorecase` only works for cases like below due to how **`EMCA262Regex`** translates the charater constants, this is a problem that needs solving.

e.g. 

```raku
[0] > use RegexUtils;
Nil
[1] > my $regex-emca = RegexUtils.CreateEMCA262Regex('^fo+\n', ':ignorecase');
rx:ignorecase/^\x66\x6F+\n/
[2] > so "Fooo\n" ~~ $regex-emca;
False
```

[Top of Document](#table-of-contents)

### get-modern-perl5-flags(…)

A method to apply the **`RegexUtils::FlagsPerl5Modern`** grammar to a string, in order to filter flags.

```raku
method get-modern-perl5-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsPerl5ModernActions;
    my $match   = RegexUtils::FlagsPerl5Modern.parse($flags.substr(1), :$actions);
    without $match {
        die "invalid flags";
    }
    return $match.made;
} # method get-modern-perl5-flags(Str:D $flags --> Str:D) #
```

### get-old-perl5-flags(…)

Translate old style **Perl** flags into **Raku** ones using the grammar action pair

```raku
method get-old-perl5-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsPerl5OldActions;
    my $match   = RegexUtils::FlagsPerl5Old.parse($flags, :$actions);
    without $match {
        die "invalid flags $flags";
    }
    return $match.made;
} # method get-old-perl5-flags(Str:D $flags --> Str:D) #
```

[Top of Document](#table-of-contents)

### get-modern-emca262-flags(…)

Filter modern flags for use with **EMCA262Regex's**.

```raku
method get-modern-emca262-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsEMCA262ModernActions;
    my $match   = RegexUtils::FlagsEMCA262Modern.parse($flags.substr(1), :$actions);
    without $match {
        die "invalid flags";
    }
    return $match.made;
} # method get-modern-emca262-flags(Str:D $flags --> Str:D) #
```

### get-old-emca262-flags(…)

Translate old style **EMCA262Regex** flags into **Raku** ones.

```raku
method get-old-emca262-flags(Str:D $flags --> Str:D) {
    my $actions = RegexUtils::FlagsEMCA262OldActions;
    my $match   = RegexUtils::FlagsEMCA262Old.parse($flags, :$actions);
    without $match {
        die "invalid flags $flags";
    }
    return $match.made;
} # method get-old-emca262-flags(Str:D $flags --> Str:D) #
```

[Top of Document](#table-of-contents)

