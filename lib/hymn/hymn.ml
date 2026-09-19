open Types

type error_code = SyntaxError

let code_to_string code =
  match code with
  | SyntaxError -> "Syntax Error"

let diagnostic_from_menhir_error filename content env =
  let start_pos, end_pos = Text_parser.MenhirInterpreter.positions env in
  let message = Text_parser_error_messages.message (Text_parser.MenhirInterpreter.current_state_number env) in
  let message = Grace.Diagnostic.Message.create message in
  let source : Grace.Source.t = `String {name = filename; content} in
  let range = Grace.Range.create ~source (Grace.Byte_index.of_lex start_pos) (Grace.Byte_index.of_lex end_pos) in
  let diagnostic = Grace.Diagnostic.(createf ~labels:Label.[primary ~range message] ~code:SyntaxError Error "") in
  Error
    (Format.asprintf "%a@."
       (Grace_ansi_renderer.pp_diagnostic
          ?config:
            (Some
               {Grace_ansi_renderer.Config.default with num_contextual_lines = 4; enable_inline_contextual_lines = true}
            )
          ~code_to_string )
       diagnostic )

let fail filename content checkpoint =
  match checkpoint with
  | Text_parser.MenhirInterpreter.HandlingError env -> diagnostic_from_menhir_error filename content env
  | _ -> Error "Unknown error"

let succeed (a : hymn_text) = Ok a

let parse_text filename input =
  let buf = Sedlexing.Utf8.from_string input in
  let supplier = Text_lexer.tokenize_incremental buf in
  let buffer, supplier = MenhirLib.ErrorReports.wrap_supplier supplier in
  let checkpoint = Text_parser.Incremental.hymn_text (Sedlexing.lexing_position_start buf) in
  Text_parser.MenhirInterpreter.loop_handle succeed (fail filename input) supplier checkpoint

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
    Format.fprintf fmt " \"%s\"; " syllable
  in
  Format.fprintf fmt "{ syllables = [" ;
  List.iter format_syllable word.syllables ;
  Format.fprintf fmt "] }"

let fmt_line fmt line =
  Format.fprintf fmt "Line { syllable_count = %d; words = [" line.syllable_count ;
  List.iter (fmt_word fmt) line.words ;
  Format.fprintf fmt "] }\n"

let fmt_verse fmt verse =
  Format.fprintf fmt "{ meter = [" ;
  List.iter (fmt_line fmt) verse.lines ;
  Format.fprintf fmt "] }\n"

let fmt_text fmt hymn_text =
  List.iter (fmt_verse fmt) hymn_text.verses ;
  Format.fprintf fmt "\n"
