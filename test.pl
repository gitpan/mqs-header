# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 1 };
use mqs::header;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $content = "line 1\nline 2\n";

print "content =>\n";
print $content;
print "<= end content\n";

print "read_content on a content without header\n";
$content = read_content($content);

print "begin\n$content end\n";

my %header = read_header($content);
print "Value header => ".$header{'mqs-header'}." (Normally no)\n";

$content = add_header($content,"test","actual");

print "Content after add_header =>\n";
print $content;

print "Read header of Content\n";
%header = read_header($content);
my $key;
my $value;
while(($key,$value) = each(%header))
{
	print "$key => $value\n";
}

$content = add_header($content,"test2","actual2");

print "Content after a second add_header =>\n";
print $content;

print "Read header of Content\n";
%header = read_header($content);
while(($key,$value) = each(%header))
{
	print "$key => $value\n";
}

print "get the content of the message\n";

$content = read_content($content);

print "begin\n$content end\n";

