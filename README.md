RegexUtils
============

1. [CreatePerlRegex](https://github.com/grizzlysmit/RegexUtils#method-createperlregexstrd-rg-strd-flags-is-copy--)
1. [CreateEMCA262Regex](https://github.com/grizzlysmit/RegexUtils#method-createemca262regexstrd-str-strd-flags-is-copy------regexd)
1. [get-modern-perl5-flags](https://github.com/grizzlysmit/RegexUtils#method-get-modern-perl5-flagsstrd-flags----strd)
1. [get-old-perl5-flags](https://github.com/grizzlysmit/RegexUtils#method-get-old-perl5-flagsstrd-flags----strd)
1. [get-modern-emca262-flags](https://github.com/grizzlysmit/RegexUtils#method-get-modern-emca262-flagsstrd-flags----strd)
1. [get-old-emca262-flags](https://github.com/grizzlysmit/RegexUtils#method-get-old-emca262-flagsstrd-flags----strd)

## method CreatePerlRegex(Str:D $rg, Str:D $flags is copy = '')

CreatePerlRegex constructs a Perl5 regex from a string with the required flags.

**Note:** not all raku flags are supported due to diffrences between the flags in the two languages 

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

## method CreateEMCA262Regex(Str:D $str, Str:D $flags is copy = '' --> Regex:D)

CreateEMCA262Regex converts a EMCA262 Regex to a raku one. using the [EMCA262Regex](https://modules.raku.org/dist/ECMA262Regex:zef:zef:jnthn) package  and applies flags to it.

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

**Note:** `ignorecase` only works for cases  like below due to how EMCA262Regex translates the charater constants, this is a problem that needs solving.

e.g. 

```raku 
[0] > use RegexUtils;
Nil
[1] > my $regex-emca = RegexUtils.CreateEMCA262Regex('^fo+\n', ':ignorecase');
rx:ignorecase/^\x66\x6F+\n/
[2] > so "Fooo\n" ~~ $regex-emca;
False
```

## method get-modern-perl5-flags(Str:D $flags --> Str:D)

## method get-old-perl5-flags(Str:D $flags --> Str:D)

## method get-modern-emca262-flags(Str:D $flags --> Str:D)

## method get-old-emca262-flags(Str:D $flags --> Str:D) 
