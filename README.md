RegexUtils
============

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
