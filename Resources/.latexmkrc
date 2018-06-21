# This run time configuration file will be sources by latexmk to properly add glossary
# and acronyme support

# See: https://tex.stackexchange.com/questions/1226/how-to-make-latexmk-use-makeglossaries
# See: http://distrib-coffee.ipsl.jussieu.fr/pub/mirrors/ctan/support/latexmk/example_rcfiles/glossary_latexmkrc

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  }
  else {
    system "makeglossaries '$_[0]'";
  };
}

push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
