let rec token buf =
  match%sedlex buf with
  | "\n\n" ->
      Sedlexing.new_line buf ;
      Sedlexing.new_line buf ;
      Text_parser.VERSE_SEPARATOR (Sedlexing.lexing_positions buf)
  | Plus (Compl (Chars "| \t\r\n")) ->
      let lexeme = Sedlexing.Utf8.lexeme buf in
      let start, finish = Sedlexing.lexing_positions buf in
      Text_parser.SYLLABLE (lexeme, start, finish)
  | "\n" ->
      Sedlexing.new_line buf ;
      Text_parser.NEWLINE (Sedlexing.lexing_positions buf)
  | Plus (Chars " \t") -> Text_parser.SPACE (Sedlexing.lexing_positions buf)
  | "|" -> Text_parser.SEPARATOR (Sedlexing.lexing_positions buf)
  | eof -> Text_parser.EOF
  | _ -> failwith ("Unexpected character: " ^ Sedlexing.Utf8.lexeme buf)
(* TODO -- Make descriptive Message*)

let tokenize_incremental buf = Sedlexing.with_tokenizer token buf
