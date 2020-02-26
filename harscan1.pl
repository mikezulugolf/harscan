#!/usr/bin/perl -w

#****************************************************************/
#*  scan Chrome-extracted .har file
#
#   to better see the sequence of requests
#
#****************************************************************/

use diagnostics;
use strict;
use warnings;
use Text::Balanced qw/extract_multiple extract_bracketed/;

if (@ARGV == 0) {
   die "Input parameter missing";
}

my $input = $ARGV[0];

open (my $f,  "<$input") or die "cannot open $input for input \n";

my $fullfile =  do { local($/); <$f> };

close $f;

my $line = "";
my $outline = "";

my $linecounter = 0;


#print "analyzing $input \n";

my $msprev = 0;
my @array;
my ($dt, $tim, $mshere, $mshere2, $requrl, $delta, $conn, $ctime, $wait );
my ($prev_dt, $prev_tim, $prev_mshere, $prev_mshere2, $prev_requrl, $prev_delta, $prev_conn, $prev_ctime, $prev_wait );
my $request = "";
# test only
#my $a = "15:01:01.001000";
#my $b = ToTimestamp(ToMillis($a)+1);
#print "$a $b \n";
$fullfile =~ s/\n//g; # remove line ends
$fullfile =~ s/ //g; # remove blanks

# drop prolog:  remove everything up to "entries":[
$fullfile =~ s/^.*?\"entries\":\[//;

#print substr($fullfile,0,200),"\n";


   my $reqnum = 0;
   $request = extract_multiple($fullfile, [ sub{extract_bracketed($_[0], '{}')},], undef, 1  );
   while (defined($request)) {
      #print "$request\n\n";
      $request =~ /\{\"startedDateTime\":\"(.*?)\"/;
      $dt = $1;
      $tim = "00:00:00.000000";
      if (length($dt)>23) {
         $tim = substr($dt,11,15);
         # 15:24:19.847983
         # 012345678901234
         $mshere = ToMillis($tim);
      }

      # extract request URL
      # "request":{"headersSize":375, "httpVersion":"HTTP/1.0", "url":"http://wiss-pre.intranet.commerzbank.com:443"
      $request =~ /\"request\":\{\"method\":.*?\"url\":\"(.*?)\"/;
      $requrl = $1;
      #print "url= $requrl\n";


      # extract connection and time
      # "connection":"1345", "time":16, "serverIPAddress":"140.39.8.199"},
      $conn = "----";  $ctime = "----";
      $request =~ /\"method\":\"(.*?)\"/;
      $conn = $1 if defined($1);
      #print "conn=$conn\n";
      $request =~ /\"time\":(\d+)/;
      $ctime = $1 if defined($1);
      $mshere2 = $mshere + $ctime;
      $wait = 0;
      $request =~ /\"wait\":(\d+)/;
      $wait = $1 if defined($1);

      # print output
      $reqnum = $reqnum + 1;
      if ($reqnum > 1) {
          $delta = $mshere - $prev_mshere;
          if (length($prev_dt)>23) {$prev_dt = substr($prev_dt,11,12);}
          my $prev_dtafter = ToTimestamp($prev_mshere2);
          printf "$prev_dt-$prev_dtafter %7d ms %7s %s \n", $prev_ctime, $prev_conn, $prev_requrl;
          my $a = ToTimestamp($mshere);
          #printf "$prev_dtafter-$a %7d ms\n", $mshere - $prev_mshere2;
      }
 
      # remember values for the next iteration
      $prev_dt = $dt;   
      $prev_tim = $tim;   
      $prev_mshere = $mshere;   
      $prev_mshere2 = $mshere2;   
      $prev_requrl = $requrl;   
      $prev_conn = $conn;   
      $prev_ctime = $ctime;   
      $prev_wait = $wait;   

      # extract next request
      $request = extract_multiple($fullfile, [ sub{extract_bracketed($_[0], '{}')},], undef, 1  );
   }   


#} # end while

#close INPUT;
#close OUTPUT;


##################################################
sub ToMillis  {
   my $intim = $_[0];
   $intim =~ s/Z//;  # remove potential Zulu indicator
   my $millis = substr($intim,9,3) + 
                substr($intim,6,2)*1000 +  
                substr($intim,3,2)*1000*60 + 
                substr($intim,0,2)*1000*60*60; 
   return $millis;
}

##################################################
sub ToTimestamp  {
   my $millis1 = $_[0];
   my $h_after  = int($millis1 / 1000/60/60);
   my $m_after  = int(($millis1  -  $h_after*1000*60*60) / 60 / 1000) ;
   my $s_after  = int (($millis1  -  $h_after*1000*60*60 - $m_after*1000*60 ) / 1000 )  ;
   my $ms_after = $millis1  -  $h_after*1000*60*60 - $m_after*1000*60  - $s_after * 1000   ;
   my $timestamp = sprintf "%02d:%02d:%02d.%03d", $h_after, $m_after, $s_after, $ms_after;
   return $timestamp;
}





__END__

