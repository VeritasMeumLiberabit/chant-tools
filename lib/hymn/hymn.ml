open Types

let fail checkpoint =
  match checkpoint with
  | Text_parser.MenhirInterpreter.HandlingError e ->
      Error "Syntax error at state number "
  | _ -> Error "Unknown error"

let succeed (a : hymn_text) = Ok a

let parse_text input =
  let buf = Sedlexing.Utf8.from_string input in
  let supplier = Text_lexer.tokenize_incremental buf in
  let buffer, supplier = MenhirLib.ErrorReports.wrap_supplier supplier in
  let checkpoint = Text_parser.Incremental.hymn_text (Sedlexing.lexing_position_start buf) in
  Text_parser.MenhirInterpreter.loop_handle succeed fail supplier checkpoint

let word_to_string word =
  let syllables = List.map (fun (a, b, c) -> a) word.syllables in
  String.concat "" syllables

let line_to_string line =
  let words = List.map word_to_string line.words in
  String.concat " " words

let verse_to_string verse =
  let lines = List.map line_to_string verse.lines in
  String.concat "\n" lines

let text_to_string hymn_text =
  let verses = List.map verse_to_string hymn_text.verses in
  String.concat "\n\n" verses

let fmt_word fmt word =
  let format_syllable syllable =
    let syllable, _, _ = syllable in
    Format.fprintf fmt "%s" syllable
  in
  List.iter format_syllable word.syllables ;
  Format.fprintf fmt " "

let fmt_word fmt word =
  let format_syllable syllable =
    let syllable, _, _ = syllable in
    Format.fprintf fmt "%s" syllable
  in
  List.iter format_syllable word.syllables ;
  Format.fprintf fmt " "

let fmt_line fmt line =
  List.iter (fmt_word fmt) line.words ;
  Format.fprintf fmt "\n"

let fmt_verse fmt verse =
  List.iter (fmt_line fmt) verse.lines ;
  Format.fprintf fmt "\n"

let fmt_text fmt hymn_text =
  List.iter (fmt_verse fmt) hymn_text.verses ;
  Format.fprintf fmt "\n"
