#!/usr/bin/perl

# $Id: Versions.pm,v 1.2 1996/06/24 09:20:44 kjahds Exp $

# Copyright (c) 1996, Kenneth J. Albanowski. All rights reserved.  This
# program is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself.

package Sort::Versions;

require Exporter;
@ISA=qw(Exporter);

@EXPORT=qw(&versions);
@EXPORT_OK=qw(&versioncmp);

# This was the original implementation. It's more expensive due to the
# nested data, but is also is a more transparent example of the algorithm.

#sub old_versions {
#	my(@A)=map([/(\d+|\D+)/g],split(/\./,$::a));
#	my(@B)=map([/(\d+|\D+)/g],split(/\./,$::b));
#	my(@A2,@B2,$A3,$B3);
#	while(@A and @B) {
#		@A2=@{shift @A};
#		@B2=@{shift @B};
#		while(@A2 and @B2) {
#			$A3 = uc shift @A2;
#			$B3 = uc shift @B2;
#			if($A3 =~ /^\d+$/ and $B3 =~ /^\d+$/) {
#				return $A3 <=> $B3 if $A3 <=> $B3;
#			} else {
#				return $A3 cmp $B3 if $A3 cmp $B3;
#			}	
#		}
#		return @A2 <=> @B2 if @A2 <=> @B2;
#	}
#	@A <=> @B;
#}


sub versions {
	my(@A) = ($::a =~ /(\.|\d+|[^\.\d]+)/g);
	my(@B) = ($::b =~ /(\.|\d+|[^\.\d]+)/g);
	my($A,$B);
	while(@A and @B) {
		$A=shift @A;
		$B=shift @B;
		if($A eq "." and $B eq ".") {
			next;
		} elsif( $A eq "." ) {
			return -1;
		} elsif( $B eq "." ) {
			return 1;
		} elsif($A =~ /^\d+$/ and $B =~ /^\d+$/) {
			return $A <=> $B if $A <=> $B;
		} else {
			$A = uc $A;
			$B = uc $B;
			return $A cmp $B if $A cmp $B;
		}	
	}
	@A <=> @B;
}

sub versioncmp {
	local($::a,$::b)=@_;
	versions;
}

=head1 NAME

Sort::Versions - a perl 5 module for sorting of revision-like numbers

=head1 SYNOPSIS

	use Sort::Versions;
	@l = sort versions qw( 1.2 1.2.0 1.2a.0 1.2.a 1.a 02.a );

	...

	use Sort::Versions qw(versioncmp);
	print "lower" if versioncmp("1.2","1.2a")==-1;

=head1 DESCRIPTION	

Sort::Versions allows easy sorting of mixed non-numeric and numeric strings,
like the "version numbers" that many shared library systems and revision
control packages use. This is quite useful if you are trying to deal with
shared libraries. It can also be applied to applications that intersperse
variable-width numeric fields within text. Other applications can
undoubtedly be found.

For an explanation of the algorithm, it's simplest to look at these examples:

  1.1   <  1.2
  1.1a  <  1.2
  1.1   <  1.1.1
  1.1   <  1.1a
  1.1.a <  1.1a
  1     <  a
  a     <  b
  1     <  2
  1     <  0002
  1.5   <  1.06

More precisely (but less comprehensibly), the two strings are treated as
subunits delimited by periods. Each subunit can contain any number of groups
of digits or non-digits. If digit groups are being compared on both sides, a
numeric comparison is used, otherwise a ASCII ordering is used. A group or
subgroup with more units will win if all comparisons are equal.

One important thing to note is that if a numeric comparison is made, then
leading zeros are ignored. Thus C<1.5> sorts before C<1.06>, since two
separate comparisons are being made: C<1 == 1>, and C<5 E<lt> 6>. This is I<not>
the same as C<if(1.5 E<lt> 1.06) {...}>.

=head1 USAGE

Sort::Versions only exports C<versions> by default, which is a function
suitable for giving to C<sort>. A second function, C<versioncmp> is
available which takes two arguments and returns a cmp style comparison
value.

=head1 AUTHOR

Kenneth J. Albanowski		kjahds@kjahds.com
       
Copyright (c) 1996, Kenneth J. Albanowski. All rights reserved.  This
program is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut

1;
__END__

#
# $Log: Versions.pm,v $
# Revision 1.2  1996/06/24 09:20:44  kjahds
# *** empty log message ***
#
# Revision 1.1.1.1  1996/06/24 09:06:18  kjahds
#
# Revision 1.4  1996/06/23 16:02:13  kjahds
# *** empty log message ***
#
# Revision 1.3  1996/06/23 15:59:50  kjahds
# *** empty log message ***
#
# Revision 1.2  1996/06/23 06:26:07  kjahds
# *** empty log message ***
#
# Revision 1.1.1.1  1996/06/23 06:07:48  kjahds
# import
#
#
