use strict; use warnings;
package Inline::C::ParsePegex::Grammar;

use Pegex::Base;
extends 'Pegex::Grammar';

use constant file => 'share/inline-c.pgx';

sub make_tree {
  {
    '+grammar' => 'inline-c',
    '+toprule' => 'code',
    '+version' => '0.0.1',
    'ALL' => {
      '.rgx' => qr/\G[\s\S]/
    },
    'COMMA' => {
      '.rgx' => qr/\G,/
    },
    'LPAREN' => {
      '.rgx' => qr/\G\(/
    },
    'anything_else' => {
      '.rgx' => qr/\G.*(?:\r?\n|\z)/
    },
    'arg' => {
      '.rgx' => qr/\G(?:\s*(?:(?:(?:unsigned|long|extern|const)\b\s*)*((?:\w+))\s*(\**)|(?:(?:unsigned|long|extern|const)\b\s*)*\**)\s*\s*((?:\w+))|(\.\.\.))/
    },
    'arg_decl' => {
      '.rgx' => qr/\G(\s*(?:(?:(?:unsigned|long|extern|const)\b\s*)*((?:\w+))\s*(\**)|(?:(?:unsigned|long|extern|const)\b\s*)*\**)\s*\s*(?:\w+)*|\.\.\.)/
    },
    'code' => {
      '+min' => 1,
      '.ref' => 'part'
    },
    'comment' => {
      '.any' => [
        {
          '.rgx' => qr/\G\s*\/\/[^\n]*\n/
        },
        {
          '.rgx' => qr/\G\s*\/\*(?:[^\*]+|\*(?!\/))*\*\/([\t]*)?/
        }
      ]
    },
    'function_declaration' => {
      '.all' => [
        {
          '.ref' => 'rtype'
        },
        {
          '.rgx' => qr/\G((?:\w+))/
        },
        {
          '.ref' => 'LPAREN'
        },
        {
          '+max' => 1,
          '.all' => [
            {
              '.ref' => 'arg_decl'
            },
            {
              '+min' => 0,
              '-flat' => 1,
              '.all' => [
                {
                  '.ref' => 'COMMA'
                },
                {
                  '.ref' => 'arg_decl'
                }
              ]
            }
          ]
        },
        {
          '.rgx' => qr/\G\s*\)\s*;\s*/
        }
      ]
    },
    'function_definition' => {
      '.all' => [
        {
          '.ref' => 'rtype'
        },
        {
          '.rgx' => qr/\G((?:\w+))/
        },
        {
          '.ref' => 'LPAREN'
        },
        {
          '+max' => 1,
          '.all' => [
            {
              '.ref' => 'arg'
            },
            {
              '+min' => 0,
              '-flat' => 1,
              '.all' => [
                {
                  '.ref' => 'COMMA'
                },
                {
                  '.ref' => 'arg'
                }
              ]
            }
          ]
        },
        {
          '.rgx' => qr/\G\s*\)\s*\{\s*/
        }
      ]
    },
    'part' => {
      '.all' => [
        {
          '+asr' => 1,
          '.ref' => 'ALL'
        },
        {
          '.any' => [
            {
              '.ref' => 'comment'
            },
            {
              '.ref' => 'function_definition'
            },
            {
              '.ref' => 'function_declaration'
            },
            {
              '.ref' => 'anything_else'
            }
          ]
        }
      ]
    },
    'rtype' => {
      '.rgx' => qr/\G\s*(?:(?:(?:unsigned|long|extern|const)\b\s*)*((?:\w+))\s*(\**)|(?:(?:unsigned|long|extern|const)\b\s*)+\**)\s*/
    }
  }
}

1;