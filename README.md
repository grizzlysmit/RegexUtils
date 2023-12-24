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

  * [Introduction](#introduction)

  * [Introduction](#introduction)

  * [CreatePerlRegex(…)](#createperlregex)

  * [CreateEMCA262Regex(…)](#createemca262regex)

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

