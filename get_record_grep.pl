#!/usr/bin/perl

use strict;
use IO::String;


my $database_filename = $ARGV[0];
my $diamond_search_filename = $ARGV[1];
my $output_filename = $ARGV[2];

my @KEGGids;
my @GENEids;
my @output_array;



#################################################
# subroutines
#################################################

sub get_file_data
    {
    my ($file_name) = @_;
    my @file_content;
    open (PROTEINFILE, $file_name);
    @file_content = <PROTEINFILE>;
    close PROTEINFILE;
    return @file_content;
    } 

sub WriteArrayToFile
    {
    my ($filename, @in) = @_;
    my $a = join (@in, "\n");
    open (OUTFILE, ">$filename");
    foreach my $a (@in)
      {
      print OUTFILE $a;
     print OUTFILE "\n";
      }
    close (OUTFILE);
     }


#################################################
# load diamond output file
#################################################

my @diamand_search_table = get_file_data ($diamond_search_filename);

#################################################
#
#################################################


my @dmd;
foreach my $clump (@diamand_search_table)
  {
  chomp $clump;
  my @speck = split (/\t/, $clump);
  if ($speck[1]) {push (@dmd, $speck[1]);}
}
WriteArrayToFile ("sout.tmp", @dmd);
printf("grepping\n");
system ("grep -f sout.tmp ".$database_filename." >> out.grep");


my @out_grep = get_file_data ("out.grep");
printf ("loaded grep\n");

my $savecounter =0;
my $ind =0;
foreach my $iclump (@diamand_search_table)
{
  chomp $iclump;
  my @ispeck = split (/\t/, $iclump);
  my $foundit = 0;
  foreach my $ied (@out_grep)
          {
           my @ied_speck = split (/ /, $ied);
           chomp $ied_speck[1];
           if ($ied_speck[1] eq $ispeck[1])
            {
            push (@output_array, $ied_speck[0]."\t".$iclump);
            printf ($ied_speck[0]."\t".$iclump."\n");
            $foundit = 1;
            }
          }
          if ($foundit == 0)
            {
            push (@output_array, "none."."\t".$iclump);
            printf ("none."."\t".$iclump."\n");
            }
$savecounter=$savecounter+1;
if ($savecounter >500) 
   {
   WriteArrayToFile ($output_filename, @output_array);
   $savecounter=0;
   }
}

################################################
# write output
################################################

WriteArrayToFile ($output_filename, @output_array);

#################################################
# cleanup
#################################################

system ("rm out.grep");
system ("rm sout.tmp");










