#!/bin/bash

cat $1 | grep "Sentence total extraction time" | sed 's/.*Sentence total extraction time:\t*//; s/ milliseconds *//' | ruby -e 'total=0.0; lineCount=0; STDIN.each_line{|line| ms=line.strip.to_f; total+=ms; lineCount+=1}; puts "#{lineCount} lines at #{(total/1000)/lineCount} sec/sentence\nTotal time:\t(#{total/1000} sec)\t(#{total/1000/60} min)\t(#{total/1000/60/60} hours)";'