require 'irb/completion'
require 'rubygems'
require 'rainbow'

ActiveRecord::Base.logger.level = 1 if defined?(ActiveRecord)
IRB.conf[:SAVE_HISTORY] = 1000

# Overriding Object class
class Object
  # Easily print methods local to an object's class
  def lm
    (methods - Object.instance_methods).sort
  end

  # look up source location of a method
  def sl(method_name)
    method(method_name).source_location
  rescue StandardError
    "#{method_name} not found"
  end

  # open particular method in nvim
  def ocode(method_name)
    file, line = sl(method_name)
    if file && line
      `nvim -g '#{file}:#{line}'`
    else
      "'#{method_name}' not found :(Try #{name}.lm to see available methods"
    end
  end

  # display method source in rails console
  def ds(method_name)
    method(method_name).source.display
  end
end

# history command
def hist(count = 0)
  # Get history into an array
  history_array = Readline::HISTORY.to_a

  # if count is > 0 we'll use it.
  # otherwise set it to 0
  count = count.posivite? ? count : 0

  if count.positive?
    from = history_array.length - count
    history_array = history_array[from..]
  end

  print history_array.join("\n")
end

# copy a string to the clipboard
def cp(string)
  `echo "#{string}" | pbcopy`
  puts 'copied in clipboard'
end

# reloads the irb console can be useful for debugging .irbrc
def reload_irb
  load File.expand_path('~/.irbrc')
  # will reload rails env if you are running ./script/console
  reload! if @script_console_running
  puts 'Console Reloaded!'
end

# opens irbrc in nvim
def edit_irb
  `nvim ~/.irbrc` if system('nvim')
end

def bm
  # From http://blog.evanweaver.com/articles/2006/12/13/benchmark/
  # Call benchmark { } with any block and you get the wallclock runtime
  # as well as a percent change + or - from the last run
  cur = Time.now
  result = yield
  print "#{cur = Time.now - cur} seconds"
  begin
    puts " (#{(cur / $last_benchmark * 100).to_i - 100}% change)"
  rescue StandardError
    puts ''
  end
  $last_benchmark = cur
  result
end

# exit using `q`
alias q exit

# all available methods explaination
def ll
  puts '============================================================================================================='
  puts 'Welcome to rails console. Here are few list of pre-defined methods you can use.'
  puts '============================================================================================================='
  puts 'obj.sl(:method) ------> source location e.g lead.sl(:name)'
  puts 'obj.ocode(:method) ---> open method in nvim e.g lead.ocode(:name)'
  puts 'obj.dispsoc(:method) -> display method source in rails console e.g lead.dispsoc(:name)'
  puts 'obj.oo ---------------> open object json in vs code e.g lead.oo'
  puts 'hist(n) --------------> command history e.g hist(10)'
  puts 'cp(str) --------------> copy string in clipboard e.g cp(lead.name)'
  puts 'bm(block) ------------> benchmarking for block passed as an argument e.g bm { Lead.all.pluck(:stage);0 }'
  puts '============================================================================================================='
end

#### Customize Rails Console Prompt ####

def app_prompt
  rails_klass = Rails.application.class

  app_name =
    if rails_klass.respond_to? :module_parent
      rails_klass.module_parent
    else
      rails_klass.parent
    end

  Rainbow(app_name.name).blue
end

# target log path for irb history
def log_path
  rails_root = Rails.root
  "#{rails_root}/log/.irb-save-history"
end

def env_prompt
  case Rails.env
  when 'development'
    Rainbow('development').green
  when 'production'
    Rainbow('production').red
  else
    Rainbow(Rails.env.to_s).yellow
  end
end

if defined?(Rails)
  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join
  IRB.conf[:PROMPT] ||= {}

  prompt = "#{app_prompt}[#{env_prompt}]:%03n "

  IRB.conf[:PROMPT][:RAILS] = {
    PROMPT_I: "#{prompt}>> ",
    PROMPT_N: "#{prompt}> ",
    PROMPT_S: "#{prompt}* ",
    PROMPT_C: "#{prompt}? ",
    RETURN: "  => %s\n"
  }
  IRB.conf[:PROMPT_MODE] = :RAILS
end
