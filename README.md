# crawler

# This is very quick and simple attempt at crawling through website.
# Since I had a very limited time (about 1h) I decided to abandon attempt to create a proper map of links
# in favour of just geting list of links. As well, I had no time to create proper testing environment
# with number of redirects, dead links or links to other websites.
#
# Alternative solution could be to use curl and scan content for <a href="regex_for_URL">
#  (or write something in proper scripting language)
#
# Obvious limitation of this script (and using wget) is that it is a single threaded operation, can take
# a long time to process a bigger site.
#
# Script relies on wget, curl and dig - I could implement proper 'discovery' or local packet management
# system (rpm, apt, emerge, ...) and use that to verify existence and locations.
#
# As well, proper parsing for input URL could be implemented. I just try to access it with curl and look for
# HTTP code. If URL is malformed, not existing address or not URL at all, HTTP code will be 000.
#
# I use dig and SOA to get domain (needed for wget to stay within one domain).
# If address in URL is a domain dig will return SOA record in answer section, otherwise SOA will be supplied
# in authority section. SOA starts with a domain.
#
# For some reasons I encountered problems with optional redirecting output to outfile.
# Given more time, I could find a solution.
# wget occasionally returns same links more than once. The easiest way to eliminate duplicates would be
# to use uniq or sort -u, however that would require sorting output. I decided to leave it unsorted, in the
# way wget crawled the website giving some semblance of a map.
#
