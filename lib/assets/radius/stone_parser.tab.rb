#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'


require 'strscan'
require 'pp'

class StoneParser < Racc::Parser

module_eval(<<'...end stone_parser.ry/module_eval...', 'stone_parser.ry', 54)

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
end

def next_token
    @q.shift
end

def on_error (error_token_id, error_value, value_stack)
    raise "文法エラー: 書き方に誤りがあります. '#{error_value[:value]}' (#{error_value[:line]}行目)"
end

...end stone_parser.ry/module_eval...
##### State transition tables begin ###

racc_action_table = [
    23,    24,    21,    22,    23,    24,    12,    10,    16,    30,
    19,     8,    16,     8,    19,     8,    16,     6,    19,     8,
    16,     5,    19,     8,    16,     3,    19,     8,    23,    24,
    21,    22,    16,    20,    19,     8,    23,    24 ]

racc_action_check = [
    25,    25,    25,    25,    27,    27,    11,     7,    11,    25,
    11,    11,    23,     5,    23,    23,    22,     3,    22,    22,
    21,     2,    21,    21,    16,     1,    16,    16,    14,    14,
    14,    14,    24,    13,    24,    24,    26,    26 ]

racc_action_pointer = [
   nil,    25,    15,    17,   nil,     0,   nil,     0,   nil,   nil,
   nil,    -2,   nil,    24,    26,   nil,    14,   nil,   nil,   nil,
   nil,    10,     6,     2,    22,    -2,    34,     2,   nil,   nil,
   nil ]

racc_action_default = [
    -2,   -20,    -1,   -20,    -3,   -20,    31,   -20,   -19,    -4,
    -6,   -20,    -5,    -7,    -9,   -10,   -20,   -16,   -17,   -18,
    -8,   -20,   -20,   -20,   -20,   -20,   -11,   -12,   -13,   -14,
   -15 ]

racc_goto_table = [
    14,     2,     4,     7,     1,    25,    11,    13,     9,   nil,
    26,    27,    28,    29 ]

racc_goto_check = [
     8,     2,     3,     4,     1,     8,     6,     7,     5,   nil,
     8,     8,     8,     8 ]

racc_goto_pointer = [
   nil,     4,     1,     0,    -2,     1,    -4,    -4,   -11,   nil,
   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    18,   nil,   nil,   nil,   nil,    15,
    17 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 15, :_reduce_none,
  0, 16, :_reduce_2,
  2, 16, :_reduce_3,
  3, 17, :_reduce_4,
  3, 19, :_reduce_5,
  0, 20, :_reduce_6,
  2, 20, :_reduce_7,
  3, 20, :_reduce_8,
  1, 21, :_reduce_none,
  1, 22, :_reduce_none,
  3, 22, :_reduce_11,
  3, 22, :_reduce_12,
  3, 22, :_reduce_13,
  3, 22, :_reduce_14,
  3, 22, :_reduce_15,
  1, 23, :_reduce_none,
  1, 23, :_reduce_17,
  1, 24, :_reduce_18,
  1, 18, :_reduce_19 ]

racc_reduce_n = 20

racc_shift_n = 31

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
  "(" => 10,
  ")" => 11,
  :NUMBER => 12,
  :IDENTIFIER => 13 }

racc_nt_base = 14

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

module_eval(<<'.,.,', 'stone_parser.ry', 10)
  def _reduce_2(val, _values, result)
    result = [:phases, nil, nil, []]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 11)
  def _reduce_3(val, _values, result)
    result[3] << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 14)
  def _reduce_4(val, _values, result)
    result = [:phase, nil, nil, [val[1], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 17)
  def _reduce_5(val, _values, result)
    result = [:block, nil, nil, val[1]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 20)
  def _reduce_6(val, _values, result)
    result = []
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 21)
  def _reduce_7(val, _values, result)
    result << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 22)
  def _reduce_8(val, _values, result)
    result << val[1]
    result
  end
.,.,

# reduce 9 omitted

# reduce 10 omitted

module_eval(<<'.,.,', 'stone_parser.ry', 29)
  def _reduce_11(val, _values, result)
    result = [:add, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 30)
  def _reduce_12(val, _values, result)
    result = [:dif, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 31)
  def _reduce_13(val, _values, result)
    result = [:mul, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 32)
  def _reduce_14(val, _values, result)
    result = [:dev, val[1][:line], val[1][:value], [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 33)
  def _reduce_15(val, _values, result)
    result = val[1]
    result
  end
.,.,

# reduce 16 omitted

module_eval(<<'.,.,', 'stone_parser.ry', 37)
  def _reduce_17(val, _values, result)
    result = [:reference_variable, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 40)
  def _reduce_18(val, _values, result)
    result = [:number, val[0][:line], val[0][:value], []]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 43)
  def _reduce_19(val, _values, result)
    result = [:identifier, val[0][:line], val[0][:value], []]
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class StoneParser


if __FILE__ == $0
    parser = StoneParser.new
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