#
# This parser was generated with
# Parse::RecDescent version 1.967015
#

package Config::File::RRJSON::Parser;
use Config::File::RRJSON::ParserRuntime;
{ my $ERRORS;


package Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser;
use strict;
use vars qw($skip $AUTOLOAD  );
@Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::ISA = ();
$skip = '\\s*';


    use Data::Dumper::Concise;

    $::RD_ERRORS = 1;
    $::RD_WARN   = 3;
    $::RD_HINT   = 1;

    $::RD_AUTOACTION = q { $return = $#item == 1 ? { $item[0] => $item[1] } : { %item } };
;


{
local $SIG{__WARN__} = sub {0};
# PRETEND TO BE IN Config::File::RRJSON::ParserRuntime NAMESPACE
*Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::AUTOLOAD   = sub
{
    no strict 'refs';

    ${"AUTOLOAD"} =~ s/^Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser/Config::File::RRJSON::ParserRuntime/;
    goto &{${"AUTOLOAD"}};
}
}

push @Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::ISA, 'Config::File::RRJSON::ParserRuntime';
# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::AnyString
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"AnyString"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [AnyString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{AnyString},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{SingleQuotedString, or DoubleQuotedString, or String});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [SingleQuotedString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{AnyString});
        %item = (__RULE__ => q{AnyString});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [SingleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{AnyString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuotedString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [SingleQuotedString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{AnyString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [SingleQuotedString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuotedString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [SingleQuotedString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [DoubleQuotedString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{AnyString});
        %item = (__RULE__ => q{AnyString});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [DoubleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{AnyString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuotedString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [DoubleQuotedString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{AnyString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [DoubleQuotedString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuotedString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [DoubleQuotedString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [String]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{AnyString});
        %item = (__RULE__ => q{AnyString});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [String]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{AnyString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::String($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [String]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{AnyString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [String]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{String}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [String]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{AnyString},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{AnyString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{AnyString},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{AnyString},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Array
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Array"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Array]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Array},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{OpenBracket});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [OpenBracket ArrayItem FinalArrayItem CloseBracket]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Array});
        %item = (__RULE__ => q{Array});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [OpenBracket]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Array},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::OpenBracket($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [OpenBracket]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Array},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [OpenBracket]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{OpenBracket}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [ArrayItem]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Array},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{ArrayItem})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::ArrayItem, 0, 100000000, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [ArrayItem]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Array},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [ArrayItem]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{ArrayItem(s?)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [FinalArrayItem]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Array},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{FinalArrayItem})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::FinalArrayItem($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [FinalArrayItem]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Array},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [FinalArrayItem]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{FinalArrayItem}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [CloseBracket]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Array},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{CloseBracket})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::CloseBracket($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [CloseBracket]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Array},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [CloseBracket]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{CloseBracket}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    print "/" x 80, "\nArray:\n\@item:\n", Dumper(\@item), "%item:\n", Dumper(\%item), "/" x 80, "\n" if $::debug > 2;

    $return = $item[2];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [OpenBracket ArrayItem FinalArrayItem CloseBracket]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Array},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Array},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Array},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Array},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::ArrayItem
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"ArrayItem"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [ArrayItem]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{ArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{FinalArrayItem});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [FinalArrayItem Comma]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{ArrayItem});
        %item = (__RULE__ => q{ArrayItem});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [FinalArrayItem]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{ArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::FinalArrayItem($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [FinalArrayItem]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{ArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [FinalArrayItem]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{FinalArrayItem}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Comma]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{ArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Comma})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Comma($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Comma]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{ArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Comma]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Comma}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    $return = $item[1];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [FinalArrayItem Comma]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{ArrayItem},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{ArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{ArrayItem},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{ArrayItem},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::At
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"At"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [At]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{At},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'@'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['@']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{At});
        %item = (__RULE__ => q{At});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['@']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\@/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['@']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{At},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{At},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{At},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::CloseBrace
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"CloseBrace"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [CloseBrace]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{CloseBrace},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'\}'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['\}']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{CloseBrace});
        %item = (__RULE__ => q{CloseBrace});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['\}']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\}/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['\}']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{CloseBrace},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{CloseBrace},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{CloseBrace},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::CloseBracket
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"CloseBracket"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [CloseBracket]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{CloseBracket},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{']'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [']']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{CloseBracket});
        %item = (__RULE__ => q{CloseBracket});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [']']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\]/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [']']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{CloseBracket},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{CloseBracket},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{CloseBracket},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Colon
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Colon"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Colon]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Colon},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{':'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [':']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Colon},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Colon});
        %item = (__RULE__ => q{Colon});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [':']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Colon},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\:/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [':']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Colon},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Colon},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Colon},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Colon},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Colon},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Comma
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Comma"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Comma]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Comma},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{','});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [',']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Comma},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Comma});
        %item = (__RULE__ => q{Comma});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [',']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comma},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\,/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [',']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comma},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Comma},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Comma},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Comma},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Comma},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Comment
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Comment"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Comment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Comment},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{SingleLineComment, or MultiLineComment});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [SingleLineComment]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Comment});
        %item = (__RULE__ => q{Comment});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [SingleLineComment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Comment},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleLineComment, 1, 100000000, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [SingleLineComment]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Comment},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [SingleLineComment]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleLineComment(s)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [SingleLineComment]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [MultiLineComment]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{Comment});
        %item = (__RULE__ => q{Comment});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [MultiLineComment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Comment},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::MultiLineComment($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [MultiLineComment]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Comment},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [MultiLineComment]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{MultiLineComment}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [MultiLineComment]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Comment},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Comment},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Comment},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Def
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Def"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Def},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Key});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Key Colon]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Def});
        %item = (__RULE__ => q{Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Key]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Key($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Key]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Key]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Key}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [_alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Colon})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule_Def($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [_alternation_1_of_production_1_of_rule_Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [_alternation_1_of_production_1_of_rule_Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{_alternation_1_of_production_1_of_rule_Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    print Dumper(\%item);
    print Dumper(\@item);
    $return = { $item[1] => $item[3] };
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Key Colon]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Def},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Def},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Def},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Dot
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Dot"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Dot]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Dot},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'.'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['.']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Dot},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Dot});
        %item = (__RULE__ => q{Dot});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['.']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Dot},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\./)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['.']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Dot},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Dot},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Dot},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Dot},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Dot},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuote
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"DoubleQuote"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [DoubleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{DoubleQuote},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'"'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['"']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{DoubleQuote});
        %item = (__RULE__ => q{DoubleQuote});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['"']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\"/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['"']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{DoubleQuote},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{DoubleQuote},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{DoubleQuote},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuotedString
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"DoubleQuotedString"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [DoubleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{DoubleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{DoubleQuote});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [DoubleQuote /(\\\\"|\\n|[^"])*/ DoubleQuote]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{DoubleQuotedString});
        %item = (__RULE__ => q{DoubleQuotedString});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [DoubleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{DoubleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [DoubleQuote]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{DoubleQuotedString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [DoubleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/(\\\\"|\\n|[^"])*/]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/(\\\\"|\\n|[^"])*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:(\\"|\n|[^"])*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [DoubleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{DoubleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{DoubleQuote})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [DoubleQuote]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{DoubleQuotedString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [DoubleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    $return = $item[2];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [DoubleQuote /(\\\\"|\\n|[^"])*/ DoubleQuote]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{DoubleQuotedString},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{DoubleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{DoubleQuotedString},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{DoubleQuotedString},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::EOF
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"EOF"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [EOF]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{EOF},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{/\\Z/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [/\\Z/]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{EOF});
        %item = (__RULE__ => q{EOF});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/\\Z/]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:\Z)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [/\\Z/]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{EOF},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{EOF},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{EOF},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Equals
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Equals"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Equals]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Equals},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'='});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['=']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Equals},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Equals});
        %item = (__RULE__ => q{Equals});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['=']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Equals},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\=/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['=']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Equals},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Equals},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Equals},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Equals},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Equals},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::FinalArrayItem
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"FinalArrayItem"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [FinalArrayItem]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{FinalArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Def, or Hash, or Array, or AnyString});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Def]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{FinalArrayItem});
        %item = (__RULE__ => q{FinalArrayItem});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{FinalArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Def($thisparser,$text,$repeating,$_noactions,sub { return [is_recursive => 1] },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{FinalArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Def]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Hash]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{FinalArrayItem});
        %item = (__RULE__ => q{FinalArrayItem});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Hash]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{FinalArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Hash($thisparser,$text,$repeating,$_noactions,sub { return [is_recursive => 1] },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Hash]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{FinalArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Hash]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Hash}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Hash]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Array]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{FinalArrayItem});
        %item = (__RULE__ => q{FinalArrayItem});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Array]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{FinalArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Array($thisparser,$text,$repeating,$_noactions,sub { return [is_recursive => 1] },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Array]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{FinalArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Array]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Array}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Array]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [AnyString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[3];
        $text = $_[1];
        my $_savetext;
        @item = (q{FinalArrayItem});
        %item = (__RULE__ => q{FinalArrayItem});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [AnyString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{FinalArrayItem},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::AnyString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [AnyString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{FinalArrayItem},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [AnyString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{AnyString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [AnyString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{FinalArrayItem},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{FinalArrayItem},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{FinalArrayItem},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{FinalArrayItem},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Hash
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Hash"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Hash]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Hash},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{OpenBrace});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [OpenBrace Def CloseBrace]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Hash});
        %item = (__RULE__ => q{Hash});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [OpenBrace]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Hash},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::OpenBrace($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [OpenBrace]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Hash},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [OpenBrace]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{OpenBrace}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Hash},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{Def})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Def, 1, 100000000, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Hash},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [Def]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Def(s)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [CloseBrace]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Hash},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{CloseBrace})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::CloseBrace($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [CloseBrace]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Hash},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [CloseBrace]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{CloseBrace}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    print "/" x 80, "\nHash:\n\@item:\n", Dumper(\@item), "%item:\n", Dumper(\%item), "/" x 80, "\n" if $::debug > 2;

    $return = $item[2];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [OpenBrace Def CloseBrace]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Hash},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Hash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Hash},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Hash},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Identifier
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Identifier"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Identifier]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Identifier},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{/[a-z][a-z0-9_]*/i});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [/[a-z][a-z0-9_]*/i]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Identifier},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Identifier});
        %item = (__RULE__ => q{Identifier});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/[a-z][a-z0-9_]*/i]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Identifier},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[a-z][a-z0-9_]*)/i)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [/[a-z][a-z0-9_]*/i]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Identifier},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Identifier},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Identifier},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Identifier},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Identifier},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Key
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Key"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Key]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Key},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Identifier, or SingleQuotedString, or DoubleQuotedString});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Identifier]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Key});
        %item = (__RULE__ => q{Key});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Identifier]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Key},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Identifier($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Identifier]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Key},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Identifier]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Identifier}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Identifier]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [SingleQuotedString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{Key});
        %item = (__RULE__ => q{Key});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [SingleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Key},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuotedString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [SingleQuotedString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Key},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [SingleQuotedString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuotedString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [SingleQuotedString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [DoubleQuotedString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{Key});
        %item = (__RULE__ => q{Key});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [DoubleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{Key},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::DoubleQuotedString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [DoubleQuotedString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{Key},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [DoubleQuotedString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuotedString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [DoubleQuotedString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Key},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Key},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Key},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Key},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Minus
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Minus"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Minus]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Minus},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'-'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['-']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Minus});
        %item = (__RULE__ => q{Minus});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['-']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\-/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['-']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Minus},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Minus},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Minus},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::MultiLineComment
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"MultiLineComment"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [MultiLineComment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{MultiLineComment},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'/*'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['/*' m\{((?! \\*/ | /\\* ).)*\}sx '*/']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{MultiLineComment});
        %item = (__RULE__ => q{MultiLineComment});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['/*']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\/\*/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [m\{((?! \\*/ | /\\* ).)*\}sx]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{m\{((?! \\*/ | /\\* ).)*\}sx})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m{\A(?:((?! \*/ | /\* ).)*)}sx)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['*/']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{'*/'})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\*\//)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING2__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['/*' m\{((?! \\*/ | /\\* ).)*\}sx '*/']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{MultiLineComment},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{MultiLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{MultiLineComment},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{MultiLineComment},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::NewLine
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"NewLine"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [NewLine]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{NewLine},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'\\n'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['\\n']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{NewLine},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{NewLine});
        %item = (__RULE__ => q{NewLine});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['\\n']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{NewLine},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   do { $_tok = "\n"; 1 } and
             substr($text,0,length($_tok)) eq $_tok and
             do { substr($text,0,length($_tok)) = ""; 1; }
        )
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $_tok . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['\\n']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{NewLine},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{NewLine},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{NewLine},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{NewLine},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{NewLine},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::OpenBrace
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"OpenBrace"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [OpenBrace]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{OpenBrace},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'\{'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['\{']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{OpenBrace});
        %item = (__RULE__ => q{OpenBrace});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['\{']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\{/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['\{']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{OpenBrace},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{OpenBrace},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{OpenBrace},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::OpenBracket
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"OpenBracket"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [OpenBracket]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{OpenBracket},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'['});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['[']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{OpenBracket});
        %item = (__RULE__ => q{OpenBracket});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['[']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\[/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['[']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{OpenBracket},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{OpenBracket},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{OpenBracket},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Plus
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Plus"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Plus]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Plus},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'+'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['+']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Plus});
        %item = (__RULE__ => q{Plus});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['+']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\+/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['+']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Plus},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Plus},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Plus},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleLineComment
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SingleLineComment"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [SingleLineComment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{SingleLineComment},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{/[#]|\\/\\//});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [/[#]|\\/\\// /[^\\n]*/]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{SingleLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SingleLineComment});
        %item = (__RULE__ => q{SingleLineComment});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/[#]|\\/\\//]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[#]|\/\/)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/[^\\n]*/]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[^\\n]*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[^\n]*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN2__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [/[#]|\\/\\// /[^\\n]*/]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{SingleLineComment},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{SingleLineComment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SingleLineComment},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{SingleLineComment},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuote
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SingleQuote"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [SingleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{SingleQuote},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{/'/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [/'/]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SingleQuote});
        %item = (__RULE__ => q{SingleQuote});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/'/]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:')/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [/'/]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{SingleQuote},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SingleQuote},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{SingleQuote},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuotedString
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SingleQuotedString"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [SingleQuotedString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{SingleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{SingleQuote});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [SingleQuote /(\\\\'|\\n|[^'])*/ SingleQuote]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SingleQuotedString});
        %item = (__RULE__ => q{SingleQuotedString});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [SingleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{SingleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [SingleQuote]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{SingleQuotedString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [SingleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/(\\\\'|\\n|[^'])*/]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/(\\\\'|\\n|[^'])*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:(\\'|\n|[^'])*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [SingleQuote]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{SingleQuotedString},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{SingleQuote})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::SingleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [SingleQuote]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{SingleQuotedString},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [SingleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    $return = $item[2];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [SingleQuote /(\\\\'|\\n|[^'])*/ SingleQuote]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{SingleQuotedString},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{SingleQuotedString},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SingleQuotedString},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{SingleQuotedString},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Slash
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Slash"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [Slash]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{Slash},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{'/'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: ['/']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{Slash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Slash});
        %item = (__RULE__ => q{Slash});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: ['/']},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Slash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\//)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(qq{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: ['/']<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{Slash},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{Slash},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{Slash},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Slash},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{Slash},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::String
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"String"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [String]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{String},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        local $skip = defined($skip) ? $skip : $Config::File::RRJSON::ParserRuntime::skip;
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [<skip: '\s*'> /[-!#$%&()*+.\\/0-9:;<=>?\\@A-Z^_`\\|~ \\t]+/i]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{String});
        %item = (__RULE__ => q{String});
        my $repcount = 0;


        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying directive: [<skip: '\s*'>]},
                    Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE; 
        $_tok = do { my $oldskip = $skip; $skip= '\s*'; $oldskip };
        if (defined($_tok))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched directive<< (return value: [}
                        . $_tok . q{])},
                        Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        else
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match directive>>},
                        Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        
        last unless defined $_tok;
        push @item, $item{__DIRECTIVE1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying terminal: [/[-!#$%&()*+.\\/0-9:;<=>?\\@A-Z^_`\\|~ \\t]+/i]}, Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[-!#$%&()*+.\\/0-9:;<=>?\\@A-Z^_`\\|~ \\t]+/i})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[-!#$%&()*+.\/0-9:;<=>?\@A-Z^_`\|~ \t]+)/i)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match terminal>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
    $item[2] =~ s/[,\s]*$//;

    $return = $item[2];
};
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [<skip: '\s*'> /[-!#$%&()*+.\\/0-9:;<=>?\\@A-Z^_`\\|~ \\t]+/i]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{String},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{String},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{String},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{String},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule_Def
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"_alternation_1_of_production_1_of_rule_Def"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [_alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{_alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Colon});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{_alternation_1_of_production_1_of_rule_Def},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{_alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Colon});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon Hash]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [Colon]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Colon, 0, 1, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [Colon]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [Colon]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Colon(?)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Hash]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Hash})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Hash($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Hash]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Hash]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Hash}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon Hash]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule_startrule
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"_alternation_1_of_production_1_of_rule_startrule"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [_alternation_1_of_production_1_of_rule_startrule]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{_alternation_1_of_production_1_of_rule_startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Comment, or Def});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Comment]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule_startrule});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule_startrule});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Comment]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule_startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Comment($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Comment]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule_startrule},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Comment]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Comment}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Comment]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Def]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_1_of_rule_startrule});
        %item = (__RULE__ => q{_alternation_1_of_production_1_of_rule_startrule});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_1_of_rule_startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Def($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_1_of_rule_startrule},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Def]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Def}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Def]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{_alternation_1_of_production_1_of_rule_startrule},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{_alternation_1_of_production_1_of_rule_startrule},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Colon});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon Array]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [Colon]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Colon, 0, 1, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [Colon]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [Colon]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Colon(?)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Array]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Array})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Array($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Array]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Array]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Array}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon Array]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{Colon});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [Colon AnyString]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def});
        %item = (__RULE__ => q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def});
        my $repcount = 0;


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [Colon]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::Colon($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [Colon]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [Colon]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Colon}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [AnyString]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{AnyString})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::AnyString($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [AnyString]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [AnyString]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{AnyString}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [Colon AnyString]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::startrule
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"startrule"};

    Config::File::RRJSON::ParserRuntime::_trace(q{Trying rule: [startrule]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                  q{startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;

    
    my $err_at = @{$thisparser->{errors}};

    my $score;
    my $score_return;
    my $_tok;
    my $return = undef;
    my $_matched=0;
    my $commit=0;
    my @item = ();
    my %item = ();
    my $repeating =  $_[2];
    my $_noactions = $_[3];
    my @arg =    defined $_[4] ? @{ &{$_[4]} } : ();
    my $_itempos = $_[5];
    my %arg =    ($#arg & 01) ? @arg : (@arg, undef);
    my $text;
    my $lastsep;
    my $current_match;
    my $expectation = new Config::File::RRJSON::ParserRuntime::Expectation(q{});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Config::File::RRJSON::ParserRuntime::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        local $skip = defined($skip) ? $skip : $Config::File::RRJSON::ParserRuntime::skip;
        Config::File::RRJSON::ParserRuntime::_trace(q{Trying production: [<skip: qr{(?xs:
          (?: \s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\n]* \n?             # End of line comment
          )
       )*}> Comment, or Def EOF]},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{startrule});
        %item = (__RULE__ => q{startrule});
        my $repcount = 0;


        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying directive: [<skip: qr{(?xs:
          (?: \s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\n]* \n?             # End of line comment
          )
       )*}>]},
                    Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE; 
        $_tok = do { my $oldskip = $skip; $skip= qr{(?xs:
          (?: \s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\n]* \n?             # End of line comment
          )
       )*}; $oldskip };
        if (defined($_tok))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched directive<< (return value: [}
                        . $_tok . q{])},
                        Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        else
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match directive>>},
                        Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        
        last unless defined $_tok;
        push @item, $item{__DIRECTIVE1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying repeated subrule: [Comment, or Def]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{Comment, or Def})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::_alternation_1_of_production_1_of_rule_startrule, 1, 100000000, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match repeated subrule: [Comment, or Def]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{startrule},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched repeated subrule: [_alternation_1_of_production_1_of_rule_startrule]<< (}
                    . @$_tok . q{ times)},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{_alternation_1_of_production_1_of_rule_startrule(s)}} = $_tok;
        push @item, $_tok;
        


        Config::File::RRJSON::ParserRuntime::_trace(q{Trying subrule: [EOF]},
                  Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                  q{startrule},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{EOF})->at($text);
        unless (defined ($_tok = Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser::EOF($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match subrule: [EOF]>>},
                          Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                          q{startrule},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched subrule: [EOF]<< (return value: [}
                    . $_tok . q{]},

                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{EOF}} = $_tok;
        push @item, $_tok;
        
        }

        Config::File::RRJSON::ParserRuntime::_trace(q{Trying action},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do { $item[2] };
        unless (defined $_tok)
        {
            Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched production: [<skip: qr{(?xs:
          (?: \s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\n]* \n?             # End of line comment
          )
       )*}> Comment, or Def EOF]<<},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Config::File::RRJSON::ParserRuntime::_trace(q{<<Didn't match rule>>},
                     Config::File::RRJSON::ParserRuntime::_tracefirst($_[1]),
                     q{startrule},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Accepted scored production<<}, "",
                      q{startrule},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Config::File::RRJSON::ParserRuntime::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{startrule},
                      $tracelevel);
        Config::File::RRJSON::ParserRuntime::_trace(q{(consumed: [} .
                      Config::File::RRJSON::ParserRuntime::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Config::File::RRJSON::ParserRuntime::_tracefirst($text),
                      , q{startrule},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}
}
package Config::File::RRJSON::Parser; sub new { my $self = bless( {
                 '_AUTOACTION' => undef,
                 '_AUTOTREE' => undef,
                 '_check' => {
                               'itempos' => '',
                               'prevcolumn' => '',
                               'prevline' => '',
                               'prevoffset' => '',
                               'thiscolumn' => '',
                               'thisoffset' => ''
                             },
                 'localvars' => '',
                 'namespace' => 'Config::File::RRJSON::ParserRuntime::Config::File::RRJSON::Parser',
                 'rules' => {
                              'AnyString' => bless( {
                                                      'calls' => [
                                                                   'SingleQuotedString',
                                                                   'DoubleQuotedString',
                                                                   'String'
                                                                 ],
                                                      'changed' => 0,
                                                      'impcount' => 0,
                                                      'line' => 70,
                                                      'name' => 'AnyString',
                                                      'opcount' => 0,
                                                      'prods' => [
                                                                   bless( {
                                                                            'actcount' => 0,
                                                                            'dircount' => 0,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 70,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'SingleQuotedString'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 0,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                   bless( {
                                                                            'actcount' => 0,
                                                                            'dircount' => 0,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 70,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'DoubleQuotedString'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                       ],
                                                                            'line' => 70,
                                                                            'number' => 1,
                                                                            'patcount' => 0,
                                                                            'strcount' => 0,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                   bless( {
                                                                            'actcount' => 0,
                                                                            'dircount' => 0,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 70,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'String'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                       ],
                                                                            'line' => 70,
                                                                            'number' => 2,
                                                                            'patcount' => 0,
                                                                            'strcount' => 0,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Array' => bless( {
                                                  'calls' => [
                                                               'OpenBracket',
                                                               'ArrayItem',
                                                               'FinalArrayItem',
                                                               'CloseBracket'
                                                             ],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 44,
                                                  'name' => 'Array',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 1,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 44,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'OpenBracket'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'expected' => undef,
                                                                                              'line' => 44,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'max' => 100000000,
                                                                                              'min' => 0,
                                                                                              'repspec' => 's?',
                                                                                              'subrule' => 'ArrayItem'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Repetition' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 44,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'FinalArrayItem'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 44,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'CloseBracket'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                     bless( {
                                                                                              'code' => '{
    print "/" x 80, "\\nArray:\\n\\@item:\\n", Dumper(\\@item), "%item:\\n", Dumper(\\%item), "/" x 80, "\\n" if $::debug > 2;

    $return = $item[2];
}',
                                                                                              'hashname' => '__ACTION1__',
                                                                                              'line' => 45,
                                                                                              'lookahead' => 0
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'ArrayItem' => bless( {
                                                      'calls' => [
                                                                   'FinalArrayItem',
                                                                   'Comma'
                                                                 ],
                                                      'changed' => 0,
                                                      'impcount' => 0,
                                                      'line' => 51,
                                                      'name' => 'ArrayItem',
                                                      'opcount' => 0,
                                                      'prods' => [
                                                                   bless( {
                                                                            'actcount' => 1,
                                                                            'dircount' => 0,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 51,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'FinalArrayItem'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 51,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'Comma'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                         bless( {
                                                                                                  'code' => '{
    $return = $item[1];
}',
                                                                                                  'hashname' => '__ACTION1__',
                                                                                                  'line' => 52,
                                                                                                  'lookahead' => 0
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 0,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'At' => bless( {
                                               'calls' => [],
                                               'changed' => 0,
                                               'impcount' => 0,
                                               'line' => 83,
                                               'name' => 'At',
                                               'opcount' => 0,
                                               'prods' => [
                                                            bless( {
                                                                     'actcount' => 0,
                                                                     'dircount' => 0,
                                                                     'error' => undef,
                                                                     'items' => [
                                                                                  bless( {
                                                                                           'description' => '\'@\'',
                                                                                           'hashname' => '__STRING1__',
                                                                                           'line' => 83,
                                                                                           'lookahead' => 0,
                                                                                           'pattern' => '@'
                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                ],
                                                                     'line' => undef,
                                                                     'number' => 0,
                                                                     'patcount' => 0,
                                                                     'strcount' => 1,
                                                                     'uncommit' => undef
                                                                   }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                          ],
                                               'vars' => ''
                                             }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'CloseBrace' => bless( {
                                                       'calls' => [],
                                                       'changed' => 0,
                                                       'impcount' => 0,
                                                       'line' => 101,
                                                       'name' => 'CloseBrace',
                                                       'opcount' => 0,
                                                       'prods' => [
                                                                    bless( {
                                                                             'actcount' => 0,
                                                                             'dircount' => 0,
                                                                             'error' => undef,
                                                                             'items' => [
                                                                                          bless( {
                                                                                                   'description' => '\'\\}\'',
                                                                                                   'hashname' => '__STRING1__',
                                                                                                   'line' => 101,
                                                                                                   'lookahead' => 0,
                                                                                                   'pattern' => '}'
                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                        ],
                                                                             'line' => undef,
                                                                             'number' => 0,
                                                                             'patcount' => 0,
                                                                             'strcount' => 1,
                                                                             'uncommit' => undef
                                                                           }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                  ],
                                                       'vars' => ''
                                                     }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'CloseBracket' => bless( {
                                                         'calls' => [],
                                                         'changed' => 0,
                                                         'impcount' => 0,
                                                         'line' => 97,
                                                         'name' => 'CloseBracket',
                                                         'opcount' => 0,
                                                         'prods' => [
                                                                      bless( {
                                                                               'actcount' => 0,
                                                                               'dircount' => 0,
                                                                               'error' => undef,
                                                                               'items' => [
                                                                                            bless( {
                                                                                                     'description' => '\']\'',
                                                                                                     'hashname' => '__STRING1__',
                                                                                                     'line' => 97,
                                                                                                     'lookahead' => 0,
                                                                                                     'pattern' => ']'
                                                                                                   }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                          ],
                                                                               'line' => undef,
                                                                               'number' => 0,
                                                                               'patcount' => 0,
                                                                               'strcount' => 1,
                                                                               'uncommit' => undef
                                                                             }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                    ],
                                                         'vars' => ''
                                                       }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Colon' => bless( {
                                                  'calls' => [],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 87,
                                                  'name' => 'Colon',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 0,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'description' => '\':\'',
                                                                                              'hashname' => '__STRING1__',
                                                                                              'line' => 87,
                                                                                              'lookahead' => 0,
                                                                                              'pattern' => ':'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 1,
                                                                        'uncommit' => undef
                                                                      }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Comma' => bless( {
                                                  'calls' => [],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 89,
                                                  'name' => 'Comma',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 0,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'description' => '\',\'',
                                                                                              'hashname' => '__STRING1__',
                                                                                              'line' => 89,
                                                                                              'lookahead' => 0,
                                                                                              'pattern' => ','
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 1,
                                                                        'uncommit' => undef
                                                                      }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Comment' => bless( {
                                                    'calls' => [
                                                                 'SingleLineComment',
                                                                 'MultiLineComment'
                                                               ],
                                                    'changed' => 0,
                                                    'impcount' => 0,
                                                    'line' => 22,
                                                    'name' => 'Comment',
                                                    'opcount' => 0,
                                                    'prods' => [
                                                                 bless( {
                                                                          'actcount' => 0,
                                                                          'dircount' => 0,
                                                                          'error' => undef,
                                                                          'items' => [
                                                                                       bless( {
                                                                                                'argcode' => undef,
                                                                                                'expected' => undef,
                                                                                                'line' => 22,
                                                                                                'lookahead' => 0,
                                                                                                'matchrule' => 0,
                                                                                                'max' => 100000000,
                                                                                                'min' => 1,
                                                                                                'repspec' => 's',
                                                                                                'subrule' => 'SingleLineComment'
                                                                                              }, 'Config::File::RRJSON::ParserRuntime::Repetition' )
                                                                                     ],
                                                                          'line' => undef,
                                                                          'number' => 0,
                                                                          'patcount' => 0,
                                                                          'strcount' => 0,
                                                                          'uncommit' => undef
                                                                        }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                 bless( {
                                                                          'actcount' => 0,
                                                                          'dircount' => 0,
                                                                          'error' => undef,
                                                                          'items' => [
                                                                                       bless( {
                                                                                                'argcode' => undef,
                                                                                                'implicit' => undef,
                                                                                                'line' => 22,
                                                                                                'lookahead' => 0,
                                                                                                'matchrule' => 0,
                                                                                                'subrule' => 'MultiLineComment'
                                                                                              }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                     ],
                                                                          'line' => 22,
                                                                          'number' => 1,
                                                                          'patcount' => 0,
                                                                          'strcount' => 0,
                                                                          'uncommit' => undef
                                                                        }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                               ],
                                                    'vars' => ''
                                                  }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Def' => bless( {
                                                'calls' => [
                                                             'Key',
                                                             '_alternation_1_of_production_1_of_rule_Def'
                                                           ],
                                                'changed' => 0,
                                                'impcount' => 1,
                                                'line' => 28,
                                                'name' => 'Def',
                                                'opcount' => 0,
                                                'prods' => [
                                                             bless( {
                                                                      'actcount' => 1,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'argcode' => undef,
                                                                                            'implicit' => undef,
                                                                                            'line' => 28,
                                                                                            'lookahead' => 0,
                                                                                            'matchrule' => 0,
                                                                                            'subrule' => 'Key'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                   bless( {
                                                                                            'argcode' => undef,
                                                                                            'implicit' => 'Colon',
                                                                                            'line' => 28,
                                                                                            'lookahead' => 0,
                                                                                            'matchrule' => 0,
                                                                                            'subrule' => '_alternation_1_of_production_1_of_rule_Def'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                   bless( {
                                                                                            'code' => '{
    print Dumper(\\%item);
    print Dumper(\\@item);
    $return = { $item[1] => $item[3] };
}',
                                                                                            'hashname' => '__ACTION1__',
                                                                                            'line' => 29,
                                                                                            'lookahead' => 0
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                 ],
                                                                      'line' => undef,
                                                                      'number' => 0,
                                                                      'patcount' => 0,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                           ],
                                                'vars' => ''
                                              }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Dot' => bless( {
                                                'calls' => [],
                                                'changed' => 0,
                                                'impcount' => 0,
                                                'line' => 85,
                                                'name' => 'Dot',
                                                'opcount' => 0,
                                                'prods' => [
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'description' => '\'.\'',
                                                                                            'hashname' => '__STRING1__',
                                                                                            'line' => 85,
                                                                                            'lookahead' => 0,
                                                                                            'pattern' => '.'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                 ],
                                                                      'line' => undef,
                                                                      'number' => 0,
                                                                      'patcount' => 0,
                                                                      'strcount' => 1,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                           ],
                                                'vars' => ''
                                              }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'DoubleQuote' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 91,
                                                        'name' => 'DoubleQuote',
                                                        'opcount' => 0,
                                                        'prods' => [
                                                                     bless( {
                                                                              'actcount' => 0,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'description' => '\'"\'',
                                                                                                    'hashname' => '__STRING1__',
                                                                                                    'line' => 91,
                                                                                                    'lookahead' => 0,
                                                                                                    'pattern' => '"'
                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 0,
                                                                              'strcount' => 1,
                                                                              'uncommit' => undef
                                                                            }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'DoubleQuotedString' => bless( {
                                                               'calls' => [
                                                                            'DoubleQuote'
                                                                          ],
                                                               'changed' => 0,
                                                               'impcount' => 0,
                                                               'line' => 65,
                                                               'name' => 'DoubleQuotedString',
                                                               'opcount' => 0,
                                                               'prods' => [
                                                                            bless( {
                                                                                     'actcount' => 1,
                                                                                     'dircount' => 0,
                                                                                     'error' => undef,
                                                                                     'items' => [
                                                                                                  bless( {
                                                                                                           'argcode' => undef,
                                                                                                           'implicit' => undef,
                                                                                                           'line' => 65,
                                                                                                           'lookahead' => 0,
                                                                                                           'matchrule' => 0,
                                                                                                           'subrule' => 'DoubleQuote'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                                  bless( {
                                                                                                           'description' => '/(\\\\\\\\"|\\\\n|[^"])*/',
                                                                                                           'hashname' => '__PATTERN1__',
                                                                                                           'ldelim' => '/',
                                                                                                           'line' => 65,
                                                                                                           'lookahead' => 0,
                                                                                                           'mod' => '',
                                                                                                           'pattern' => '(\\\\"|\\n|[^"])*',
                                                                                                           'rdelim' => '/'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Token' ),
                                                                                                  bless( {
                                                                                                           'argcode' => undef,
                                                                                                           'implicit' => undef,
                                                                                                           'line' => 65,
                                                                                                           'lookahead' => 0,
                                                                                                           'matchrule' => 0,
                                                                                                           'subrule' => 'DoubleQuote'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                                  bless( {
                                                                                                           'code' => '{
    $return = $item[2];
}',
                                                                                                           'hashname' => '__ACTION1__',
                                                                                                           'line' => 66,
                                                                                                           'lookahead' => 0
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                                ],
                                                                                     'line' => undef,
                                                                                     'number' => 0,
                                                                                     'patcount' => 1,
                                                                                     'strcount' => 0,
                                                                                     'uncommit' => undef
                                                                                   }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                          ],
                                                               'vars' => ''
                                                             }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'EOF' => bless( {
                                                'calls' => [],
                                                'changed' => 0,
                                                'impcount' => 0,
                                                'line' => 109,
                                                'name' => 'EOF',
                                                'opcount' => 0,
                                                'prods' => [
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'description' => '/\\\\Z/',
                                                                                            'hashname' => '__PATTERN1__',
                                                                                            'ldelim' => '/',
                                                                                            'line' => 109,
                                                                                            'lookahead' => 0,
                                                                                            'mod' => '',
                                                                                            'pattern' => '\\Z',
                                                                                            'rdelim' => '/'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Token' )
                                                                                 ],
                                                                      'line' => undef,
                                                                      'number' => 0,
                                                                      'patcount' => 1,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                           ],
                                                'vars' => ''
                                              }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Equals' => bless( {
                                                   'calls' => [],
                                                   'changed' => 0,
                                                   'impcount' => 0,
                                                   'line' => 107,
                                                   'name' => 'Equals',
                                                   'opcount' => 0,
                                                   'prods' => [
                                                                bless( {
                                                                         'actcount' => 0,
                                                                         'dircount' => 0,
                                                                         'error' => undef,
                                                                         'items' => [
                                                                                      bless( {
                                                                                               'description' => '\'=\'',
                                                                                               'hashname' => '__STRING1__',
                                                                                               'line' => 107,
                                                                                               'lookahead' => 0,
                                                                                               'pattern' => '='
                                                                                             }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                    ],
                                                                         'line' => undef,
                                                                         'number' => 0,
                                                                         'patcount' => 0,
                                                                         'strcount' => 1,
                                                                         'uncommit' => undef
                                                                       }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                              ],
                                                   'vars' => ''
                                                 }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'FinalArrayItem' => bless( {
                                                           'calls' => [
                                                                        'Def',
                                                                        'Hash',
                                                                        'Array',
                                                                        'AnyString'
                                                                      ],
                                                           'changed' => 0,
                                                           'impcount' => 0,
                                                           'line' => 56,
                                                           'name' => 'FinalArrayItem',
                                                           'opcount' => 0,
                                                           'prods' => [
                                                                        bless( {
                                                                                 'actcount' => 0,
                                                                                 'dircount' => 0,
                                                                                 'error' => undef,
                                                                                 'items' => [
                                                                                              bless( {
                                                                                                       'argcode' => '[is_recursive => 1]',
                                                                                                       'implicit' => undef,
                                                                                                       'line' => 56,
                                                                                                       'lookahead' => 0,
                                                                                                       'matchrule' => 0,
                                                                                                       'subrule' => 'Def'
                                                                                                     }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                            ],
                                                                                 'line' => undef,
                                                                                 'number' => 0,
                                                                                 'patcount' => 0,
                                                                                 'strcount' => 0,
                                                                                 'uncommit' => undef
                                                                               }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                        bless( {
                                                                                 'actcount' => 0,
                                                                                 'dircount' => 0,
                                                                                 'error' => undef,
                                                                                 'items' => [
                                                                                              bless( {
                                                                                                       'argcode' => '[is_recursive => 1]',
                                                                                                       'implicit' => undef,
                                                                                                       'line' => 56,
                                                                                                       'lookahead' => 0,
                                                                                                       'matchrule' => 0,
                                                                                                       'subrule' => 'Hash'
                                                                                                     }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                            ],
                                                                                 'line' => 56,
                                                                                 'number' => 1,
                                                                                 'patcount' => 0,
                                                                                 'strcount' => 0,
                                                                                 'uncommit' => undef
                                                                               }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                        bless( {
                                                                                 'actcount' => 0,
                                                                                 'dircount' => 0,
                                                                                 'error' => undef,
                                                                                 'items' => [
                                                                                              bless( {
                                                                                                       'argcode' => '[is_recursive => 1]',
                                                                                                       'implicit' => undef,
                                                                                                       'line' => 56,
                                                                                                       'lookahead' => 0,
                                                                                                       'matchrule' => 0,
                                                                                                       'subrule' => 'Array'
                                                                                                     }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                            ],
                                                                                 'line' => 56,
                                                                                 'number' => 2,
                                                                                 'patcount' => 0,
                                                                                 'strcount' => 0,
                                                                                 'uncommit' => undef
                                                                               }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                        bless( {
                                                                                 'actcount' => 0,
                                                                                 'dircount' => 0,
                                                                                 'error' => undef,
                                                                                 'items' => [
                                                                                              bless( {
                                                                                                       'argcode' => undef,
                                                                                                       'implicit' => undef,
                                                                                                       'line' => 56,
                                                                                                       'lookahead' => 0,
                                                                                                       'matchrule' => 0,
                                                                                                       'subrule' => 'AnyString'
                                                                                                     }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                            ],
                                                                                 'line' => 56,
                                                                                 'number' => 3,
                                                                                 'patcount' => 0,
                                                                                 'strcount' => 0,
                                                                                 'uncommit' => undef
                                                                               }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                      ],
                                                           'vars' => ''
                                                         }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Hash' => bless( {
                                                 'calls' => [
                                                              'OpenBrace',
                                                              'Def',
                                                              'CloseBrace'
                                                            ],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 37,
                                                 'name' => 'Hash',
                                                 'opcount' => 0,
                                                 'prods' => [
                                                              bless( {
                                                                       'actcount' => 1,
                                                                       'dircount' => 0,
                                                                       'error' => undef,
                                                                       'items' => [
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'implicit' => undef,
                                                                                             'line' => 37,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'OpenBrace'
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'expected' => undef,
                                                                                             'line' => 37,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'max' => 100000000,
                                                                                             'min' => 1,
                                                                                             'repspec' => 's',
                                                                                             'subrule' => 'Def'
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Repetition' ),
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'implicit' => undef,
                                                                                             'line' => 37,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'CloseBrace'
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                    bless( {
                                                                                             'code' => '{
    print "/" x 80, "\\nHash:\\n\\@item:\\n", Dumper(\\@item), "%item:\\n", Dumper(\\%item), "/" x 80, "\\n" if $::debug > 2;

    $return = $item[2];
}',
                                                                                             'hashname' => '__ACTION1__',
                                                                                             'line' => 38,
                                                                                             'lookahead' => 0
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 0,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Identifier' => bless( {
                                                       'calls' => [],
                                                       'changed' => 0,
                                                       'impcount' => 0,
                                                       'line' => 58,
                                                       'name' => 'Identifier',
                                                       'opcount' => 0,
                                                       'prods' => [
                                                                    bless( {
                                                                             'actcount' => 0,
                                                                             'dircount' => 0,
                                                                             'error' => undef,
                                                                             'items' => [
                                                                                          bless( {
                                                                                                   'description' => '/[a-z][a-z0-9_]*/i',
                                                                                                   'hashname' => '__PATTERN1__',
                                                                                                   'ldelim' => '/',
                                                                                                   'line' => 58,
                                                                                                   'lookahead' => 0,
                                                                                                   'mod' => 'i',
                                                                                                   'pattern' => '[a-z][a-z0-9_]*',
                                                                                                   'rdelim' => '/'
                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Token' )
                                                                                        ],
                                                                             'line' => undef,
                                                                             'number' => 0,
                                                                             'patcount' => 1,
                                                                             'strcount' => 0,
                                                                             'uncommit' => undef
                                                                           }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                  ],
                                                       'vars' => ''
                                                     }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Key' => bless( {
                                                'calls' => [
                                                             'Identifier',
                                                             'SingleQuotedString',
                                                             'DoubleQuotedString'
                                                           ],
                                                'changed' => 0,
                                                'impcount' => 0,
                                                'line' => 35,
                                                'name' => 'Key',
                                                'opcount' => 0,
                                                'prods' => [
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'argcode' => undef,
                                                                                            'implicit' => undef,
                                                                                            'line' => 35,
                                                                                            'lookahead' => 0,
                                                                                            'matchrule' => 0,
                                                                                            'subrule' => 'Identifier'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                 ],
                                                                      'line' => undef,
                                                                      'number' => 0,
                                                                      'patcount' => 0,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'argcode' => undef,
                                                                                            'implicit' => undef,
                                                                                            'line' => 35,
                                                                                            'lookahead' => 0,
                                                                                            'matchrule' => 0,
                                                                                            'subrule' => 'SingleQuotedString'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                 ],
                                                                      'line' => 35,
                                                                      'number' => 1,
                                                                      'patcount' => 0,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'argcode' => undef,
                                                                                            'implicit' => undef,
                                                                                            'line' => 35,
                                                                                            'lookahead' => 0,
                                                                                            'matchrule' => 0,
                                                                                            'subrule' => 'DoubleQuotedString'
                                                                                          }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                 ],
                                                                      'line' => 35,
                                                                      'number' => 2,
                                                                      'patcount' => 0,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                           ],
                                                'vars' => ''
                                              }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Minus' => bless( {
                                                  'calls' => [],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 103,
                                                  'name' => 'Minus',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 0,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'description' => '\'-\'',
                                                                                              'hashname' => '__STRING1__',
                                                                                              'line' => 103,
                                                                                              'lookahead' => 0,
                                                                                              'pattern' => '-'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 1,
                                                                        'uncommit' => undef
                                                                      }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'MultiLineComment' => bless( {
                                                             'calls' => [],
                                                             'changed' => 0,
                                                             'impcount' => 0,
                                                             'line' => 26,
                                                             'name' => 'MultiLineComment',
                                                             'opcount' => 0,
                                                             'prods' => [
                                                                          bless( {
                                                                                   'actcount' => 0,
                                                                                   'dircount' => 0,
                                                                                   'error' => undef,
                                                                                   'items' => [
                                                                                                bless( {
                                                                                                         'description' => '\'/*\'',
                                                                                                         'hashname' => '__STRING1__',
                                                                                                         'line' => 26,
                                                                                                         'lookahead' => 0,
                                                                                                         'pattern' => '/*'
                                                                                                       }, 'Config::File::RRJSON::ParserRuntime::Literal' ),
                                                                                                bless( {
                                                                                                         'description' => 'm\\{((?! \\\\*/ | /\\\\* ).)*\\}sx',
                                                                                                         'hashname' => '__PATTERN1__',
                                                                                                         'ldelim' => '{',
                                                                                                         'line' => 26,
                                                                                                         'lookahead' => 0,
                                                                                                         'mod' => 'sx',
                                                                                                         'pattern' => '((?! \\*/ | /\\* ).)*',
                                                                                                         'rdelim' => '}'
                                                                                                       }, 'Config::File::RRJSON::ParserRuntime::Token' ),
                                                                                                bless( {
                                                                                                         'description' => '\'*/\'',
                                                                                                         'hashname' => '__STRING2__',
                                                                                                         'line' => 26,
                                                                                                         'lookahead' => 0,
                                                                                                         'pattern' => '*/'
                                                                                                       }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                              ],
                                                                                   'line' => undef,
                                                                                   'number' => 0,
                                                                                   'patcount' => 1,
                                                                                   'strcount' => 2,
                                                                                   'uncommit' => undef
                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                        ],
                                                             'vars' => ''
                                                           }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'NewLine' => bless( {
                                                    'calls' => [],
                                                    'changed' => 0,
                                                    'impcount' => 0,
                                                    'line' => 79,
                                                    'name' => 'NewLine',
                                                    'opcount' => 0,
                                                    'prods' => [
                                                                 bless( {
                                                                          'actcount' => 0,
                                                                          'dircount' => 0,
                                                                          'error' => undef,
                                                                          'items' => [
                                                                                       bless( {
                                                                                                'description' => '\'\\\\n\'',
                                                                                                'hashname' => '__STRING1__',
                                                                                                'line' => 79,
                                                                                                'lookahead' => 0,
                                                                                                'pattern' => '\\n'
                                                                                              }, 'Config::File::RRJSON::ParserRuntime::InterpLit' )
                                                                                     ],
                                                                          'line' => undef,
                                                                          'number' => 0,
                                                                          'patcount' => 0,
                                                                          'strcount' => 1,
                                                                          'uncommit' => undef
                                                                        }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                               ],
                                                    'vars' => ''
                                                  }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'OpenBrace' => bless( {
                                                      'calls' => [],
                                                      'changed' => 0,
                                                      'impcount' => 0,
                                                      'line' => 99,
                                                      'name' => 'OpenBrace',
                                                      'opcount' => 0,
                                                      'prods' => [
                                                                   bless( {
                                                                            'actcount' => 0,
                                                                            'dircount' => 0,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'description' => '\'\\{\'',
                                                                                                  'hashname' => '__STRING1__',
                                                                                                  'line' => 99,
                                                                                                  'lookahead' => 0,
                                                                                                  'pattern' => '{'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 1,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'OpenBracket' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 95,
                                                        'name' => 'OpenBracket',
                                                        'opcount' => 0,
                                                        'prods' => [
                                                                     bless( {
                                                                              'actcount' => 0,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'description' => '\'[\'',
                                                                                                    'hashname' => '__STRING1__',
                                                                                                    'line' => 95,
                                                                                                    'lookahead' => 0,
                                                                                                    'pattern' => '['
                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 0,
                                                                              'strcount' => 1,
                                                                              'uncommit' => undef
                                                                            }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Plus' => bless( {
                                                 'calls' => [],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 105,
                                                 'name' => 'Plus',
                                                 'opcount' => 0,
                                                 'prods' => [
                                                              bless( {
                                                                       'actcount' => 0,
                                                                       'dircount' => 0,
                                                                       'error' => undef,
                                                                       'items' => [
                                                                                    bless( {
                                                                                             'description' => '\'+\'',
                                                                                             'hashname' => '__STRING1__',
                                                                                             'line' => 105,
                                                                                             'lookahead' => 0,
                                                                                             'pattern' => '+'
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 0,
                                                                       'strcount' => 1,
                                                                       'uncommit' => undef
                                                                     }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'SingleLineComment' => bless( {
                                                              'calls' => [],
                                                              'changed' => 0,
                                                              'impcount' => 0,
                                                              'line' => 24,
                                                              'name' => 'SingleLineComment',
                                                              'opcount' => 0,
                                                              'prods' => [
                                                                           bless( {
                                                                                    'actcount' => 0,
                                                                                    'dircount' => 0,
                                                                                    'error' => undef,
                                                                                    'items' => [
                                                                                                 bless( {
                                                                                                          'description' => '/[#]|\\\\/\\\\//',
                                                                                                          'hashname' => '__PATTERN1__',
                                                                                                          'ldelim' => '/',
                                                                                                          'line' => 24,
                                                                                                          'lookahead' => 0,
                                                                                                          'mod' => '',
                                                                                                          'pattern' => '[#]|\\/\\/',
                                                                                                          'rdelim' => '/'
                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Token' ),
                                                                                                 bless( {
                                                                                                          'description' => '/[^\\\\n]*/',
                                                                                                          'hashname' => '__PATTERN2__',
                                                                                                          'ldelim' => '/',
                                                                                                          'line' => 24,
                                                                                                          'lookahead' => 0,
                                                                                                          'mod' => '',
                                                                                                          'pattern' => '[^\\n]*',
                                                                                                          'rdelim' => '/'
                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Token' )
                                                                                               ],
                                                                                    'line' => undef,
                                                                                    'number' => 0,
                                                                                    'patcount' => 2,
                                                                                    'strcount' => 0,
                                                                                    'uncommit' => undef
                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                         ],
                                                              'vars' => ''
                                                            }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'SingleQuote' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 93,
                                                        'name' => 'SingleQuote',
                                                        'opcount' => 0,
                                                        'prods' => [
                                                                     bless( {
                                                                              'actcount' => 0,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'description' => '/\'/',
                                                                                                    'hashname' => '__PATTERN1__',
                                                                                                    'ldelim' => '/',
                                                                                                    'line' => 93,
                                                                                                    'lookahead' => 0,
                                                                                                    'mod' => '',
                                                                                                    'pattern' => '\'',
                                                                                                    'rdelim' => '/'
                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Token' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 1,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'SingleQuotedString' => bless( {
                                                               'calls' => [
                                                                            'SingleQuote'
                                                                          ],
                                                               'changed' => 0,
                                                               'impcount' => 0,
                                                               'line' => 60,
                                                               'name' => 'SingleQuotedString',
                                                               'opcount' => 0,
                                                               'prods' => [
                                                                            bless( {
                                                                                     'actcount' => 1,
                                                                                     'dircount' => 0,
                                                                                     'error' => undef,
                                                                                     'items' => [
                                                                                                  bless( {
                                                                                                           'argcode' => undef,
                                                                                                           'implicit' => undef,
                                                                                                           'line' => 60,
                                                                                                           'lookahead' => 0,
                                                                                                           'matchrule' => 0,
                                                                                                           'subrule' => 'SingleQuote'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                                  bless( {
                                                                                                           'description' => '/(\\\\\\\\\'|\\\\n|[^\'])*/',
                                                                                                           'hashname' => '__PATTERN1__',
                                                                                                           'ldelim' => '/',
                                                                                                           'line' => 60,
                                                                                                           'lookahead' => 0,
                                                                                                           'mod' => '',
                                                                                                           'pattern' => '(\\\\\'|\\n|[^\'])*',
                                                                                                           'rdelim' => '/'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Token' ),
                                                                                                  bless( {
                                                                                                           'argcode' => undef,
                                                                                                           'implicit' => undef,
                                                                                                           'line' => 60,
                                                                                                           'lookahead' => 0,
                                                                                                           'matchrule' => 0,
                                                                                                           'subrule' => 'SingleQuote'
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                                  bless( {
                                                                                                           'code' => '{
    $return = $item[2];
}',
                                                                                                           'hashname' => '__ACTION1__',
                                                                                                           'line' => 61,
                                                                                                           'lookahead' => 0
                                                                                                         }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                                ],
                                                                                     'line' => undef,
                                                                                     'number' => 0,
                                                                                     'patcount' => 1,
                                                                                     'strcount' => 0,
                                                                                     'uncommit' => undef
                                                                                   }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                          ],
                                                               'vars' => ''
                                                             }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'Slash' => bless( {
                                                  'calls' => [],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 81,
                                                  'name' => 'Slash',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 0,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'description' => '\'/\'',
                                                                                              'hashname' => '__STRING1__',
                                                                                              'line' => 81,
                                                                                              'lookahead' => 0,
                                                                                              'pattern' => '/'
                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Literal' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 1,
                                                                        'uncommit' => undef
                                                                      }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'String' => bless( {
                                                   'calls' => [],
                                                   'changed' => 0,
                                                   'impcount' => 0,
                                                   'line' => 72,
                                                   'name' => 'String',
                                                   'opcount' => 0,
                                                   'prods' => [
                                                                bless( {
                                                                         'actcount' => 1,
                                                                         'dircount' => 1,
                                                                         'error' => undef,
                                                                         'items' => [
                                                                                      bless( {
                                                                                               'code' => 'my $oldskip = $skip; $skip= \'\\s*\'; $oldskip',
                                                                                               'hashname' => '__DIRECTIVE1__',
                                                                                               'line' => 72,
                                                                                               'lookahead' => 0,
                                                                                               'name' => '<skip: \'\\s*\'>'
                                                                                             }, 'Config::File::RRJSON::ParserRuntime::Directive' ),
                                                                                      bless( {
                                                                                               'description' => '/[-!#$%&()*+.\\\\/0-9:;<=>?\\\\@A-Z^_`\\\\|~ \\\\t]+/i',
                                                                                               'hashname' => '__PATTERN1__',
                                                                                               'ldelim' => '/',
                                                                                               'line' => 72,
                                                                                               'lookahead' => 0,
                                                                                               'mod' => 'i',
                                                                                               'pattern' => '[-!#$%&()*+.\\/0-9:;<=>?\\@A-Z^_`\\|~ \\t]+',
                                                                                               'rdelim' => '/'
                                                                                             }, 'Config::File::RRJSON::ParserRuntime::Token' ),
                                                                                      bless( {
                                                                                               'code' => '{
    $item[2] =~ s/[,\\s]*$//;

    $return = $item[2];
}',
                                                                                               'hashname' => '__ACTION1__',
                                                                                               'line' => 73,
                                                                                               'lookahead' => 0
                                                                                             }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                    ],
                                                                         'line' => undef,
                                                                         'number' => 0,
                                                                         'patcount' => 1,
                                                                         'strcount' => 0,
                                                                         'uncommit' => undef
                                                                       }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                              ],
                                                   'vars' => ''
                                                 }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              '_alternation_1_of_production_1_of_rule_Def' => bless( {
                                                                                       'calls' => [
                                                                                                    '_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def',
                                                                                                    '_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def',
                                                                                                    '_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def'
                                                                                                  ],
                                                                                       'changed' => 0,
                                                                                       'impcount' => 1,
                                                                                       'line' => 111,
                                                                                       'name' => '_alternation_1_of_production_1_of_rule_Def',
                                                                                       'opcount' => 0,
                                                                                       'prods' => [
                                                                                                    bless( {
                                                                                                             'actcount' => 0,
                                                                                                             'dircount' => 0,
                                                                                                             'error' => undef,
                                                                                                             'items' => [
                                                                                                                          bless( {
                                                                                                                                   'argcode' => undef,
                                                                                                                                   'implicit' => 'Colon',
                                                                                                                                   'line' => 111,
                                                                                                                                   'lookahead' => 0,
                                                                                                                                   'matchrule' => 0,
                                                                                                                                   'subrule' => '_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def'
                                                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                        ],
                                                                                                             'line' => undef,
                                                                                                             'number' => 0,
                                                                                                             'patcount' => 0,
                                                                                                             'strcount' => 0,
                                                                                                             'uncommit' => undef
                                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                                                    bless( {
                                                                                                             'actcount' => 0,
                                                                                                             'dircount' => 0,
                                                                                                             'error' => undef,
                                                                                                             'items' => [
                                                                                                                          bless( {
                                                                                                                                   'argcode' => undef,
                                                                                                                                   'implicit' => 'Colon',
                                                                                                                                   'line' => 111,
                                                                                                                                   'lookahead' => 0,
                                                                                                                                   'matchrule' => 0,
                                                                                                                                   'subrule' => '_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def'
                                                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                        ],
                                                                                                             'line' => 111,
                                                                                                             'number' => 1,
                                                                                                             'patcount' => 0,
                                                                                                             'strcount' => 0,
                                                                                                             'uncommit' => undef
                                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                                                    bless( {
                                                                                                             'actcount' => 0,
                                                                                                             'dircount' => 0,
                                                                                                             'error' => undef,
                                                                                                             'items' => [
                                                                                                                          bless( {
                                                                                                                                   'argcode' => undef,
                                                                                                                                   'implicit' => 'Colon',
                                                                                                                                   'line' => 111,
                                                                                                                                   'lookahead' => 0,
                                                                                                                                   'matchrule' => 0,
                                                                                                                                   'subrule' => '_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def'
                                                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                        ],
                                                                                                             'line' => 111,
                                                                                                             'number' => 2,
                                                                                                             'patcount' => 0,
                                                                                                             'strcount' => 0,
                                                                                                             'uncommit' => undef
                                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                                                  ],
                                                                                       'vars' => ''
                                                                                     }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              '_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def' => bless( {
                                                                                                                              'calls' => [
                                                                                                                                           'Colon',
                                                                                                                                           'Hash'
                                                                                                                                         ],
                                                                                                                              'changed' => 0,
                                                                                                                              'impcount' => 0,
                                                                                                                              'line' => 111,
                                                                                                                              'name' => '_alternation_1_of_production_1_of_rule__alternation_1_of_production_1_of_rule_Def',
                                                                                                                              'opcount' => 0,
                                                                                                                              'prods' => [
                                                                                                                                           bless( {
                                                                                                                                                    'actcount' => 0,
                                                                                                                                                    'dircount' => 0,
                                                                                                                                                    'error' => undef,
                                                                                                                                                    'items' => [
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'expected' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'max' => 1,
                                                                                                                                                                          'min' => 0,
                                                                                                                                                                          'repspec' => '?',
                                                                                                                                                                          'subrule' => 'Colon'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Repetition' ),
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'implicit' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'subrule' => 'Hash'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                                                               ],
                                                                                                                                                    'line' => undef,
                                                                                                                                                    'number' => 0,
                                                                                                                                                    'patcount' => 0,
                                                                                                                                                    'strcount' => 0,
                                                                                                                                                    'uncommit' => undef
                                                                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                                                                                         ],
                                                                                                                              'vars' => ''
                                                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              '_alternation_1_of_production_1_of_rule_startrule' => bless( {
                                                                                             'calls' => [
                                                                                                          'Comment',
                                                                                                          'Def'
                                                                                                        ],
                                                                                             'changed' => 0,
                                                                                             'impcount' => 0,
                                                                                             'line' => 111,
                                                                                             'name' => '_alternation_1_of_production_1_of_rule_startrule',
                                                                                             'opcount' => 0,
                                                                                             'prods' => [
                                                                                                          bless( {
                                                                                                                   'actcount' => 0,
                                                                                                                   'dircount' => 0,
                                                                                                                   'error' => undef,
                                                                                                                   'items' => [
                                                                                                                                bless( {
                                                                                                                                         'argcode' => undef,
                                                                                                                                         'implicit' => undef,
                                                                                                                                         'line' => 111,
                                                                                                                                         'lookahead' => 0,
                                                                                                                                         'matchrule' => 0,
                                                                                                                                         'subrule' => 'Comment'
                                                                                                                                       }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                              ],
                                                                                                                   'line' => undef,
                                                                                                                   'number' => 0,
                                                                                                                   'patcount' => 0,
                                                                                                                   'strcount' => 0,
                                                                                                                   'uncommit' => undef
                                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Production' ),
                                                                                                          bless( {
                                                                                                                   'actcount' => 0,
                                                                                                                   'dircount' => 0,
                                                                                                                   'error' => undef,
                                                                                                                   'items' => [
                                                                                                                                bless( {
                                                                                                                                         'argcode' => undef,
                                                                                                                                         'implicit' => undef,
                                                                                                                                         'line' => 111,
                                                                                                                                         'lookahead' => 0,
                                                                                                                                         'matchrule' => 0,
                                                                                                                                         'subrule' => 'Def'
                                                                                                                                       }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                              ],
                                                                                                                   'line' => 111,
                                                                                                                   'number' => 1,
                                                                                                                   'patcount' => 0,
                                                                                                                   'strcount' => 0,
                                                                                                                   'uncommit' => undef
                                                                                                                 }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                                                        ],
                                                                                             'vars' => ''
                                                                                           }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              '_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def' => bless( {
                                                                                                                              'calls' => [
                                                                                                                                           'Colon',
                                                                                                                                           'Array'
                                                                                                                                         ],
                                                                                                                              'changed' => 0,
                                                                                                                              'impcount' => 0,
                                                                                                                              'line' => 111,
                                                                                                                              'name' => '_alternation_1_of_production_2_of_rule__alternation_1_of_production_1_of_rule_Def',
                                                                                                                              'opcount' => 0,
                                                                                                                              'prods' => [
                                                                                                                                           bless( {
                                                                                                                                                    'actcount' => 0,
                                                                                                                                                    'dircount' => 0,
                                                                                                                                                    'error' => undef,
                                                                                                                                                    'items' => [
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'expected' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'max' => 1,
                                                                                                                                                                          'min' => 0,
                                                                                                                                                                          'repspec' => '?',
                                                                                                                                                                          'subrule' => 'Colon'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Repetition' ),
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'implicit' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'subrule' => 'Array'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                                                               ],
                                                                                                                                                    'line' => undef,
                                                                                                                                                    'number' => 0,
                                                                                                                                                    'patcount' => 0,
                                                                                                                                                    'strcount' => 0,
                                                                                                                                                    'uncommit' => undef
                                                                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                                                                                         ],
                                                                                                                              'vars' => ''
                                                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              '_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def' => bless( {
                                                                                                                              'calls' => [
                                                                                                                                           'Colon',
                                                                                                                                           'AnyString'
                                                                                                                                         ],
                                                                                                                              'changed' => 0,
                                                                                                                              'impcount' => 0,
                                                                                                                              'line' => 111,
                                                                                                                              'name' => '_alternation_1_of_production_3_of_rule__alternation_1_of_production_1_of_rule_Def',
                                                                                                                              'opcount' => 0,
                                                                                                                              'prods' => [
                                                                                                                                           bless( {
                                                                                                                                                    'actcount' => 0,
                                                                                                                                                    'dircount' => 0,
                                                                                                                                                    'error' => undef,
                                                                                                                                                    'items' => [
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'implicit' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'subrule' => 'Colon'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                                                                                                 bless( {
                                                                                                                                                                          'argcode' => undef,
                                                                                                                                                                          'implicit' => undef,
                                                                                                                                                                          'line' => 111,
                                                                                                                                                                          'lookahead' => 0,
                                                                                                                                                                          'matchrule' => 0,
                                                                                                                                                                          'subrule' => 'AnyString'
                                                                                                                                                                        }, 'Config::File::RRJSON::ParserRuntime::Subrule' )
                                                                                                                                                               ],
                                                                                                                                                    'line' => undef,
                                                                                                                                                    'number' => 0,
                                                                                                                                                    'patcount' => 0,
                                                                                                                                                    'strcount' => 0,
                                                                                                                                                    'uncommit' => undef
                                                                                                                                                  }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                                                                                         ],
                                                                                                                              'vars' => ''
                                                                                                                            }, 'Config::File::RRJSON::ParserRuntime::Rule' ),
                              'startrule' => bless( {
                                                      'calls' => [
                                                                   '_alternation_1_of_production_1_of_rule_startrule',
                                                                   'EOF'
                                                                 ],
                                                      'changed' => 0,
                                                      'impcount' => 1,
                                                      'line' => 11,
                                                      'name' => 'startrule',
                                                      'opcount' => 0,
                                                      'prods' => [
                                                                   bless( {
                                                                            'actcount' => 1,
                                                                            'dircount' => 1,
                                                                            'error' => undef,
                                                                            'items' => [
                                                                                         bless( {
                                                                                                  'code' => 'my $oldskip = $skip; $skip= qr{(?xs:
          (?: \\s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\\n]* \\n?             # End of line comment
          )
       )*}; $oldskip',
                                                                                                  'hashname' => '__DIRECTIVE1__',
                                                                                                  'line' => 12,
                                                                                                  'lookahead' => 0,
                                                                                                  'name' => '<skip: qr{(?xs:
          (?: \\s+                       # Whitespace
          |   /[*] (?:(?![*]/).)* [*]/  # Inline comment
          |   // [^\\n]* \\n?             # End of line comment
          )
       )*}>'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Directive' ),
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'expected' => 'Comment, or Def',
                                                                                                  'line' => 18,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'max' => 100000000,
                                                                                                  'min' => 1,
                                                                                                  'repspec' => 's',
                                                                                                  'subrule' => '_alternation_1_of_production_1_of_rule_startrule'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Repetition' ),
                                                                                         bless( {
                                                                                                  'argcode' => undef,
                                                                                                  'implicit' => undef,
                                                                                                  'line' => 19,
                                                                                                  'lookahead' => 0,
                                                                                                  'matchrule' => 0,
                                                                                                  'subrule' => 'EOF'
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Subrule' ),
                                                                                         bless( {
                                                                                                  'code' => '{ $item[2] }',
                                                                                                  'hashname' => '__ACTION1__',
                                                                                                  'line' => 20,
                                                                                                  'lookahead' => 0
                                                                                                }, 'Config::File::RRJSON::ParserRuntime::Action' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 0,
                                                                            'uncommit' => undef
                                                                          }, 'Config::File::RRJSON::ParserRuntime::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Config::File::RRJSON::ParserRuntime::Rule' )
                            },
                 'startcode' => ''
               }, 'Config::File::RRJSON::ParserRuntime' );
}