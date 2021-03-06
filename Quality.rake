require 'flog'
require 'flay'
require 'reek'

files = (Dir['lib/**/*.rb'] - ['lib/llvm/ext.rb', 'lib/llvm/linker.rb'])

desc "Analyze code complexity"
task :flog do
  flog = Flog.new
  flog.flog(files)
  threshold = 110
    
  bad_methods = flog.totals.select do |name, score|
    next if name == "LLVM::Script::Convert"
    score > threshold
  end
  
  if bad_methods.size > 0
    puts "#{bad_methods.size} methods have a flog complexity > #{threshold}"
    bad_methods.sort{ |a,b| b[1] <=> a[1] }.each do |name, score|
      puts "%8.1f: %s" % [score, name]
    end 
  else
    puts "No methods have a flog complexity > #{threshold}"
  end
end
 
desc "Analyze code duplication"
task :flay do
  threshold = 65
  flay = Flay.new({:fuzzy => false, :verbose => false, :mass => threshold/2})
  flay.process(*Flay.expand_dirs_to_files(['lib'])) 
  
  if flay.masses.size > 0 
    flay.report
    puts "\n#{flay.masses.size} chunks of code have a mass > #{threshold}"
  else
    puts "No chunks of code have a mass > #{threshold}"
  end
end

desc "Analyze code smells"
task :reek do
  config = "config.reek"
  warnings = {}
  files.each do |file|
    result = Reek::Examiner.new([file])
    warnings[file] = result.smells.sort{|a,b| a.lines.first <=> b.lines.first} if result.smelly?
  end
  
  max_len = 0
  warnings.values.flatten { |s| [s.smell_class.length, max_len].max }
  warnings.each do |file, smells|
    puts "#{file} --- #{smells.length} smells detected:"
    smells.each do |s|
      puts "%8d: %-#{max_len}s %-65s" % [s.lines.first, "(#{s.smell_class})", "#{s.context} #{s.message}"]
    end
  end 
  puts "No smells detected" if warnings.empty?
end

task :quality => [:flay, :flog, :reek]