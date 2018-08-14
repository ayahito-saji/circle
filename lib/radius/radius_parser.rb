#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'


require 'strscan'
require 'pp'

module Radius
  class RadiusParser < Racc::Parser

module_eval(<<'...end radius_parser.ry/module_eval...', 'radius_parser.ry', 56)

def parse(str)
    scanner = StringScanner.new(str)
    @q = []
    line = 1
    while !scanner.eos?
        scanner.scan(/\n/) ?                        line += 1 :
        scanner.scan(/\s/) ?                        nil :
        scanner.scan(/\<=/) ?                       @q << ['<=', {value: '<=', line: line}] :
        scanner.scan(/\>=/) ?                       @q << ['>=', {value: '>=', line: line}] :
        scanner.scan(/\</) ?                        @q << ['<', {value: '<', line: line}] :
        scanner.scan(/\>/) ?                        @q << ['>', {value: '>', line: line}] :
        scanner.scan(/\==/) ?                       @q << ['==', {value: '==', line: line}] :
        scanner.scan(/\!=/) ?                       @q << ['!=', {value: '!=', line: line}] :
        scanner.scan(/\".*?\"/) ?                   @q << [:STRING, {value: scanner.matched[1..-2], line: line}] :
        scanner.scan(/\'.*?\'/) ?                   @q << [:STRING, {value: scanner.matched[1..-2], line: line}] :
        scanner.scan(/[a-zA-Z_][a-zA-Z0-9_]*/) ?
        (case scanner.matched.to_s
            when "phase"
                                                    @q << [:PHASE, {value: 'phase', line: line}]
            when "true"
                                                    @q << [:BOOLEAN, {value: 'true', line: line}]
            when "false"
                                                    @q << [:BOOLEAN, {value: 'false', line: line}]
            when "do"
                                                    @q << [:DO, {value: 'do', line: line}]
            when "goto"
                                                    @q << [:GOTO, {value: 'goto', line: line}]
            when "if"
                                                    @q << [:IF, {value: 'if', line: line}]
            when "else"
                                                    @q << [:ELSE, {value: 'else', line: line}]
            when "for"
                                                    @q << [:FOR, {value: 'for', line: line}]
            else
                                                    @q << [:IDENTIFIER, {value: scanner.matched.to_s, line: line}]
        end) :
        scanner.scan(/([0-9]*\.[0-9]+)/) ?          @q << [:NUMBER, {value:scanner.matched.to_f, line: line}] :
        scanner.scan(/(0|[1-9][0-9]*)/) ?           @q << [:NUMBER, {value: scanner.matched.to_i, line: line}] :
        scanner.scan(/./) ?                         @q << [scanner.matched, {value: scanner.matched, line: line}] :
        raise("読み込みエラー: プログラムが読み込めません. (#{line}行目)")
    end
    puts "TOKEN: #{@q}"
    tree = do_parse
    puts "TREE:"
    p tree
    puts
    return tree
end

def next_token
    @q.shift
end

def on_error (error_token_id, error_value, value_stack)
    raise "文法エラー: 書き方に誤りがあります. '#{error_value[:value]}' (#{error_value[:line]}行目)"
end

...end radius_parser.ry/module_eval...
##### State transition tables begin ###

racc_action_table = [
    24,    25,    22,    23,    24,    25,    12,    10,    15,    17,
    31,    20,     8,    17,     8,    20,     8,    17,     6,    20,
     8,    17,     5,    20,     8,    17,     3,    20,     8,    24,
    25,    22,    23,    17,    21,    20,     8,    24,    25 ]

racc_action_check = [
    26,    26,    26,    26,    28,    28,    11,     7,    11,    11,
    26,    11,    11,    24,     5,    24,    24,    23,     3,    23,
    23,    22,     2,    22,    22,    17,     1,    17,    17,    14,
    14,    14,    14,    25,    13,    25,    25,    27,    27 ]

racc_action_pointer = [
   nil,    26,    16,    18,   nil,     0,   nil,     0,   nil,   nil,
   nil,    -2,   nil,    25,    27,   nil,   nil,    14,   nil,   nil,
   nil,   nil,    10,     6,     2,    22,    -2,    35,     2,   nil,
   nil,   nil ]

racc_action_default = [
    -2,   -21,    -1,   -21,    -3,   -21,    32,   -21,   -20,    -4,
    -6,   -21,    -5,    -7,    -9,   -10,   -11,   -21,   -17,   -18,
   -19,    -8,   -21,   -21,   -21,   -21,   -21,   -12,   -13,   -14,
   -15,   -16 ]

racc_goto_table = [
    14,     2,     4,     7,     1,    11,    26,    13,     9,   nil,
   nil,    27,    28,    29,    30 ]

racc_goto_check = [
     8,     2,     3,     4,     1,     6,     8,     7,     5,   nil,
   nil,     8,     8,     8,     8 ]

racc_goto_pointer = [
   nil,     4,     1,     0,    -2,     1,    -5,    -4,   -11,   nil,
   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    19,   nil,   nil,   nil,   nil,    16,
    18 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 16, :_reduce_none,
  0, 17, :_reduce_2,
  2, 17, :_reduce_3,
  3, 18, :_reduce_4,
  3, 20, :_reduce_5,
  0, 21, :_reduce_6,
  2, 21, :_reduce_7,
  3, 21, :_reduce_8,
  1, 22, :_reduce_none,
  1, 22, :_reduce_none,
  1, 23, :_reduce_none,
  3, 23, :_reduce_12,
  3, 23, :_reduce_13,
  3, 23, :_reduce_14,
  3, 23, :_reduce_15,
  3, 23, :_reduce_16,
  1, 24, :_reduce_none,
  1, 24, :_reduce_18,
  1, 25, :_reduce_19,
  1, 19, :_reduce_20 ]

racc_reduce_n = 21

racc_shift_n = 32

racc_token_table = {
  false => 0,
  :error => 1,
  "*" => 2,
  "/" => 3,
  "+" => 4,
  "-" => 5,
  :PHASE => 6,
  "{" => 7,
  "}" => 8,
  ";" => 9,
  :assign_statement => 10,
  "(" => 11,
  ")" => 12,
  :NUMBER => 13,
  :IDENTIFIER => 14 }

racc_nt_base = 15

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "PHASE",
  "\"{\"",
  "\"}\"",
  "\";\"",
  "assign_statement",
  "\"(\"",
  "\")\"",
  "NUMBER",
  "IDENTIFIER",
  "$start",
  "program",
  "phases",
  "phase",
  "identifier",
  "block",
  "statements",
  "statement",
  "expr",
  "primary",
  "number" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

module_eval(<<'.,.,', 'radius_parser.ry', 10)
  def _reduce_2(val, _values, result)
    result = [:phases, nil, nil, []]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 11)
  def _reduce_3(val, _values, result)
    result[3] << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 14)
  def _reduce_4(val, _values, result)
    result = [:phase, nil, nil, [val[1], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 17)
  def _reduce_5(val, _values, result)
    result = [:block, nil, nil, val[1]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 20)
  def _reduce_6(val, _values, result)
    result = []
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 21)
  def _reduce_7(val, _values, result)
    result << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 22)
  def _reduce_8(val, _values, result)
    result << val[1]
    result
  end
.,.,

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

module_eval(<<'.,.,', 'radius_parser.ry', 31)
  def _reduce_12(val, _values, result)
    result = [:add, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 32)
  def _reduce_13(val, _values, result)
    result = [:dif, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 33)
  def _reduce_14(val, _values, result)
    result = [:mul, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 34)
  def _reduce_15(val, _values, result)
    result = [:dev, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 35)
  def _reduce_16(val, _values, result)
    result = val[1]
    result
  end
.,.,

# reduce 17 omitted

module_eval(<<'.,.,', 'radius_parser.ry', 39)
  def _reduce_18(val, _values, result)
    result = [:reference_variable, nil, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 42)
  def _reduce_19(val, _values, result)
    result = [:number, val[0][:line], val[0][:value], []]
    result
  end
.,.,

module_eval(<<'.,.,', 'radius_parser.ry', 45)
  def _reduce_20(val, _values, result)
    result = [:identifier, val[0][:line], val[0][:value], []]
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class RadiusParser
  end   # module Radius


if __FILE__ == $0
    parser = RadiusParser.new
    prg = ""
    File.open("program.rlb", "r") do |f|
        prg = f.read + "\n"
    end
    begin
        parser.parse(prg)
    rescue => e
        puts e
    end
end
