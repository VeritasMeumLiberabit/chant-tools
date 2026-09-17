type word =
  { syllables : (string * Stdlib.Lexing.position * Stdlib.Lexing.position) list;
    start_pos : Stdlib.Lexing.position;
    end_pos : Stdlib.Lexing.position }

type line =
  { syllable_count : int;
    words : word list;
    start_pos : Stdlib.Lexing.position;
    end_pos : Stdlib.Lexing.position }

type verse =
  { meter : int list;
    lines : line list;
    start_pos : Stdlib.Lexing.position;
    end_pos : Stdlib.Lexing.position }

type hymn_text =
  { verses : verse list;
    start_pos : Stdlib.Lexing.position;
    end_pos : Stdlib.Lexing.position }
