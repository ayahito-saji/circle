#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'


require 'strscan'
require 'pp'

class NStackRadiusParser < Racc::Parser

module_eval(<<'...end n_stack_radius_parser.ry/module_eval...', 'stone_parser.ry', 108)

def parse(str)
    scanner = StringScanner.new(str)
    @q = []
    while !scanner.eos?
        scanner.scan(/[\s\n]+/)
        scanner.scan(/\<=/) ?                       @q << ['<=', '<='] :
        scanner.scan(/\>=/) ?                       @q << ['>=', '>='] :
        scanner.scan(/\</) ?                        @q << ['<', '<'] :
        scanner.scan(/\>/) ?                        @q << ['>', '>'] :
        scanner.scan(/\==/) ?                       @q << ['==', '=='] :
        scanner.scan(/\!=/) ?                       @q << ['!=', '!='] :
        scanner.scan(/\".*?\"/) ?                   @q << [:STRING, scanner.matched[1..-2]] :
        scanner.scan(/\'.*?\'/) ?                   @q << [:STRING, scanner.matched[1..-2]] :
        scanner.scan(/[a-zA-Z_][a-zA-Z0-9_]*/) ?
        (case scanner.matched.to_s
            when "phase"
                @q << [:PHASE, :PHASE]
            when "true"
                @q << [:BOOLEAN, true]
            when "false"
                @q << [:BOOLEAN, false]
            when "do"
                @q << [:DO, :do]
            when "goto"
                @q << [:GOTO, :goto]
            when "if"
                @q << [:IF, :if]
            when "else"
                @q << [:ELSE, :else]
            when "for"
                @q << [:FOR, :for]
            else
                @q << [:IDENTIFIER, scanner.matched.to_s]
        end) :
        scanner.scan(/([0-9]*\.[0-9]+)/) ?          @q << [:NUMBER, scanner.matched.to_f] :
        scanner.scan(/(0|[1-9][0-9]*)/) ?           @q << [:NUMBER, scanner.matched.to_i] :
        scanner.scan(/./) ?                         @q << [scanner.matched, scanner.matched] :
        raise("parse error")
    end
    tree = do_parse
    pp tree
    convert(tree)
end

def next_token
    @q.shift
end

def convert(tree)
    stack = [tree]
    operations = []
    while !stack.empty?
        node = stack.pop()
        # node[0]はノードの識別子
        # node[1]はノードの持つ固有値(値)
        # node[2]はノードの持つ引数(配列)
        #puts "NODE:#{node[0]}"
        #puts "CHILDREN:#{node[2]}"
        case node[0]
            when :phase # phase文は特別な処理を行う
                node[2].each do |child|
                    stack.push(child)
                end
                operations.push([:phase, convert(node[1]), node[2].length])

            when :do # do文は特別な処理を行う
                node[2].each do |child|
                    stack.push(child)
                end
                operations.push([:do, convert(node[1]), node[2].length])

            when :if # if文は特別な処理を行う
                if_sets = node[1].map {|child| convert(child)}
                operations.push([:if, if_sets, 0])

            when :for # for文は特別な処理を行う
                node[2].each do |child|
                    stack.push(child)
                end

                for_sets = node[1].map {|child| convert(child)}
                operations.push([:for, for_sets, node[2].length])
            else        # それ以外は同じ
                if node[2]
                    node[2].each do |child|
                        stack.push(child)
                    end
                    operations.push([node[0], node[1], node[2].length])
                else
                    operations.push([node[0], node[1], 0])
                end
        end
    end
    operations
end

...end n_stack_radius_parser.ry/module_eval...
##### State transition tables begin ###

racc_action_table = [
    44,    45,    46,    42,    43,   -57,   -57,   -57,   -57,   -57,
   -57,    44,    45,    46,    42,    43,    47,    48,    49,    50,
    51,    52,    89,    68,     8,    69,    44,    45,    46,    44,
    45,    46,    60,   109,    40,    88,    41,    44,    45,    46,
    42,    43,    47,    48,    49,    50,    51,    52,    30,    68,
    91,    69,    68,     3,    69,    93,    85,    84,    92,    68,
    68,    69,    69,    44,    45,    46,    42,    43,    47,    48,
    49,    50,    51,    52,    44,    45,    46,    42,    43,    47,
    48,    49,    50,    51,    52,    32,    68,    87,    69,    34,
    86,   111,    85,    33,    68,     8,    69,    68,    34,    69,
    44,    45,    46,    42,    43,    47,    48,    49,    50,    51,
    52,    44,    45,    46,    42,    43,   -57,   -57,   -57,   -57,
   -57,   -57,    68,    68,    69,    69,    66,    61,     8,    39,
    38,     9,     8,     6,    68,   120,    69,    44,    45,    46,
    42,    43,    47,    48,    49,    50,    51,    52,    44,    45,
    46,    42,    43,   -57,   -57,   -57,   -57,   -57,   -57,   121,
    68,     5,    69,    30,    99,    97,   nil,   nil,   nil,   nil,
   nil,    68,   nil,    69,    44,    45,    46,    42,    43,    47,
    48,    49,    50,    51,    52,    44,    45,    46,    42,    43,
    47,    48,    49,    50,    51,    52,   nil,    68,   nil,    69,
   nil,   nil,   nil,   nil,   114,   nil,   nil,   nil,    68,   nil,
    69,    44,    45,    46,    42,    43,    47,    48,    49,    50,
    51,    52,   nil,    67,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    68,   nil,    69,    44,    45,    46,
    42,    43,    47,    48,    49,    50,    51,    52,    44,    45,
    46,    42,    43,    47,    48,    49,    50,    51,    52,   nil,
    68,   107,    69,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    68,    98,    69,    44,    45,    46,    42,    43,    47,
    48,    49,    50,    51,    52,    44,    45,    46,    42,    43,
    47,    48,    49,    50,    51,    52,   nil,    68,   nil,    69,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    68,   nil,
    69,    44,    45,    46,    42,    43,   -57,   -57,   -57,   -57,
   -57,   -57,   nil,    44,    45,    46,    42,    43,    47,    48,
    49,    50,    51,    52,    68,   112,    69,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    68,   nil,    69,    44,
    45,    46,    42,    43,   -57,   -57,   -57,   -57,   -57,   -57,
    44,    45,    46,    42,    43,   -57,   -57,   -57,   -57,   -57,
   -57,    28,    68,   nil,    69,    28,   nil,    26,   nil,   nil,
   nil,    26,    27,    68,   nil,    69,    27,    29,    30,    31,
     8,    29,    30,    31,     8,    28,   nil,   nil,   nil,    28,
   nil,    26,   nil,   nil,   nil,    26,    27,   nil,   nil,   nil,
    27,    29,    30,    31,     8,    29,    30,    31,     8,    28,
   nil,   nil,   nil,    28,   nil,    26,   nil,   nil,   nil,    26,
    27,   nil,   nil,   nil,    27,    29,    30,    31,     8,    29,
    30,    31,     8,    28,   nil,   nil,   nil,    28,   106,    26,
    14,   nil,    15,    26,    27,   nil,    22,   nil,    27,    29,
    30,    31,     8,    29,    30,    31,     8,    28,   nil,   nil,
   nil,    28,   nil,    26,   nil,   nil,   nil,    26,    27,   nil,
   nil,   nil,    27,    29,    30,    31,     8,    29,    30,    31,
     8,    28,   nil,   nil,   nil,    28,   103,    26,    14,   nil,
    15,    26,    27,   nil,    22,   nil,    27,    29,    30,    31,
     8,    29,    30,    31,     8,    28,   123,   nil,    14,   nil,
    15,    26,   nil,   nil,    22,   nil,    27,   nil,   nil,   nil,
   nil,    29,    30,    31,     8,    28,   119,   nil,    14,   nil,
    15,    26,   nil,   nil,    22,   nil,    27,   nil,   nil,   nil,
   nil,    29,    30,    31,     8,    28,    11,   nil,    14,    28,
    15,    26,   nil,   nil,    22,    26,    27,   nil,   nil,   nil,
    27,    29,    30,    31,     8,    29,    30,    31,     8,    28,
   nil,   nil,    14,    28,    15,    26,   nil,   nil,    22,    26,
    27,   nil,   nil,   nil,    27,    29,    30,    31,     8,    29,
    30,    31,     8,    28,   nil,   nil,   nil,   nil,   nil,    26,
   nil,   nil,    28,   nil,    27,   nil,   nil,   nil,    26,    29,
    30,    31,     8,    27,    57,   nil,    28,   nil,    29,    30,
    31,     8,    26,   nil,   nil,    28,   nil,    27,   nil,   nil,
   nil,    26,    29,    30,    31,     8,    27,   nil,   nil,    28,
   nil,    29,    30,    31,     8,    26,   nil,    64,   nil,   nil,
    27,   nil,   nil,   nil,   nil,    29,    30,    31,     8,    28,
   113,   nil,    14,   nil,    15,    26,   nil,   nil,    22,   nil,
    27,   nil,   nil,   nil,   nil,    29,    30,    31,     8,    28,
   nil,   nil,    14,    28,    15,    26,   nil,   nil,    22,    26,
    27,   nil,   nil,   nil,    27,    29,    30,    31,     8,    29,
    30,    31,     8,    28,   nil,   nil,   nil,    28,   nil,    26,
   nil,   nil,   nil,    26,    27,   nil,   nil,   nil,    27,    29,
    30,    31,     8,    29,    30,    31,     8,    28,   nil,   nil,
   nil,    28,   nil,    26,   nil,   nil,   nil,    26,    27,   nil,
   nil,   nil,    27,    29,    30,    31,     8,    29,    30,    31,
     8,    28,   nil,   nil,   nil,    28,   nil,    26,   nil,   nil,
   nil,    26,    27,   nil,   nil,   nil,    27,    29,    30,    31,
     8,    29,    30,    31,     8,    28,   nil,   nil,   nil,   nil,
   nil,    26,   nil,   nil,   nil,   nil,    27,   nil,   nil,   nil,
   nil,    29,    30,    31,     8 ]

racc_action_check = [
    79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
    79,    17,    17,    17,    17,    17,    17,    17,    17,    17,
    17,    17,    59,    79,    69,    79,    73,    73,    73,    74,
    74,    74,    28,    98,    17,    59,    17,    54,    54,    54,
    54,    54,    54,    54,    54,    54,    54,    54,    28,    73,
    63,    73,    74,     1,    74,    66,    63,    54,    66,    75,
    54,    75,    54,    55,    55,    55,    55,    55,    55,    55,
    55,    55,    55,    55,   101,   101,   101,   101,   101,   101,
   101,   101,   101,   101,   101,    12,    55,    58,    55,    12,
    56,   102,    56,    12,    76,    41,    76,   101,    37,   101,
   100,   100,   100,   100,   100,   100,   100,   100,   100,   100,
   100,    81,    81,    81,    81,    81,    81,    81,    81,    81,
    81,    81,    77,   100,    77,   100,    35,    32,    22,    16,
    15,     7,     5,     3,    81,   118,    81,    62,    62,    62,
    62,    62,    62,    62,    62,    62,    62,    62,    80,    80,
    80,    80,    80,    80,    80,    80,    80,    80,    80,   120,
    62,     2,    62,    88,    72,    70,   nil,   nil,   nil,   nil,
   nil,    80,   nil,    80,   110,   110,   110,   110,   110,   110,
   110,   110,   110,   110,   110,   108,   108,   108,   108,   108,
   108,   108,   108,   108,   108,   108,   nil,   110,   nil,   110,
   nil,   nil,   nil,   nil,   108,   nil,   nil,   nil,   108,   nil,
   108,    36,    36,    36,    36,    36,    36,    36,    36,    36,
    36,    36,   nil,    36,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    36,   nil,    36,    95,    95,    95,
    95,    95,    95,    95,    95,    95,    95,    95,    71,    71,
    71,    71,    71,    71,    71,    71,    71,    71,    71,   nil,
    95,    95,    95,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    71,    71,    71,   115,   115,   115,   115,   115,   115,
   115,   115,   115,   115,   115,   116,   116,   116,   116,   116,
   116,   116,   116,   116,   116,   116,   nil,   115,   nil,   115,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   116,   nil,
   116,    82,    82,    82,    82,    82,    82,    82,    82,    82,
    82,    82,   nil,   104,   104,   104,   104,   104,   104,   104,
   104,   104,   104,   104,    82,   104,    82,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   104,   nil,   104,    78,
    78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
    83,    83,    83,    83,    83,    83,    83,    83,    83,    83,
    83,    49,    78,   nil,    78,    50,   nil,    49,   nil,   nil,
   nil,    50,    49,    83,   nil,    83,    50,    49,    49,    49,
    49,    50,    50,    50,    50,    51,   nil,   nil,   nil,    52,
   nil,    51,   nil,   nil,   nil,    52,    51,   nil,   nil,   nil,
    52,    51,    51,    51,    51,    52,    52,    52,    52,    99,
   nil,   nil,   nil,    68,   nil,    99,   nil,   nil,   nil,    68,
    99,   nil,   nil,   nil,    68,    99,    99,    99,    99,    68,
    68,    68,    68,    97,   nil,   nil,   nil,    94,    94,    97,
    94,   nil,    94,    94,    97,   nil,    94,   nil,    94,    97,
    97,    97,    97,    94,    94,    94,    94,    92,   nil,   nil,
   nil,    85,   nil,    92,   nil,   nil,   nil,    85,    92,   nil,
   nil,   nil,    85,    92,    92,    92,    92,    85,    85,    85,
    85,    87,   nil,   nil,   nil,    90,    90,    87,    90,   nil,
    90,    90,    87,   nil,    90,   nil,    90,    87,    87,    87,
    87,    90,    90,    90,    90,   122,   122,   nil,   122,   nil,
   122,   122,   nil,   nil,   122,   nil,   122,   nil,   nil,   nil,
   nil,   122,   122,   122,   122,   117,   117,   nil,   117,   nil,
   117,   117,   nil,   nil,   117,   nil,   117,   nil,   nil,   nil,
   nil,   117,   117,   117,   117,    10,    10,   nil,    10,    14,
    10,    10,   nil,   nil,    10,    14,    10,   nil,   nil,   nil,
    14,    10,    10,    10,    10,    14,    14,    14,    14,   114,
   nil,   nil,   114,   111,   114,   114,   nil,   nil,   114,   111,
   114,   nil,   nil,   nil,   111,   114,   114,   114,   114,   111,
   111,   111,   111,    26,   nil,   nil,   nil,   nil,   nil,    26,
   nil,   nil,    27,   nil,    26,   nil,   nil,   nil,    27,    26,
    26,    26,    26,    27,    27,   nil,   109,   nil,    27,    27,
    27,    27,   109,   nil,   nil,    33,   nil,   109,   nil,   nil,
   nil,    33,   109,   109,   109,   109,    33,   nil,   nil,    34,
   nil,    33,    33,    33,    33,    34,   nil,    34,   nil,   nil,
    34,   nil,   nil,   nil,   nil,    34,    34,    34,    34,   105,
   105,   nil,   105,   nil,   105,   105,   nil,   nil,   105,   nil,
   105,   nil,   nil,   nil,   nil,   105,   105,   105,   105,    38,
   nil,   nil,    38,    40,    38,    38,   nil,   nil,    38,    40,
    38,   nil,   nil,   nil,    40,    38,    38,    38,    38,    40,
    40,    40,    40,    42,   nil,   nil,   nil,    43,   nil,    42,
   nil,   nil,   nil,    43,    42,   nil,   nil,   nil,    43,    42,
    42,    42,    42,    43,    43,    43,    43,    44,   nil,   nil,
   nil,    45,   nil,    44,   nil,   nil,   nil,    45,    44,   nil,
   nil,   nil,    45,    44,    44,    44,    44,    45,    45,    45,
    45,    46,   nil,   nil,   nil,    47,   nil,    46,   nil,   nil,
   nil,    47,    46,   nil,   nil,   nil,    47,    46,    46,    46,
    46,    47,    47,    47,    47,    48,   nil,   nil,   nil,   nil,
   nil,    48,   nil,   nil,   nil,   nil,    48,   nil,   nil,   nil,
   nil,    48,    48,    48,    48 ]

racc_action_pointer = [
   nil,    53,   148,   133,   nil,    99,   nil,   117,   nil,   nil,
   541,   nil,    69,   nil,   545,   110,   108,     9,   nil,   nil,
   nil,   nil,    95,   nil,   nil,   nil,   589,   598,    17,   nil,
   nil,   nil,   113,   621,   635,   108,   209,    78,   675,   nil,
   679,    62,   699,   703,   723,   727,   747,   751,   771,   357,
   361,   381,   385,   nil,    35,    61,    64,   nil,    58,     7,
   nil,   nil,   135,    28,   nil,   nil,    41,   nil,   409,    -9,
   144,   246,   140,    24,    27,    34,    69,    97,   347,    -2,
   146,   109,   309,   358,   nil,   457,   nil,   477,   132,   nil,
   481,   nil,   453,   nil,   433,   235,   nil,   429,     9,   405,
    98,    72,    62,   nil,   321,   655,   nil,   nil,   183,   612,
   172,   569,   nil,   nil,   565,   272,   283,   521,   113,   nil,
   145,   nil,   501,   nil ]

racc_action_default = [
    -2,   -57,    -1,   -57,    -3,   -57,   124,   -57,   -56,   -13,
   -57,    -4,   -43,    -8,   -57,   -57,   -14,   -16,   -17,   -18,
   -19,   -20,   -57,   -40,   -41,   -42,   -57,   -57,   -57,   -53,
   -54,   -55,   -57,   -57,   -57,   -10,   -57,   -43,   -57,   -15,
   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,
   -57,   -57,   -57,   -21,   -57,   -25,   -57,   -49,   -57,   -57,
   -51,   -13,   -22,   -57,   -47,    -6,   -57,   -13,   -57,   -57,
   -57,   -57,   -46,   -29,   -30,   -31,   -32,   -33,   -34,   -35,
   -36,   -37,   -38,   -39,   -44,   -57,   -50,   -57,   -57,   -52,
   -57,   -48,   -57,   -13,   -57,   -57,   -46,   -57,   -45,   -57,
   -26,   -27,   -57,    -5,   -57,   -57,    -7,   -45,   -57,   -57,
   -24,   -57,   -13,   -11,   -57,   -23,   -28,   -57,   -57,    -9,
   -57,   -13,   -57,   -12 ]

racc_goto_table = [
     7,    70,    10,    56,    65,    12,    58,     2,     4,    36,
    63,    35,     1,    59,   nil,   nil,   nil,    53,   nil,   nil,
   nil,    54,    55,   nil,   nil,   nil,   nil,   nil,    62,    55,
   nil,   nil,   nil,    12,   nil,    71,    72,    73,    74,    75,
    76,    77,    78,    79,    80,    81,    82,    83,   nil,   nil,
   nil,   nil,   nil,   nil,    90,   nil,   nil,   nil,   nil,   nil,
    94,   nil,   nil,    95,    96,   nil,   102,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   118,   nil,   nil,
   100,   nil,   101,   nil,   nil,    12,   105,   104,   nil,    12,
   nil,   nil,   108,   nil,   110,   nil,   nil,   nil,   nil,   nil,
    12,   nil,   nil,   nil,   115,   117,   116,   nil,   nil,    12,
   nil,   nil,    12,   nil,   122,   nil,   nil,    12 ]

racc_goto_check = [
     4,    13,     5,    15,    10,     4,    17,     2,     3,    11,
    15,     9,     1,    16,   nil,   nil,   nil,     4,   nil,   nil,
   nil,    11,    11,   nil,   nil,   nil,   nil,   nil,    11,    11,
   nil,   nil,   nil,     4,   nil,    11,     4,    11,    11,    11,
    11,    11,    11,    11,    11,    11,    11,    11,   nil,   nil,
   nil,   nil,   nil,   nil,     5,   nil,   nil,   nil,   nil,   nil,
     5,   nil,   nil,    11,     4,   nil,    17,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    13,   nil,   nil,
    11,   nil,    11,   nil,   nil,     4,     5,    11,   nil,     4,
   nil,   nil,    11,   nil,    11,   nil,   nil,   nil,   nil,   nil,
     4,   nil,   nil,   nil,    11,     5,    11,   nil,   nil,     4,
   nil,   nil,     4,   nil,     5,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,    12,     7,     6,    -5,    -7,   nil,   nil,   nil,    -2,
   -31,    -5,   nil,   -37,   nil,   -24,   -15,   -22,   nil,   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    37,   nil,    19,    20,    13,   nil,
   nil,    17,    21,    16,    18,   nil,   nil,    24,    23,    25 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 35, :_reduce_1,
  0, 36, :_reduce_2,
  2, 36, :_reduce_3,
  5, 37, :_reduce_4,
  5, 40, :_reduce_5,
  3, 41, :_reduce_6,
  5, 42, :_reduce_7,
  0, 43, :_reduce_8,
  7, 43, :_reduce_9,
  0, 44, :_reduce_10,
  4, 44, :_reduce_11,
  11, 46, :_reduce_12,
  0, 39, :_reduce_13,
  2, 39, :_reduce_14,
  3, 39, :_reduce_15,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  2, 47, :_reduce_21,
  3, 48, :_reduce_22,
  6, 48, :_reduce_23,
  5, 48, :_reduce_24,
  1, 49, :_reduce_25,
  3, 49, :_reduce_26,
  3, 50, :_reduce_27,
  5, 50, :_reduce_28,
  3, 45, :_reduce_29,
  3, 45, :_reduce_30,
  3, 45, :_reduce_31,
  3, 45, :_reduce_32,
  3, 45, :_reduce_33,
  3, 45, :_reduce_34,
  3, 45, :_reduce_35,
  3, 45, :_reduce_36,
  3, 45, :_reduce_37,
  3, 45, :_reduce_38,
  3, 45, :_reduce_39,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_43,
  3, 45, :_reduce_44,
  4, 45, :_reduce_45,
  3, 45, :_reduce_46,
  3, 45, :_reduce_47,
  4, 45, :_reduce_48,
  2, 45, :_reduce_49,
  3, 45, :_reduce_50,
  2, 45, :_reduce_51,
  3, 45, :_reduce_52,
  1, 52, :_reduce_53,
  1, 51, :_reduce_54,
  1, 53, :_reduce_55,
  1, 38, :_reduce_56 ]

racc_reduce_n = 57

racc_shift_n = 124

racc_token_table = {
  false => 0,
  :error => 1,
  "*" => 2,
  "/" => 3,
  "%" => 4,
  "+" => 5,
  "-" => 6,
  "==" => 7,
  "!=" => 8,
  "<" => 9,
  "<=" => 10,
  ">" => 11,
  ">=" => 12,
  :PHASE => 13,
  "{" => 14,
  "}" => 15,
  :DO => 16,
  :IF => 17,
  :ELSE => 18,
  :FOR => 19,
  "(" => 20,
  ";" => 21,
  ")" => 22,
  :GOTO => 23,
  "=" => 24,
  "[" => 25,
  "]" => 26,
  "." => 27,
  "," => 28,
  ":" => 29,
  :NUMBER => 30,
  :STRING => 31,
  :BOOLEAN => 32,
  :IDENTIFIER => 33 }

racc_nt_base = 34

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
  "\"%\"",
  "\"+\"",
  "\"-\"",
  "\"==\"",
  "\"!=\"",
  "\"<\"",
  "\"<=\"",
  "\">\"",
  "\">=\"",
  "PHASE",
  "\"{\"",
  "\"}\"",
  "DO",
  "IF",
  "ELSE",
  "FOR",
  "\"(\"",
  "\";\"",
  "\")\"",
  "GOTO",
  "\"=\"",
  "\"[\"",
  "\"]\"",
  "\".\"",
  "\",\"",
  "\":\"",
  "NUMBER",
  "STRING",
  "BOOLEAN",
  "IDENTIFIER",
  "$start",
  "program",
  "phases",
  "phase",
  "identifier",
  "statements",
  "do_statement",
  "if_else_statement",
  "if_statement",
  "elsif_statements",
  "else_statement",
  "expr",
  "for_statement",
  "statement",
  "assign_statement",
  "arguments",
  "key_values",
  "string",
  "number",
  "boolean" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'stone_parser.ry', 9)
  def _reduce_1(val, _values, result)
    result = [:program, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 12)
  def _reduce_2(val, _values, result)
    result = [:phases, nil, []]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 13)
  def _reduce_3(val, _values, result)
    result[2] << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 16)
  def _reduce_4(val, _values, result)
    result = [:phase, val[3], [val[1]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 19)
  def _reduce_5(val, _values, result)
    result = [:do, val[3], [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 22)
  def _reduce_6(val, _values, result)
    result = [:if, val[0] + val[1] + val[2], nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 25)
  def _reduce_7(val, _values, result)
    result = [val[1], val[3]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 28)
  def _reduce_8(val, _values, result)
    result = []
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 29)
  def _reduce_9(val, _values, result)
    result << val[3] << val[5]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 32)
  def _reduce_10(val, _values, result)
    result = [[:boolean, true, nil], [:statements, nil, []]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 33)
  def _reduce_11(val, _values, result)
    result = [[:boolean, true, nil], val[2]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 36)
  def _reduce_12(val, _values, result)
    val[9][2] << val[6];result = [:for, [val[4], val[9]], [val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 39)
  def _reduce_13(val, _values, result)
    result = [:statements, nil, []]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 40)
  def _reduce_14(val, _values, result)
    result[2] << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 41)
  def _reduce_15(val, _values, result)
    result[2] << val[1]
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

# reduce 18 omitted

# reduce 19 omitted

# reduce 20 omitted

module_eval(<<'.,.,', 'stone_parser.ry', 49)
  def _reduce_21(val, _values, result)
    result = [:goto, nil, [val[1]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 52)
  def _reduce_22(val, _values, result)
    result = [:assign_variable, nil, [val[2], val[0], [:null, nil, nil]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 53)
  def _reduce_23(val, _values, result)
    result = [:assign_variable, nil, [val[5], val[2], val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 54)
  def _reduce_24(val, _values, result)
    result = [:assign_variable, nil, [val[4], val[2], val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 58)
  def _reduce_25(val, _values, result)
    result = [:arguments, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 59)
  def _reduce_26(val, _values, result)
    result[2] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 62)
  def _reduce_27(val, _values, result)
    result = [:key_values, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 63)
  def _reduce_28(val, _values, result)
    result[2] << val[2] << val[4]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 66)
  def _reduce_29(val, _values, result)
    result = [:add, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 67)
  def _reduce_30(val, _values, result)
    result = [:dif, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 68)
  def _reduce_31(val, _values, result)
    result = [:mul, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 69)
  def _reduce_32(val, _values, result)
    result = [:div, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 70)
  def _reduce_33(val, _values, result)
    result = [:mod, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 71)
  def _reduce_34(val, _values, result)
    result = [:eq,  nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 72)
  def _reduce_35(val, _values, result)
    result = [:neq, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 73)
  def _reduce_36(val, _values, result)
    result = [:lt,  nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 74)
  def _reduce_37(val, _values, result)
    result = [:lte, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 75)
  def _reduce_38(val, _values, result)
    result = [:gt,  nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 76)
  def _reduce_39(val, _values, result)
    result = [:gte, nil, [val[0], val[2]]]
    result
  end
.,.,

# reduce 40 omitted

# reduce 41 omitted

# reduce 42 omitted

module_eval(<<'.,.,', 'stone_parser.ry', 80)
  def _reduce_43(val, _values, result)
    result = [:reference_variable, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 81)
  def _reduce_44(val, _values, result)
    result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 82)
  def _reduce_45(val, _values, result)
    result = [:index, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 83)
  def _reduce_46(val, _values, result)
    result = [:index, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 84)
  def _reduce_47(val, _values, result)
    result = [:call_function, nil, [val[0]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 85)
  def _reduce_48(val, _values, result)
    result = [:call_function, nil, [val[0], val[2]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 86)
  def _reduce_49(val, _values, result)
    result = [:define_array, nil, nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 87)
  def _reduce_50(val, _values, result)
    result = [:define_array, nil, [val[1]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 88)
  def _reduce_51(val, _values, result)
    result = [:define_hash, nil, nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 89)
  def _reduce_52(val, _values, result)
    result = [:define_hash, nil, [val[1]]]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 92)
  def _reduce_53(val, _values, result)
    result = [:number, val[0], nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 94)
  def _reduce_54(val, _values, result)
    result = [:string, val[0], nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 96)
  def _reduce_55(val, _values, result)
    result = [:boolean, val[0], nil]
    result
  end
.,.,

module_eval(<<'.,.,', 'stone_parser.ry', 98)
  def _reduce_56(val, _values, result)
    result = [:identifier, val[0], nil]
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class NStackRadiusParser


if __FILE__ == $0
    parser = NStackRadiusParser.new
    prg = ""
    File.open("program.rlb", "r") do |f|
        prg = f.read.chomp
    end
    pp parser.parse(prg)

end
