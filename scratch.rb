require './lib/inports'

$r.kill_keys

# # puts EzPub::File.mine?('./input/curriculum-support/pdfs/tl-learning-progression-diagrams-oct-2010.pdf')

# include IsARedirect

# redirect?('./input/curriculum-support/CSP/index.htm')


DatabaseImporters::Glossary.run
