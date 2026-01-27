#
# This parser was generated with
# Parse::RecDescent version 1.967015
#

package Config::File::Parser;
use Parse::RecDescent;
{ my $ERRORS;


package Parse::RecDescent::Config::File::Parser;
use strict;
use vars qw($skip $AUTOLOAD  );
@Parse::RecDescent::Config::File::Parser::ISA = ();
$skip = '\\s*';

 
#    $::RD_ERRORS = 1;
#    $::RD_WARN = 3;
#    $::RD_TRACE = 1;

	# declare some global variables 
	$::actSectionName = 'global';
    $::actSection = undef;
	$::varPrefix = '';
	$::varSuffix = '';
	$::comment   = '';
;


{
local $SIG{__WARN__} = sub {0};
# PRETEND TO BE IN Parse::RecDescent NAMESPACE
*Parse::RecDescent::Config::File::Parser::AUTOLOAD   = sub
{
    no strict 'refs';

    ${"AUTOLOAD"} =~ s/^Parse::RecDescent::Config::File::Parser/Parse::RecDescent/;
    goto &{${"AUTOLOAD"}};
}
}

push @Parse::RecDescent::Config::File::Parser::ISA, 'Parse::RecDescent';
# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::At
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"At"};

    Parse::RecDescent::_trace(q{Trying rule: [At]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'@'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['@']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{At});
        %item = (__RULE__ => q{At});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['@']},
                      Parse::RecDescent::_tracefirst($text),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\@/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['@']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{At},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{At},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{At},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{At},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::CloseBrace
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"CloseBrace"};

    Parse::RecDescent::_trace(q{Trying rule: [CloseBrace]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'\}'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['\}']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{CloseBrace});
        %item = (__RULE__ => q{CloseBrace});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['\}']},
                      Parse::RecDescent::_tracefirst($text),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\}/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['\}']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{CloseBrace},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{CloseBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{CloseBrace},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{CloseBrace},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::CloseBracket
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"CloseBracket"};

    Parse::RecDescent::_trace(q{Trying rule: [CloseBracket]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{']'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [']']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{CloseBracket});
        %item = (__RULE__ => q{CloseBracket});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [']']},
                      Parse::RecDescent::_tracefirst($text),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\]/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [']']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{CloseBracket},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{CloseBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{CloseBracket},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{CloseBracket},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Comment
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Comment"};

    Parse::RecDescent::_trace(q{Trying rule: [Comment]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{/[#]/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [/[#]/ /[^\\n]*/]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Comment});
        %item = (__RULE__ => q{Comment});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [/[#]/]}, Parse::RecDescent::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[#])/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying terminal: [/[^\\n]*/]}, Parse::RecDescent::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[^\\n]*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[^\n]*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN2__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				$::comment .= "\n" if $::comment;
				$::comment .= $item[2];
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [/[#]/ /[^\\n]*/]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Comment},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Comment},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Comment},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Comment},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::DoubleQuote
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"DoubleQuote"};

    Parse::RecDescent::_trace(q{Trying rule: [DoubleQuote]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'"'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['"']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{DoubleQuote});
        %item = (__RULE__ => q{DoubleQuote});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['"']},
                      Parse::RecDescent::_tracefirst($text),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\"/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['"']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{DoubleQuote},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{DoubleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{DoubleQuote},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{DoubleQuote},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::EOF
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"EOF"};

    Parse::RecDescent::_trace(q{Trying rule: [EOF]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{/^\\Z/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [/^\\Z/]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{EOF});
        %item = (__RULE__ => q{EOF});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [/^\\Z/]}, Parse::RecDescent::_tracefirst($text),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:^\Z)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [/^\\Z/]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{EOF},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{EOF},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{EOF},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{EOF},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::EqualSign
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"EqualSign"};

    Parse::RecDescent::_trace(q{Trying rule: [EqualSign]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{EqualSign},
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
    my $expectation = new Parse::RecDescent::Expectation(q{'='});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['=']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{EqualSign},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{EqualSign});
        %item = (__RULE__ => q{EqualSign});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['=']},
                      Parse::RecDescent::_tracefirst($text),
                      q{EqualSign},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\=/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['=']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{EqualSign},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{EqualSign},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{EqualSign},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{EqualSign},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{EqualSign},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::File
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"File"};

    Parse::RecDescent::_trace(q{Trying rule: [File]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{File},
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
    my $expectation = new Parse::RecDescent::Expectation(q{Line});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Line EOF]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{File},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{File});
        %item = (__RULE__ => q{File});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying repeated subrule: [Line]},
                  Parse::RecDescent::_tracefirst($text),
                  q{File},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Parse::RecDescent::Config::File::Parser::Line, 1, 100000000, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Parse::RecDescent::_trace(q{<<Didn't match repeated subrule: [Line]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{File},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched repeated subrule: [Line]<< (}
                    . @$_tok . q{ times)},

                      Parse::RecDescent::_tracefirst($text),
                      q{File},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Line(s)}} = $_tok;
        push @item, $_tok;
        


        Parse::RecDescent::_trace(q{Trying subrule: [EOF]},
                  Parse::RecDescent::_tracefirst($text),
                  q{File},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{EOF})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::EOF($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [EOF]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{File},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [EOF]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{File},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{EOF}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{>>Matched production: [Line EOF]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{File},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{File},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{File},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{File},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{File},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Line
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Line"};

    Parse::RecDescent::_trace(q{Trying rule: [Line]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{Line},
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
    my $expectation = new Parse::RecDescent::Expectation(q{Comment, or Section, or VariableDef});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Comment]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Line});
        %item = (__RULE__ => q{Line});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [Comment]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Line},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Comment($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Comment]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Line},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Comment]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Comment}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{>>Matched production: [Comment]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Section]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{Line});
        %item = (__RULE__ => q{Line});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [Section]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Line},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Section($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Section]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Line},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Section]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Section}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{>>Matched production: [Section]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [VariableDef]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{Line});
        %item = (__RULE__ => q{Line});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [VariableDef]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Line},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::VariableDef($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [VariableDef]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Line},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [VariableDef]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{VariableDef}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{>>Matched production: [VariableDef]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Line},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Line},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Line},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Line},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Minus
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Minus"};

    Parse::RecDescent::_trace(q{Trying rule: [Minus]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'-'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['-']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Minus});
        %item = (__RULE__ => q{Minus});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['-']},
                      Parse::RecDescent::_tracefirst($text),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\-/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['-']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Minus},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Minus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Minus},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Minus},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Name
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Name"};

    Parse::RecDescent::_trace(q{Trying rule: [Name]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{Name},
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
    my $expectation = new Parse::RecDescent::Expectation(q{/[-.: \\t\\w()]+/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [/[-.: \\t\\w()]+/]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Name},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Name});
        %item = (__RULE__ => q{Name});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [/[-.: \\t\\w()]+/]}, Parse::RecDescent::_tracefirst($text),
                      q{Name},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[-.: \t\w()]+)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [/[-.: \\t\\w()]+/]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Name},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Name},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Name},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Name},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Name},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::OpenBrace
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"OpenBrace"};

    Parse::RecDescent::_trace(q{Trying rule: [OpenBrace]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'\{'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['\{']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{OpenBrace});
        %item = (__RULE__ => q{OpenBrace});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['\{']},
                      Parse::RecDescent::_tracefirst($text),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\{/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['\{']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{OpenBrace},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{OpenBrace},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{OpenBrace},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{OpenBrace},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::OpenBracket
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"OpenBracket"};

    Parse::RecDescent::_trace(q{Trying rule: [OpenBracket]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'['});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['[']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{OpenBracket});
        %item = (__RULE__ => q{OpenBracket});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['[']},
                      Parse::RecDescent::_tracefirst($text),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\[/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['[']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{OpenBracket},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{OpenBracket},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{OpenBracket},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{OpenBracket},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Plus
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Plus"};

    Parse::RecDescent::_trace(q{Trying rule: [Plus]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{'+'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['+']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Plus});
        %item = (__RULE__ => q{Plus});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['+']},
                      Parse::RecDescent::_tracefirst($text),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\+/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['+']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Plus},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Plus},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Plus},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Plus},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Section
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Section"};

    Parse::RecDescent::_trace(q{Trying rule: [Section]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{Section},
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
    my $expectation = new Parse::RecDescent::Expectation(q{SectionPrefix});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [SectionPrefix Name SectionSuffix]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Section});
        %item = (__RULE__ => q{Section});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [SectionPrefix]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Section},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::SectionPrefix($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [SectionPrefix]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Section},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [SectionPrefix]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SectionPrefix}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Section},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Name})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Section},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [SectionSuffix]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Section},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{SectionSuffix})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::SectionSuffix($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [SectionSuffix]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Section},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [SectionSuffix]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SectionSuffix}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do { 
				# let's store the section name, if it's a new one
				$::actSectionName = $item[2] if $::actSectionName ne $item[2];
#				$::actSectionName = lc $::actSectionName
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$::actSection = $thisparser->{_config}->Section($::actSectionName);
				if ($::comment && $::actSection)
				{
					$::actSection->Comment($::comment);
					$::comment = '';
				}
				1;
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [SectionPrefix Name SectionSuffix]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Section},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Section},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Section},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Section},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::SectionPrefix
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SectionPrefix"};

    Parse::RecDescent::_trace(q{Trying rule: [SectionPrefix]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{SectionPrefix},
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
    my $expectation = new Parse::RecDescent::Expectation(q{'['});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: ['[']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{SectionPrefix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SectionPrefix});
        %item = (__RULE__ => q{SectionPrefix});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: ['[']},
                      Parse::RecDescent::_tracefirst($text),
                      q{SectionPrefix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\[/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: ['[']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{SectionPrefix},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{SectionPrefix},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{SectionPrefix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SectionPrefix},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{SectionPrefix},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::SectionSuffix
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SectionSuffix"};

    Parse::RecDescent::_trace(q{Trying rule: [SectionSuffix]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{SectionSuffix},
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
    my $expectation = new Parse::RecDescent::Expectation(q{']'});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [']']},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{SectionSuffix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SectionSuffix});
        %item = (__RULE__ => q{SectionSuffix});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [']']},
                      Parse::RecDescent::_tracefirst($text),
                      q{SectionSuffix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A\]/)
        {
            $text = $lastsep . $text if defined $lastsep;
            
            $expectation->failed();
            Parse::RecDescent::_trace(qq{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        push @item, $item{__STRING1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [']']<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{SectionSuffix},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{SectionSuffix},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{SectionSuffix},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SectionSuffix},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{SectionSuffix},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::SingleQuote
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"SingleQuote"};

    Parse::RecDescent::_trace(q{Trying rule: [SingleQuote]},
                  Parse::RecDescent::_tracefirst($_[1]),
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
    my $expectation = new Parse::RecDescent::Expectation(q{/'/});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [/'/]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{SingleQuote});
        %item = (__RULE__ => q{SingleQuote});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [/'/]}, Parse::RecDescent::_tracefirst($text),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:')/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [/'/]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{SingleQuote},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{SingleQuote},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{SingleQuote},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{SingleQuote},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::Value
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"Value"};

    Parse::RecDescent::_trace(q{Trying rule: [Value]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{Value},
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
    my $expectation = new Parse::RecDescent::Expectation(q{/[^"'\\n\\r]+/, or DoubleQuote, or SingleQuote, or OpenBracket, or OpenBrace});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [/[^"'\\n\\r]+/]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{Value});
        %item = (__RULE__ => q{Value});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying terminal: [/[^"'\\n\\r]+/]}, Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[^"'\n\r]+)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{>>Matched production: [/[^"'\\n\\r]+/]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [DoubleQuote /(\\\\"|\\n|[^"])*/ DoubleQuote]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{Value});
        %item = (__RULE__ => q{Value});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [DoubleQuote]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::DoubleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [DoubleQuote]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [DoubleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying terminal: [/(\\\\"|\\n|[^"])*/]}, Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/(\\\\"|\\n|[^"])*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:(\\"|\n|[^"])*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying subrule: [DoubleQuote]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{DoubleQuote})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::DoubleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [DoubleQuote]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [DoubleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{DoubleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [DoubleQuote /(\\\\"|\\n|[^"])*/ DoubleQuote]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [SingleQuote /(\\\\'|\\n|[^'])*/ SingleQuote]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{Value});
        %item = (__RULE__ => q{Value});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [SingleQuote]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::SingleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [SingleQuote]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [SingleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying terminal: [/(\\\\'|\\n|[^'])*/]}, Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/(\\\\'|\\n|[^'])*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:(\\'|\n|[^'])*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying subrule: [SingleQuote]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{SingleQuote})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::SingleQuote($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [SingleQuote]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [SingleQuote]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{SingleQuote}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [SingleQuote /(\\\\'|\\n|[^'])*/ SingleQuote]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [OpenBracket /[^"']*/ CloseBracket]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[3];
        $text = $_[1];
        my $_savetext;
        @item = (q{Value});
        %item = (__RULE__ => q{Value});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [OpenBracket]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::OpenBracket($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [OpenBracket]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [OpenBracket]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{OpenBracket}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying terminal: [/[^"']*/]}, Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[^"']*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[^"']*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying subrule: [CloseBracket]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{CloseBracket})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::CloseBracket($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [CloseBracket]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [CloseBracket]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{CloseBracket}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [OpenBracket /[^"']*/ CloseBracket]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [OpenBrace /[^"']*/ CloseBrace]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[4];
        $text = $_[1];
        my $_savetext;
        @item = (q{Value});
        %item = (__RULE__ => q{Value});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [OpenBrace]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::OpenBrace($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [OpenBrace]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [OpenBrace]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{OpenBrace}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying terminal: [/[^"']*/]}, Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[^"']*/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[^"']*)/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        Parse::RecDescent::_trace(q{Trying subrule: [CloseBrace]},
                  Parse::RecDescent::_tracefirst($text),
                  q{Value},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{CloseBrace})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::CloseBrace($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [CloseBrace]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{Value},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [CloseBrace]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{CloseBrace}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [OpenBrace /[^"']*/ CloseBrace]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{Value},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{Value},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{Value},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{Value},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}

# ARGS ARE: ($parser, $text; $repeating, $_noactions, \@args, $_itempos)
sub Parse::RecDescent::Config::File::Parser::VariableDef
{
	my $thisparser = $_[0];
	use vars q{$tracelevel};
	local $tracelevel = ($tracelevel||0)+1;
	$ERRORS = 0;
    my $thisrule = $thisparser->{"rules"}{"VariableDef"};

    Parse::RecDescent::_trace(q{Trying rule: [VariableDef]},
                  Parse::RecDescent::_tracefirst($_[1]),
                  q{VariableDef},
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
    my $expectation = new Parse::RecDescent::Expectation(q{Name, or Minus, or Plus, or At});
    $expectation->at($_[1]);
    
    my $thisline;
    tie $thisline, q{Parse::RecDescent::LineCounter}, \$text, $thisparser;

    

    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Name EqualSign /[\\n\\r]/ <commit>]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[0];
        $text = $_[1];
        my $_savetext;
        @item = (q{VariableDef});
        %item = (__RULE__ => q{VariableDef});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [EqualSign]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{EqualSign})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::EqualSign($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [EqualSign]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [EqualSign]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{EqualSign}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying terminal: [/[\\n\\r]/]}, Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        undef $lastsep;
        $expectation->is(q{/[\\n\\r]/})->at($text);
        

        unless ($text =~ s/\A($skip)/$lastsep=$1 and ""/e and   $text =~ m/\A(?:[\n\r])/)
        {
            $text = $lastsep . $text if defined $lastsep;
            $expectation->failed();
            Parse::RecDescent::_trace(q{<<Didn't match terminal>>},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;

            last;
        }
        $current_match = substr($text, $-[0], $+[0] - $-[0]);
        substr($text,0,length($current_match),q{});
        Parse::RecDescent::_trace(q{>>Matched terminal<< (return value: [}
                        . $current_match . q{])},
                          Parse::RecDescent::_tracefirst($text))
                    if defined $::RD_TRACE;
        push @item, $item{__PATTERN1__}=$current_match;
        

        

        Parse::RecDescent::_trace(q{Trying directive: [<commit>]},
                    Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE; 
        $_tok = do { $commit = 1 };
        if (defined($_tok))
        {
            Parse::RecDescent::_trace(q{>>Matched directive<< (return value: [}
                        . $_tok . q{])},
                        Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        else
        {
            Parse::RecDescent::_trace(q{<<Didn't match directive>>},
                        Parse::RecDescent::_tracefirst($text))
                            if defined $::RD_TRACE;
        }
        
        last unless defined $_tok;
        push @item, $item{__DIRECTIVE1__}=$_tok;
        

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# create a new variable or add the value
				if ($thisparser->{_config})
				{
					$item[1] =~ s/^\s*//;
					$item[1] =~ s/\s*$//;
					$item[3] =~ s/^\s*//;
					$item[3] =~ s/\s*$//;
#					$item[1] = lc $item[1]
#						unless $thisparser->{_config}->{_options}->{MODE} & 2;
					$thisparser->{_config}->Variable($::actSectionName, 
													 '+' . $item[1], 
													 '');
					if ($::varPrefix || $::varSuffix)
					{
						$thisparser->{_config}->Delimiters($::actSectionName,
														   $item[1],
														   $::varPrefix,
														   $::varSuffix);
						$::varPrefix = $::varSuffix = undef;
					}

					if ($::comment && $::actSection)
					{
						$::actSection->{_variables}->{$item[1]}->Comment($::comment);
						$::comment = '';
					}
				}
				1;
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [Name EqualSign /[\\n\\r]/ <commit>]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Name EqualSign Value]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[1];
        $text = $_[1];
        my $_savetext;
        @item = (q{VariableDef});
        %item = (__RULE__ => q{VariableDef});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [EqualSign]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{EqualSign})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::EqualSign($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [EqualSign]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [EqualSign]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{EqualSign}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [Value]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Value})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Value($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Value]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Value]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Value}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				# create a new variable or add the value
				if ($thisparser->{_config})
				{
					$item[1] =~ s/^\s*//;
					$item[1] =~ s/\s*$//;
					$item[3] =~ s/^\s*//;
					$item[3] =~ s/\s*$//;
#					$item[1] = lc $item[1]
#						unless $thisparser->{_config}->{_options}->{MODE} & 2;
					$thisparser->{_config}->Variable($::actSectionName, 
													 '+' . $item[1], 
													 $item[3]);
					if ($::varPrefix || $::varSuffix)
					{
						$thisparser->{_config}->Delimiters($::actSectionName,
														   $item[1],
														   $::varPrefix,
														   $::varSuffix);
						$::varPrefix = $::varSuffix = undef;
					}

					if ($::comment && $::actSection)
					{
						$::actSection->{_variables}->{$item[1]}->Comment($::comment);
						$::comment = '';
					}
				}
				1;
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [Name EqualSign Value]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Minus Name]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[2];
        $text = $_[1];
        my $_savetext;
        @item = (q{VariableDef});
        %item = (__RULE__ => q{VariableDef});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [Minus]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Minus($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Minus]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Minus]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Minus}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Name})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				$item[2] =~ s/^\s*|\s*$//;
#				$item[2] = lc $item[2]
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$thisparser->{_config}->Variable($::actSectionName,
												 $item[2],
												 0);

				if ($::comment && $::actSection)
				{
					$::actSection->{_variables}->{$item[2]}->Comment($::comment);
					$::comment = '';
				}

				1;
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [Minus Name]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [Plus Name]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[3];
        $text = $_[1];
        my $_savetext;
        @item = (q{VariableDef});
        %item = (__RULE__ => q{VariableDef});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying repeated subrule: [Plus]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        $expectation->is(q{})->at($text);
        
        unless (defined ($_tok = $thisparser->_parserepeat($text, \&Parse::RecDescent::Config::File::Parser::Plus, 0, 1, $_noactions,$expectation,sub { \@arg },undef)))
        {
            Parse::RecDescent::_trace(q{<<Didn't match repeated subrule: [Plus]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched repeated subrule: [Plus]<< (}
                    . @$_tok . q{ times)},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Plus(?)}} = $_tok;
        push @item, $_tok;
        


        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Name})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
				$item[2] =~ s/^\s*|\s*$//;
#				$item[2] = lc $item[2]
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$thisparser->{_config}->Variable($::actSectionName,
												 $item[2],
												 1);

				if ($::comment && $::actSection)
				{
					$::actSection->{_variables}->{$item[2]}->Comment($::comment);
					$::comment = '';
				}

				1;
			};
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [Plus Name]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    while (!$_matched && !$commit)
    {
        
        Parse::RecDescent::_trace(q{Trying production: [At Name]},
                      Parse::RecDescent::_tracefirst($_[1]),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        my $thisprod = $thisrule->{"prods"}[4];
        $text = $_[1];
        my $_savetext;
        @item = (q{VariableDef});
        %item = (__RULE__ => q{VariableDef});
        my $repcount = 0;


        Parse::RecDescent::_trace(q{Trying subrule: [At]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::At($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [At]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [At]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{At}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying subrule: [Name]},
                  Parse::RecDescent::_tracefirst($text),
                  q{VariableDef},
                  $tracelevel)
                    if defined $::RD_TRACE;
        if (1) { no strict qw{refs};
        $expectation->is(q{Name})->at($text);
        unless (defined ($_tok = Parse::RecDescent::Config::File::Parser::Name($thisparser,$text,$repeating,$_noactions,sub { \@arg },undef)))
        {
            
            Parse::RecDescent::_trace(q{<<Didn't match subrule: [Name]>>},
                          Parse::RecDescent::_tracefirst($text),
                          q{VariableDef},
                          $tracelevel)
                            if defined $::RD_TRACE;
            $expectation->failed();
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched subrule: [Name]<< (return value: [}
                    . $_tok . q{]},

                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $item{q{Name}} = $_tok;
        push @item, $_tok;
        
        }

        Parse::RecDescent::_trace(q{Trying action},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        

        $_tok = ($_noactions) ? 0 : do {
                $item[2] =~ s/^\s*|\s*$//;
                $thisparser->{_config}->IncludeSection($::actSectionName, $item[2]);

                if ($::comment && $::actSection)
                {
                    $::actSection->Comment($::comment);
					$::comment = '';
                }
            };
        unless (defined $_tok)
        {
            Parse::RecDescent::_trace(q{<<Didn't match action>> (return value: [undef])})
                    if defined $::RD_TRACE;
            last;
        }
        Parse::RecDescent::_trace(q{>>Matched action<< (return value: [}
                      . $_tok . q{])},
                      Parse::RecDescent::_tracefirst($text))
                        if defined $::RD_TRACE;
        push @item, $_tok;
        $item{__ACTION1__}=$_tok;
        

        Parse::RecDescent::_trace(q{>>Matched production: [At Name]<<},
                      Parse::RecDescent::_tracefirst($text),
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;



        $_matched = 1;
        last;
    }


    unless ( $_matched || defined($score) )
    {
        

        $_[1] = $text;  # NOT SURE THIS IS NEEDED
        Parse::RecDescent::_trace(q{<<Didn't match rule>>},
                     Parse::RecDescent::_tracefirst($_[1]),
                     q{VariableDef},
                     $tracelevel)
                    if defined $::RD_TRACE;
        return undef;
    }
    if (!defined($return) && defined($score))
    {
        Parse::RecDescent::_trace(q{>>Accepted scored production<<}, "",
                      q{VariableDef},
                      $tracelevel)
                        if defined $::RD_TRACE;
        $return = $score_return;
    }
    splice @{$thisparser->{errors}}, $err_at;
    $return = $item[$#item] unless defined $return;
    if (defined $::RD_TRACE)
    {
        Parse::RecDescent::_trace(q{>>Matched rule<< (return value: [} .
                      $return . q{])}, "",
                      q{VariableDef},
                      $tracelevel);
        Parse::RecDescent::_trace(q{(consumed: [} .
                      Parse::RecDescent::_tracemax(substr($_[1],0,-length($text))) . q{])},
                      Parse::RecDescent::_tracefirst($text),
                      , q{VariableDef},
                      $tracelevel)
    }
    $_[1] = $text;
    return $return;
}
}
package Config::File::Parser; sub new { my $self = bless( {
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
                 'namespace' => 'Parse::RecDescent::Config::File::Parser',
                 'rules' => {
                              'At' => bless( {
                                               'calls' => [],
                                               'changed' => 0,
                                               'impcount' => 0,
                                               'line' => 187,
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
                                                                                           'line' => 187,
                                                                                           'lookahead' => 0,
                                                                                           'pattern' => '@'
                                                                                         }, 'Parse::RecDescent::Literal' )
                                                                                ],
                                                                     'line' => undef,
                                                                     'number' => 0,
                                                                     'patcount' => 0,
                                                                     'strcount' => 1,
                                                                     'uncommit' => undef
                                                                   }, 'Parse::RecDescent::Production' )
                                                          ],
                                               'vars' => ''
                                             }, 'Parse::RecDescent::Rule' ),
                              'CloseBrace' => bless( {
                                                       'calls' => [],
                                                       'changed' => 0,
                                                       'impcount' => 0,
                                                       'line' => 199,
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
                                                                                                   'line' => 199,
                                                                                                   'lookahead' => 0,
                                                                                                   'pattern' => '}'
                                                                                                 }, 'Parse::RecDescent::Literal' )
                                                                                        ],
                                                                             'line' => undef,
                                                                             'number' => 0,
                                                                             'patcount' => 0,
                                                                             'strcount' => 1,
                                                                             'uncommit' => undef
                                                                           }, 'Parse::RecDescent::Production' )
                                                                  ],
                                                       'vars' => ''
                                                     }, 'Parse::RecDescent::Rule' ),
                              'CloseBracket' => bless( {
                                                         'calls' => [],
                                                         'changed' => 0,
                                                         'impcount' => 0,
                                                         'line' => 195,
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
                                                                                                     'line' => 195,
                                                                                                     'lookahead' => 0,
                                                                                                     'pattern' => ']'
                                                                                                   }, 'Parse::RecDescent::Literal' )
                                                                                          ],
                                                                               'line' => undef,
                                                                               'number' => 0,
                                                                               'patcount' => 0,
                                                                               'strcount' => 1,
                                                                               'uncommit' => undef
                                                                             }, 'Parse::RecDescent::Production' )
                                                                    ],
                                                         'vars' => ''
                                                       }, 'Parse::RecDescent::Rule' ),
                              'Comment' => bless( {
                                                    'calls' => [],
                                                    'changed' => 0,
                                                    'impcount' => 0,
                                                    'line' => 17,
                                                    'name' => 'Comment',
                                                    'opcount' => 0,
                                                    'prods' => [
                                                                 bless( {
                                                                          'actcount' => 1,
                                                                          'dircount' => 0,
                                                                          'error' => undef,
                                                                          'items' => [
                                                                                       bless( {
                                                                                                'description' => '/[#]/',
                                                                                                'hashname' => '__PATTERN1__',
                                                                                                'ldelim' => '/',
                                                                                                'line' => 17,
                                                                                                'lookahead' => 0,
                                                                                                'mod' => '',
                                                                                                'pattern' => '[#]',
                                                                                                'rdelim' => '/'
                                                                                              }, 'Parse::RecDescent::Token' ),
                                                                                       bless( {
                                                                                                'description' => '/[^\\\\n]*/',
                                                                                                'hashname' => '__PATTERN2__',
                                                                                                'ldelim' => '/',
                                                                                                'line' => 17,
                                                                                                'lookahead' => 0,
                                                                                                'mod' => '',
                                                                                                'pattern' => '[^\\n]*',
                                                                                                'rdelim' => '/'
                                                                                              }, 'Parse::RecDescent::Token' ),
                                                                                       bless( {
                                                                                                'code' => '{
				$::comment .= "\\n" if $::comment;
				$::comment .= $item[2];
			}',
                                                                                                'hashname' => '__ACTION1__',
                                                                                                'line' => 18,
                                                                                                'lookahead' => 0
                                                                                              }, 'Parse::RecDescent::Action' )
                                                                                     ],
                                                                          'line' => undef,
                                                                          'number' => 0,
                                                                          'patcount' => 2,
                                                                          'strcount' => 0,
                                                                          'uncommit' => undef
                                                                        }, 'Parse::RecDescent::Production' )
                                                               ],
                                                    'vars' => ''
                                                  }, 'Parse::RecDescent::Rule' ),
                              'DoubleQuote' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 189,
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
                                                                                                    'line' => 189,
                                                                                                    'lookahead' => 0,
                                                                                                    'pattern' => '"'
                                                                                                  }, 'Parse::RecDescent::Literal' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 0,
                                                                              'strcount' => 1,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Parse::RecDescent::Rule' ),
                              'EOF' => bless( {
                                                'calls' => [],
                                                'changed' => 0,
                                                'impcount' => 0,
                                                'line' => 211,
                                                'name' => 'EOF',
                                                'opcount' => 0,
                                                'prods' => [
                                                             bless( {
                                                                      'actcount' => 0,
                                                                      'dircount' => 0,
                                                                      'error' => undef,
                                                                      'items' => [
                                                                                   bless( {
                                                                                            'description' => '/^\\\\Z/',
                                                                                            'hashname' => '__PATTERN1__',
                                                                                            'ldelim' => '/',
                                                                                            'line' => 211,
                                                                                            'lookahead' => 0,
                                                                                            'mod' => '',
                                                                                            'pattern' => '^\\Z',
                                                                                            'rdelim' => '/'
                                                                                          }, 'Parse::RecDescent::Token' )
                                                                                 ],
                                                                      'line' => undef,
                                                                      'number' => 0,
                                                                      'patcount' => 1,
                                                                      'strcount' => 0,
                                                                      'uncommit' => undef
                                                                    }, 'Parse::RecDescent::Production' )
                                                           ],
                                                'vars' => ''
                                              }, 'Parse::RecDescent::Rule' ),
                              'EqualSign' => bless( {
                                                      'calls' => [],
                                                      'changed' => 0,
                                                      'impcount' => 0,
                                                      'line' => 209,
                                                      'name' => 'EqualSign',
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
                                                                                                  'line' => 209,
                                                                                                  'lookahead' => 0,
                                                                                                  'pattern' => '='
                                                                                                }, 'Parse::RecDescent::Literal' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 1,
                                                                            'uncommit' => undef
                                                                          }, 'Parse::RecDescent::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Parse::RecDescent::Rule' ),
                              'File' => bless( {
                                                 'calls' => [
                                                              'Line',
                                                              'EOF'
                                                            ],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 13,
                                                 'name' => 'File',
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
                                                                                             'line' => 13,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'max' => 100000000,
                                                                                             'min' => 1,
                                                                                             'repspec' => 's',
                                                                                             'subrule' => 'Line'
                                                                                           }, 'Parse::RecDescent::Repetition' ),
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'implicit' => undef,
                                                                                             'line' => 13,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'EOF'
                                                                                           }, 'Parse::RecDescent::Subrule' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 0,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Parse::RecDescent::Rule' ),
                              'Line' => bless( {
                                                 'calls' => [
                                                              'Comment',
                                                              'Section',
                                                              'VariableDef'
                                                            ],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 15,
                                                 'name' => 'Line',
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
                                                                                             'line' => 15,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'Comment'
                                                                                           }, 'Parse::RecDescent::Subrule' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 0,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' ),
                                                              bless( {
                                                                       'actcount' => 0,
                                                                       'dircount' => 0,
                                                                       'error' => undef,
                                                                       'items' => [
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'implicit' => undef,
                                                                                             'line' => 15,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'Section'
                                                                                           }, 'Parse::RecDescent::Subrule' )
                                                                                  ],
                                                                       'line' => 15,
                                                                       'number' => 1,
                                                                       'patcount' => 0,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' ),
                                                              bless( {
                                                                       'actcount' => 0,
                                                                       'dircount' => 0,
                                                                       'error' => undef,
                                                                       'items' => [
                                                                                    bless( {
                                                                                             'argcode' => undef,
                                                                                             'implicit' => undef,
                                                                                             'line' => 15,
                                                                                             'lookahead' => 0,
                                                                                             'matchrule' => 0,
                                                                                             'subrule' => 'VariableDef'
                                                                                           }, 'Parse::RecDescent::Subrule' )
                                                                                  ],
                                                                       'line' => 15,
                                                                       'number' => 2,
                                                                       'patcount' => 0,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Parse::RecDescent::Rule' ),
                              'Minus' => bless( {
                                                  'calls' => [],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 201,
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
                                                                                              'line' => 201,
                                                                                              'lookahead' => 0,
                                                                                              'pattern' => '-'
                                                                                            }, 'Parse::RecDescent::Literal' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 0,
                                                                        'strcount' => 1,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Parse::RecDescent::Rule' ),
                              'Name' => bless( {
                                                 'calls' => [],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 185,
                                                 'name' => 'Name',
                                                 'opcount' => 0,
                                                 'prods' => [
                                                              bless( {
                                                                       'actcount' => 0,
                                                                       'dircount' => 0,
                                                                       'error' => undef,
                                                                       'items' => [
                                                                                    bless( {
                                                                                             'description' => '/[-.: \\\\t\\\\w()]+/',
                                                                                             'hashname' => '__PATTERN1__',
                                                                                             'ldelim' => '/',
                                                                                             'line' => 185,
                                                                                             'lookahead' => 0,
                                                                                             'mod' => '',
                                                                                             'pattern' => '[-.: \\t\\w()]+',
                                                                                             'rdelim' => '/'
                                                                                           }, 'Parse::RecDescent::Token' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 1,
                                                                       'strcount' => 0,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Parse::RecDescent::Rule' ),
                              'OpenBrace' => bless( {
                                                      'calls' => [],
                                                      'changed' => 0,
                                                      'impcount' => 0,
                                                      'line' => 197,
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
                                                                                                  'line' => 197,
                                                                                                  'lookahead' => 0,
                                                                                                  'pattern' => '{'
                                                                                                }, 'Parse::RecDescent::Literal' )
                                                                                       ],
                                                                            'line' => undef,
                                                                            'number' => 0,
                                                                            'patcount' => 0,
                                                                            'strcount' => 1,
                                                                            'uncommit' => undef
                                                                          }, 'Parse::RecDescent::Production' )
                                                                 ],
                                                      'vars' => ''
                                                    }, 'Parse::RecDescent::Rule' ),
                              'OpenBracket' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 193,
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
                                                                                                    'line' => 193,
                                                                                                    'lookahead' => 0,
                                                                                                    'pattern' => '['
                                                                                                  }, 'Parse::RecDescent::Literal' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 0,
                                                                              'strcount' => 1,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Parse::RecDescent::Rule' ),
                              'Plus' => bless( {
                                                 'calls' => [],
                                                 'changed' => 0,
                                                 'impcount' => 0,
                                                 'line' => 203,
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
                                                                                             'line' => 203,
                                                                                             'lookahead' => 0,
                                                                                             'pattern' => '+'
                                                                                           }, 'Parse::RecDescent::Literal' )
                                                                                  ],
                                                                       'line' => undef,
                                                                       'number' => 0,
                                                                       'patcount' => 0,
                                                                       'strcount' => 1,
                                                                       'uncommit' => undef
                                                                     }, 'Parse::RecDescent::Production' )
                                                            ],
                                                 'vars' => ''
                                               }, 'Parse::RecDescent::Rule' ),
                              'Section' => bless( {
                                                    'calls' => [
                                                                 'SectionPrefix',
                                                                 'Name',
                                                                 'SectionSuffix'
                                                               ],
                                                    'changed' => 0,
                                                    'impcount' => 0,
                                                    'line' => 23,
                                                    'name' => 'Section',
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
                                                                                                'line' => 23,
                                                                                                'lookahead' => 0,
                                                                                                'matchrule' => 0,
                                                                                                'subrule' => 'SectionPrefix'
                                                                                              }, 'Parse::RecDescent::Subrule' ),
                                                                                       bless( {
                                                                                                'argcode' => undef,
                                                                                                'implicit' => undef,
                                                                                                'line' => 23,
                                                                                                'lookahead' => 0,
                                                                                                'matchrule' => 0,
                                                                                                'subrule' => 'Name'
                                                                                              }, 'Parse::RecDescent::Subrule' ),
                                                                                       bless( {
                                                                                                'argcode' => undef,
                                                                                                'implicit' => undef,
                                                                                                'line' => 23,
                                                                                                'lookahead' => 0,
                                                                                                'matchrule' => 0,
                                                                                                'subrule' => 'SectionSuffix'
                                                                                              }, 'Parse::RecDescent::Subrule' ),
                                                                                       bless( {
                                                                                                'code' => '{ 
				# let\'s store the section name, if it\'s a new one
				$::actSectionName = $item[2] if $::actSectionName ne $item[2];
#				$::actSectionName = lc $::actSectionName
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$::actSection = $thisparser->{_config}->Section($::actSectionName);
				if ($::comment && $::actSection)
				{
					$::actSection->Comment($::comment);
					$::comment = \'\';
				}
				1;
			}',
                                                                                                'hashname' => '__ACTION1__',
                                                                                                'line' => 24,
                                                                                                'lookahead' => 0
                                                                                              }, 'Parse::RecDescent::Action' )
                                                                                     ],
                                                                          'line' => undef,
                                                                          'number' => 0,
                                                                          'patcount' => 0,
                                                                          'strcount' => 0,
                                                                          'uncommit' => undef
                                                                        }, 'Parse::RecDescent::Production' )
                                                               ],
                                                    'vars' => ''
                                                  }, 'Parse::RecDescent::Rule' ),
                              'SectionPrefix' => bless( {
                                                          'calls' => [],
                                                          'changed' => 0,
                                                          'impcount' => 0,
                                                          'line' => 205,
                                                          'name' => 'SectionPrefix',
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
                                                                                                      'line' => 205,
                                                                                                      'lookahead' => 0,
                                                                                                      'pattern' => '['
                                                                                                    }, 'Parse::RecDescent::Literal' )
                                                                                           ],
                                                                                'line' => undef,
                                                                                'number' => 0,
                                                                                'patcount' => 0,
                                                                                'strcount' => 1,
                                                                                'uncommit' => undef
                                                                              }, 'Parse::RecDescent::Production' )
                                                                     ],
                                                          'vars' => ''
                                                        }, 'Parse::RecDescent::Rule' ),
                              'SectionSuffix' => bless( {
                                                          'calls' => [],
                                                          'changed' => 0,
                                                          'impcount' => 0,
                                                          'line' => 207,
                                                          'name' => 'SectionSuffix',
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
                                                                                                      'line' => 207,
                                                                                                      'lookahead' => 0,
                                                                                                      'pattern' => ']'
                                                                                                    }, 'Parse::RecDescent::Literal' )
                                                                                           ],
                                                                                'line' => undef,
                                                                                'number' => 0,
                                                                                'patcount' => 0,
                                                                                'strcount' => 1,
                                                                                'uncommit' => undef
                                                                              }, 'Parse::RecDescent::Production' )
                                                                     ],
                                                          'vars' => ''
                                                        }, 'Parse::RecDescent::Rule' ),
                              'SingleQuote' => bless( {
                                                        'calls' => [],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 191,
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
                                                                                                    'line' => 191,
                                                                                                    'lookahead' => 0,
                                                                                                    'mod' => '',
                                                                                                    'pattern' => '\'',
                                                                                                    'rdelim' => '/'
                                                                                                  }, 'Parse::RecDescent::Token' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 1,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Parse::RecDescent::Rule' ),
                              'Value' => bless( {
                                                  'calls' => [
                                                               'DoubleQuote',
                                                               'SingleQuote',
                                                               'OpenBracket',
                                                               'CloseBracket',
                                                               'OpenBrace',
                                                               'CloseBrace'
                                                             ],
                                                  'changed' => 0,
                                                  'impcount' => 0,
                                                  'line' => 150,
                                                  'name' => 'Value',
                                                  'opcount' => 0,
                                                  'prods' => [
                                                               bless( {
                                                                        'actcount' => 0,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'description' => '/[^"\'\\\\n\\\\r]+/',
                                                                                              'hashname' => '__PATTERN1__',
                                                                                              'ldelim' => '/',
                                                                                              'line' => 150,
                                                                                              'lookahead' => 0,
                                                                                              'mod' => '',
                                                                                              'pattern' => '[^"\'\\n\\r]+',
                                                                                              'rdelim' => '/'
                                                                                            }, 'Parse::RecDescent::Token' )
                                                                                   ],
                                                                        'line' => undef,
                                                                        'number' => 0,
                                                                        'patcount' => 1,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' ),
                                                               bless( {
                                                                        'actcount' => 1,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 152,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'DoubleQuote'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'description' => '/(\\\\\\\\"|\\\\n|[^"])*/',
                                                                                              'hashname' => '__PATTERN1__',
                                                                                              'ldelim' => '/',
                                                                                              'line' => 152,
                                                                                              'lookahead' => 0,
                                                                                              'mod' => '',
                                                                                              'pattern' => '(\\\\"|\\n|[^"])*',
                                                                                              'rdelim' => '/'
                                                                                            }, 'Parse::RecDescent::Token' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 152,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'DoubleQuote'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'code' => '{
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			}',
                                                                                              'hashname' => '__ACTION1__',
                                                                                              'line' => 153,
                                                                                              'lookahead' => 0
                                                                                            }, 'Parse::RecDescent::Action' )
                                                                                   ],
                                                                        'line' => 151,
                                                                        'number' => 1,
                                                                        'patcount' => 1,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' ),
                                                               bless( {
                                                                        'actcount' => 1,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 160,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'SingleQuote'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'description' => '/(\\\\\\\\\'|\\\\n|[^\'])*/',
                                                                                              'hashname' => '__PATTERN1__',
                                                                                              'ldelim' => '/',
                                                                                              'line' => 160,
                                                                                              'lookahead' => 0,
                                                                                              'mod' => '',
                                                                                              'pattern' => '(\\\\\'|\\n|[^\'])*',
                                                                                              'rdelim' => '/'
                                                                                            }, 'Parse::RecDescent::Token' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 160,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'SingleQuote'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'code' => '{
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			}',
                                                                                              'hashname' => '__ACTION1__',
                                                                                              'line' => 161,
                                                                                              'lookahead' => 0
                                                                                            }, 'Parse::RecDescent::Action' )
                                                                                   ],
                                                                        'line' => 160,
                                                                        'number' => 2,
                                                                        'patcount' => 1,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' ),
                                                               bless( {
                                                                        'actcount' => 1,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 168,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'OpenBracket'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'description' => '/[^"\']*/',
                                                                                              'hashname' => '__PATTERN1__',
                                                                                              'ldelim' => '/',
                                                                                              'line' => 168,
                                                                                              'lookahead' => 0,
                                                                                              'mod' => '',
                                                                                              'pattern' => '[^"\']*',
                                                                                              'rdelim' => '/'
                                                                                            }, 'Parse::RecDescent::Token' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 168,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'CloseBracket'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'code' => '{
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			}',
                                                                                              'hashname' => '__ACTION1__',
                                                                                              'line' => 169,
                                                                                              'lookahead' => 0
                                                                                            }, 'Parse::RecDescent::Action' )
                                                                                   ],
                                                                        'line' => 168,
                                                                        'number' => 3,
                                                                        'patcount' => 1,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' ),
                                                               bless( {
                                                                        'actcount' => 1,
                                                                        'dircount' => 0,
                                                                        'error' => undef,
                                                                        'items' => [
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 176,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'OpenBrace'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'description' => '/[^"\']*/',
                                                                                              'hashname' => '__PATTERN1__',
                                                                                              'ldelim' => '/',
                                                                                              'line' => 176,
                                                                                              'lookahead' => 0,
                                                                                              'mod' => '',
                                                                                              'pattern' => '[^"\']*',
                                                                                              'rdelim' => '/'
                                                                                            }, 'Parse::RecDescent::Token' ),
                                                                                     bless( {
                                                                                              'argcode' => undef,
                                                                                              'implicit' => undef,
                                                                                              'line' => 176,
                                                                                              'lookahead' => 0,
                                                                                              'matchrule' => 0,
                                                                                              'subrule' => 'CloseBrace'
                                                                                            }, 'Parse::RecDescent::Subrule' ),
                                                                                     bless( {
                                                                                              'code' => '{
				# store the delimiters
				$::varPrefix = $item[1];
				$::varSuffix = $item[3];
				# return only the value itself
				$return = $item[2];
			}',
                                                                                              'hashname' => '__ACTION1__',
                                                                                              'line' => 177,
                                                                                              'lookahead' => 0
                                                                                            }, 'Parse::RecDescent::Action' )
                                                                                   ],
                                                                        'line' => 176,
                                                                        'number' => 4,
                                                                        'patcount' => 1,
                                                                        'strcount' => 0,
                                                                        'uncommit' => undef
                                                                      }, 'Parse::RecDescent::Production' )
                                                             ],
                                                  'vars' => ''
                                                }, 'Parse::RecDescent::Rule' ),
                              'VariableDef' => bless( {
                                                        'calls' => [
                                                                     'Name',
                                                                     'EqualSign',
                                                                     'Value',
                                                                     'Minus',
                                                                     'Plus',
                                                                     'At'
                                                                   ],
                                                        'changed' => 0,
                                                        'impcount' => 0,
                                                        'line' => 38,
                                                        'name' => 'VariableDef',
                                                        'opcount' => 0,
                                                        'prods' => [
                                                                     bless( {
                                                                              'actcount' => 1,
                                                                              'dircount' => 1,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 39,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Name'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 39,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'EqualSign'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'description' => '/[\\\\n\\\\r]/',
                                                                                                    'hashname' => '__PATTERN1__',
                                                                                                    'ldelim' => '/',
                                                                                                    'line' => 39,
                                                                                                    'lookahead' => 0,
                                                                                                    'mod' => '',
                                                                                                    'pattern' => '[\\n\\r]',
                                                                                                    'rdelim' => '/'
                                                                                                  }, 'Parse::RecDescent::Token' ),
                                                                                           bless( {
                                                                                                    'code' => '$commit = 1',
                                                                                                    'hashname' => '__DIRECTIVE1__',
                                                                                                    'line' => 39,
                                                                                                    'lookahead' => 0,
                                                                                                    'name' => '<commit>'
                                                                                                  }, 'Parse::RecDescent::Directive' ),
                                                                                           bless( {
                                                                                                    'code' => '{
				# create a new variable or add the value
				if ($thisparser->{_config})
				{
					$item[1] =~ s/^\\s*//;
					$item[1] =~ s/\\s*$//;
					$item[3] =~ s/^\\s*//;
					$item[3] =~ s/\\s*$//;
#					$item[1] = lc $item[1]
#						unless $thisparser->{_config}->{_options}->{MODE} & 2;
					$thisparser->{_config}->Variable($::actSectionName, 
													 \'+\' . $item[1], 
													 \'\');
					if ($::varPrefix || $::varSuffix)
					{
						$thisparser->{_config}->Delimiters($::actSectionName,
														   $item[1],
														   $::varPrefix,
														   $::varSuffix);
						$::varPrefix = $::varSuffix = undef;
					}

					if ($::comment && $::actSection)
					{
						$::actSection->{_variables}->{$item[1]}->Comment($::comment);
						$::comment = \'\';
					}
				}
				1;
			}',
                                                                                                    'hashname' => '__ACTION1__',
                                                                                                    'line' => 40,
                                                                                                    'lookahead' => 0
                                                                                                  }, 'Parse::RecDescent::Action' )
                                                                                         ],
                                                                              'line' => undef,
                                                                              'number' => 0,
                                                                              'patcount' => 1,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' ),
                                                                     bless( {
                                                                              'actcount' => 1,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 70,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Name'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 70,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'EqualSign'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 70,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Value'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'code' => '{
				# create a new variable or add the value
				if ($thisparser->{_config})
				{
					$item[1] =~ s/^\\s*//;
					$item[1] =~ s/\\s*$//;
					$item[3] =~ s/^\\s*//;
					$item[3] =~ s/\\s*$//;
#					$item[1] = lc $item[1]
#						unless $thisparser->{_config}->{_options}->{MODE} & 2;
					$thisparser->{_config}->Variable($::actSectionName, 
													 \'+\' . $item[1], 
													 $item[3]);
					if ($::varPrefix || $::varSuffix)
					{
						$thisparser->{_config}->Delimiters($::actSectionName,
														   $item[1],
														   $::varPrefix,
														   $::varSuffix);
						$::varPrefix = $::varSuffix = undef;
					}

					if ($::comment && $::actSection)
					{
						$::actSection->{_variables}->{$item[1]}->Comment($::comment);
						$::comment = \'\';
					}
				}
				1;
			}',
                                                                                                    'hashname' => '__ACTION1__',
                                                                                                    'line' => 71,
                                                                                                    'lookahead' => 0
                                                                                                  }, 'Parse::RecDescent::Action' )
                                                                                         ],
                                                                              'line' => 70,
                                                                              'number' => 1,
                                                                              'patcount' => 0,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' ),
                                                                     bless( {
                                                                              'actcount' => 1,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 102,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Minus'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 102,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Name'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'code' => '{
				$item[2] =~ s/^\\s*|\\s*$//;
#				$item[2] = lc $item[2]
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$thisparser->{_config}->Variable($::actSectionName,
												 $item[2],
												 0);

				if ($::comment && $::actSection)
				{
					$::actSection->{_variables}->{$item[2]}->Comment($::comment);
					$::comment = \'\';
				}

				1;
			}',
                                                                                                    'hashname' => '__ACTION1__',
                                                                                                    'line' => 103,
                                                                                                    'lookahead' => 0
                                                                                                  }, 'Parse::RecDescent::Action' )
                                                                                         ],
                                                                              'line' => 101,
                                                                              'number' => 2,
                                                                              'patcount' => 0,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' ),
                                                                     bless( {
                                                                              'actcount' => 1,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'expected' => undef,
                                                                                                    'line' => 120,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'max' => 1,
                                                                                                    'min' => 0,
                                                                                                    'repspec' => '?',
                                                                                                    'subrule' => 'Plus'
                                                                                                  }, 'Parse::RecDescent::Repetition' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 120,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Name'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'code' => '{
				$item[2] =~ s/^\\s*|\\s*$//;
#				$item[2] = lc $item[2]
#					unless $thisparser->{_config}->{_options}->{MODE} & 2;
				$thisparser->{_config}->Variable($::actSectionName,
												 $item[2],
												 1);

				if ($::comment && $::actSection)
				{
					$::actSection->{_variables}->{$item[2]}->Comment($::comment);
					$::comment = \'\';
				}

				1;
			}',
                                                                                                    'hashname' => '__ACTION1__',
                                                                                                    'line' => 121,
                                                                                                    'lookahead' => 0
                                                                                                  }, 'Parse::RecDescent::Action' )
                                                                                         ],
                                                                              'line' => 119,
                                                                              'number' => 3,
                                                                              'patcount' => 0,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' ),
                                                                     bless( {
                                                                              'actcount' => 1,
                                                                              'dircount' => 0,
                                                                              'error' => undef,
                                                                              'items' => [
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 138,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'At'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'argcode' => undef,
                                                                                                    'implicit' => undef,
                                                                                                    'line' => 138,
                                                                                                    'lookahead' => 0,
                                                                                                    'matchrule' => 0,
                                                                                                    'subrule' => 'Name'
                                                                                                  }, 'Parse::RecDescent::Subrule' ),
                                                                                           bless( {
                                                                                                    'code' => '{
                $item[2] =~ s/^\\s*|\\s*$//;
                $thisparser->{_config}->IncludeSection($::actSectionName, $item[2]);

                if ($::comment && $::actSection)
                {
                    $::actSection->Comment($::comment);
					$::comment = \'\';
                }
            }',
                                                                                                    'hashname' => '__ACTION1__',
                                                                                                    'line' => 139,
                                                                                                    'lookahead' => 0
                                                                                                  }, 'Parse::RecDescent::Action' )
                                                                                         ],
                                                                              'line' => 137,
                                                                              'number' => 4,
                                                                              'patcount' => 0,
                                                                              'strcount' => 0,
                                                                              'uncommit' => undef
                                                                            }, 'Parse::RecDescent::Production' )
                                                                   ],
                                                        'vars' => ''
                                                      }, 'Parse::RecDescent::Rule' )
                            },
                 'startcode' => ''
               }, 'Parse::RecDescent' );
}