# frozen_string_literal: true

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'bk', 'pry-backtrace'
end

require 'awesome_print'
AwesomePrint.pry!

begin
  require 'hirb'
rescue LoadError
  puts 'Error loading Hirb'
end

Hirb.enable if defined? Hirb

require './config/application'
