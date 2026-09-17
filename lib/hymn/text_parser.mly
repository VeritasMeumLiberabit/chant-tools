/* parser.mly */

%{
  open Types
  let prepare_word w =
    let end_pos = match w with
     | (_, _, end_pos) :: _ -> end_pos
     | _ -> failwith "ERROR"
    in
    let syllables = List.rev w in
    let start_pos = match w with
      | (_, start_pos, _) :: _ -> start_pos
      | _ -> failwith "ERROR"
    in
    {syllables; start_pos; end_pos}
  
  let prepare_line (l: word list) : line =
    let end_pos = match l with
     | {end_pos} :: _ -> end_pos
     | _ -> failwith "ERROR"
    in
    let words = List.rev l in
    let start_pos = match l with
      | {start_pos} :: _ -> start_pos
      | _ -> failwith "ERROR"
    in
    let syllable_count = 0 in
    {syllable_count; words; start_pos; end_pos}
  
  let prepare_verse (v: line list) : verse =
    let end_pos = match v with
     | {end_pos} :: _ -> end_pos
     | _ -> failwith "ERROR"
    in
    let lines = List.rev v in
    let start_pos = match lines with
      | {start_pos} :: _ -> start_pos
      | _ -> failwith "ERROR"
    in
    {lines; meter=[]; start_pos; end_pos}
  
  let prepare_text (v: verse list) : hymn_text =
    let end_pos = match v with
     | {end_pos} :: _ -> end_pos
     | _ -> failwith "ERROR"
    in
    let verses = List.rev v in
    let start_pos = match verses with
      | {start_pos} :: _ -> start_pos
      | _ -> failwith "ERROR"
    in
    {verses; start_pos; end_pos}
%}

%token <string * Stdlib.Lexing.position * Stdlib.Lexing.position> SYLLABLE
%token <Stdlib.Lexing.position * Stdlib.Lexing.position> SEPARATOR
%token <Stdlib.Lexing.position * Stdlib.Lexing.position> NEWLINE
%token <Stdlib.Lexing.position * Stdlib.Lexing.position> SPACE
%token <Stdlib.Lexing.position * Stdlib.Lexing.position> VERSE_SEPARATOR
%token EOF

%start <hymn_text> hymn_text

%%

hymn_text: v=verses EOF { prepare_text v }

verses:
  | v=verse { [prepare_verse v] }
  | vs=verses VERSE_SEPARATOR v=verse { prepare_verse v :: vs }

verse:
  | l=words { [prepare_line l] }
  | v=verse NEWLINE l=words { prepare_line l :: v }

words:
  | w=word { [prepare_word w] }
  | ws=words SPACE w=word { prepare_word w :: ws }

word:
  | s=SYLLABLE { [s] }
  | w=word SEPARATOR s=SYLLABLE { s :: w }
