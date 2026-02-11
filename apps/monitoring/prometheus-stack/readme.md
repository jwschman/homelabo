# notes

Switched from old prometheus to this and had to do a few things

enabled node-exporter on this rather than standalone node-exporter.

going to stick with separate grafana

had to add a servicemonitor to my graphite exporter

but now i can enable service monitors for other things and get those to scrape

also am using nfs for storage rather than longhorn.  This is definitely *NOT* the way to do it and I need to go back to longhorn ASAP
