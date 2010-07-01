package overload::eval;
use strict;
use warnings;
use 5.009_000;

sub import {
    my ( undef, $callback ) = @_;
    $callback //= 'eval';
    $^H{'overload::eval'} = "$callback";
    return;
}

sub unimport {
    delete $^H{'overload::eval'};
    return;
}

our $VERSION = '0.01';
use XSLoader;
XSLoader::load( 'overload::eval', $VERSION );

q[With great powers come laser eyebeams.];

__END__

=head1 NAME

overload::eval - Hooks the native string eval() function

=head1 SYNOPSIS

  use overload::eval 'my_callback';
  sub my_callback { print and eval for $_[0] }

  sub rot13 {
      local $_ = shift;
      tr[A-Za-z][N-ZA-Mn-za-m];
      return $_;
  }
  eval(rot13('cevag "Uryyb jbeyq!\a"'));

=head1 DESCRIPTION

This module hooks the native eval() function and sends it to your
function instead. The eval() function operates normally within your
function.

This module requires user pragmas which are a feature present only in
5.9+.

Using this module is simplicity itself. If you've declared the hook,
any uses of string eval in that lexical scope are going to be
redirected to the function you named.

  {
      use overload::eval;
      eval '...';
  }
  sub eval {
      # eval goes here
  }

If you declare a hook name, execution is redirected to that named
function instead of C<eval>.

  {
      use overload::eval 'hook';
      eval '...';
  }
  sub hook {
      # eval goes here because we declared 'hook'
  }

=head1 DISPELLING MAGIC

This module overloads eval() only with the lexical scope you've
requested. To avoid triggering this module, either create a new
lexical scope or just disable the overloading.

  {
    use overload::eval;
    eval '...'; # Overloaded;
  }
  eval '...'; # NOT overloaded

Or...

  use overload::eval;
  eval '...'; # Overloaded;
  
  no overload::eval;
  eval '...'; # NOT overloaded.

=head1 SEE ALSO

This module does not overload the block form of eval. Sorry. That's an
entirely different kind of technology.

  eval { ... };

=head1 AUTHOR

Joshua ben Jore - jjore@cpan.org

=head1 LICENSE

The standard Artistic / GPL license most other perl code is typically
using.
