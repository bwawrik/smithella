#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#!/usr/bin/perl
#use strict;
use warnings;
#--INCLUDE PACKAGES-----------------------------------------------------------
use IO::String;
use Cwd;
#-----------------------------------------------------------------------------
#----SUBROUTINES--------------------------------------------------------------
#-----------------------------------------------------------------------------
sub get_file_data
{
  my ($file_name) = @_;
  my @file_content;
  open (PROTEINFILE, $file_name);
  @file_content = <PROTEINFILE>;
  close PROTEINFILE;
  return @file_content;
} # end of subroutine get_file_data;

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
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
my $filename1 = $ARGV[0];
my $truncate_string = $ARGV[1];

my @table1 = get_file_data ($filename1); chomp (@table1);

foreach my $line (@table1)
{
  my @splitline = split($truncate_string,$line);
printf $splitline[0];
#printf $truncate_string;
printf "\n";
}
